// stdlib
import * as fs from 'https://deno.land/std@0.81.0/fs/mod.ts'
import { parse } from 'https://deno.land/std@0.81.0/flags/mod.ts'
// community
import { readKeypress } from 'https://deno.land/x/keypress@0.0.7/mod.ts'

interface ConfigurationFile {
  wallpapers_dir: string
  interval_mins: number
  daemon_port: number
  daemon_file: string
  random_order: boolean
}
type FileInfo = { mime_type: string; path: string }
type DaemonData = { active_path: string; active_index: number; wallpapers_dir: string }
type Action = 'REFRESH' | 'NEXT' | 'PREV'

// defaults
const HOME = Deno.env.get('HOME')!
const CONFIG_FILE = '~/.config/wallpal.json'
const CONFIG: ConfigurationFile = {
  wallpapers_dir: '~/Pictures/wallpapers',
  interval_mins: 60,
  daemon_port: 4500,
  daemon_file: '~/.cache/wallpal_current_wallpaper.json',
  random_order: false,
}

const decoder = new TextDecoder()
const encoder = new TextEncoder()

function resolve_path(path: string) {
  return path.replace('~', HOME)
}
async function send_action(config_file: string, action: Action) {
  const config = await WallPalDaemon.read_config(config_file)
  try {
    const conn = await Deno.connect({ port: config.daemon_port })
    const buffer = encoder.encode(action)
    await conn.write(buffer)
  } catch (e) {
    if (e.name === 'ConnectionRefused') {
      // prettier-ignore
      console.error(`A wallpal daemon does not appear to be running.\nMake sure you call 'wallpal daemon' in another context first.`)
      Deno.exit(1)
    } else throw e
  }
}
function is_action_enum(action: string): action is Action {
  return ['REFRESH', 'PREV', 'NEXT'].includes(action)
}

class WallPalDaemon {
  config!: ConfigurationFile
  listener: Deno.Listener | undefined
  interval: number | undefined

  wallpaper_index = 0
  wallpaper_dir: FileInfo[] = []

  live_wallpaper_proc: Deno.Process | undefined

  setting_wallpaper = false

  constructor(private config_file: string) {}
  async init() {
    this.listener?.close()
    if (this.interval !== undefined) clearInterval(this.interval)

    this.config = await WallPalDaemon.read_config(this.config_file)

    // listen for commands from wallpall.ts prev/next
    ;(async () => {
      const listener = Deno.listen({ port: this.config.daemon_port })
      this.listener = listener
      for await (const conn of this.listener) {
        let buffer = new Uint8Array(1024)
        const count = await conn.read(buffer)
        if (!count) continue
        const action = decoder.decode(buffer.subarray(0, count))
        console.log('listener', { action })
        if (is_action_enum(action)) await this.do_action(action)
        else console.error(`Invalid action ${action} specified.`)
      }
    })()
    // refresh on an interval
    this.interval = setInterval(() => {
      console.log(`Advancing wallpaper every ${this.config.interval_mins} minutes.`)
      this.do_action('NEXT')
    }, this.config.interval_mins * 60 * 1000)
  }
  async start() {
    const daemon_file = resolve_path(this.config.daemon_file)
    const daemon_database = (await fs.exists(daemon_file))
      ? JSON.parse(await Deno.readTextFile(daemon_file))
      : {}
    if (daemon_database?.wallpapers_dir === this.config.wallpapers_dir) {
      this.wallpaper_index = daemon_database.active_index
    }
    // watch for changes to the config file
    ;(async () => {
      let throttling = false
      console.log(`Edit ${this.config_file} to change the wallpapers folder.`)
      for await (const event of Deno.watchFs(resolve_path(this.config_file))) {
        if (throttling) continue
        throttling = true
        console.log('Config file changed, refreshing wallpaper.')
        this.config = await WallPalDaemon.read_config(this.config_file)
        this.init().then(() => this.do_action('REFRESH'))
        setTimeout(() => {
          throttling = false
        }, 1000)
      }
    })()
    // listen for key presses
    ;(async () => {
      console.log(`Use the arrow keys <- and -> to cycle through wallpapers.`)
      for await (const keypress of readKeypress()) {
        if (keypress.key === 'right') {
          console.log('Right arrow key pressed. Setting NEXT wallpaper.')
          this.do_action('NEXT')
        } else if (keypress.key === 'left') {
          console.log('Left arrow key pressed. Setting PREV wallpaper.')
          this.do_action('PREV')
        } else if (keypress.ctrlKey && keypress.key === 'c') {
          // NOTE: Deno.exit will not cancel the subprocesses (like live wallpapers)
          // see here https://github.com/denoland/deno/issues/8772
          this.live_wallpaper_proc?.kill('sigkill')
          Deno.exit(0)
        }
      }
    })()
    await this.load_wallpaper_dir()
    await this.set_wallpaper(this.wallpaper_index)
  }

  increment_index() {
    this.wallpaper_index = (this.wallpaper_index + 1) % this.wallpaper_dir.length
  }
  decrement_index() {
    this.wallpaper_index = (this.wallpaper_index - 1) % this.wallpaper_dir.length
    if (this.wallpaper_index < 0)
      this.wallpaper_index = this.wallpaper_dir.length + this.wallpaper_index
  }

  async do_action(action: Action) {
    if (this.setting_wallpaper) return
    this.setting_wallpaper = true
    switch (action) {
      case 'REFRESH':
        this.wallpaper_index = 0
        await this.load_wallpaper_dir()
        await this.set_wallpaper(this.wallpaper_index)
        break
      case 'PREV':
        this.decrement_index()
        await this.set_wallpaper(this.wallpaper_index)
        break
      case 'NEXT':
        this.increment_index()
        await this.set_wallpaper(this.wallpaper_index)
        break
    }
    this.setting_wallpaper = false
  }

  async load_wallpaper_dir() {
    console.log('loading...')
    const load_start = performance.now()
    const walked_files: string[] = []
    const walk_iterator = fs.walk(resolve_path(this.config.wallpapers_dir), {
      followSymlinks: true,
    })
    for await (const { path, isFile } of walk_iterator) {
      walked_files.push(path)
    }
    if (this.config.random_order) {
      walked_files.sort(() => 0.5 - Math.random())
    }
    const wallpapers_file_info = []
    for (const path of walked_files) {
      const mime_proc = Deno.run({ cmd: ['file', '-b', '--mime-type', path], stdout: 'piped' })
      const mime_type = decoder.decode(await mime_proc.output()).trim()
      console.log('mime', path)
      wallpapers_file_info.push({ mime_type, path })

    }
    // TODO batch this. For now loading everything at once can cause it to stutter
    // const wallpaper_dir_promises = walked_files.map(async path => {
    //   const mime_proc = Deno.run({ cmd: ['file', '-b', '--mime-type', path], stdout: 'piped' })
    //   const mime_type = decoder.decode(await mime_proc.output()).trim()
    //   return { mime_type, path }
    // })
    // const wallpapers_file_info = await Promise.all(wallpaper_dir_promises)
    const wallpaper_dir = wallpapers_file_info.filter(
      f => f.mime_type.startsWith('image') || f.mime_type.startsWith('video')
    )

    if (wallpaper_dir.length === 0) {
      console.error(`No wallpapers found in ${this.config.wallpapers_dir}.`)
    } else this.wallpaper_dir = wallpaper_dir
    console.log('loading took', performance.now() - load_start)
  }

  static async read_config(config_file: string): Promise<ConfigurationFile> {
    const config_raw = JSON.parse(await Deno.readTextFile(resolve_path(config_file)))
    return { ...CONFIG, ...config_raw }
  }
  async set_wallpaper(wallpaper_index: number) {
    this.live_wallpaper_proc?.kill('sigkill')
    const { path, mime_type } = this.wallpaper_dir[this.wallpaper_index]
    const data: DaemonData = {
      active_path: path,
      active_index: wallpaper_index,
      wallpapers_dir: this.config.wallpapers_dir,
    }
    if (mime_type === 'image/gif' || mime_type.startsWith('video')) {
      await Deno.run({ cmd: ['xsetroot', '-solid', '#000000'] }).status()
      const cmd = [
        'mpv',
        '--wid=0',
        '--really-quiet',
        '--mute=yes',
        '--no-input-default-bindings',
        '--no-config',
        '--loop',
        path,
      ]
      const proc = Deno.run({ cmd })
      this.live_wallpaper_proc = proc
      proc.status().then(() => {
        // if the process completed, then we do not want to perform the kill() call above
        if (proc.pid == this.live_wallpaper_proc?.pid) this.live_wallpaper_proc = undefined
      })
      console.log('Set animated wallpaper', path)
    } else if (mime_type.startsWith('image')) {
      await Deno.run({ cmd: ['feh', '--bg-max', path] }).status()
      console.log('Set wallpaper', path)
    } else {
      throw new Error(`Fatal: expected media mime types. Recieved ${mime_type}`)
    }
    await Deno.writeTextFile(resolve_path(this.config.daemon_file), JSON.stringify(data))
  }
}

const args = parse(Deno.args)
const config_file = args['config-file'] || CONFIG_FILE
const [cmd] = args._
switch (cmd) {
  case 'daemon':
    const wallpal = new WallPalDaemon(config_file)
    await wallpal.init()
    await wallpal.start()
    break
  case 'next':
    await send_action(config_file, 'NEXT')
    break
  case 'prev':
    await send_action(config_file, 'PREV')
    break
  case 'refresh':
    await send_action(config_file, 'REFRESH')
    break
  default:
    console.log(`Usage: wallpal <daemon | prev | next | refresh>`)
    Deno.exit(1)
}
