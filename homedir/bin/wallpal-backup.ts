import { readKeypress } from 'https://deno.land/x/keypress@0.0.7/mod.ts'
import * as fs from 'https://deno.land/std@0.67.0/fs/mod.ts'

// types
type Optional<T> = T | null
type ConfigFile = {
  wallpapersDir: string
  intervalMins: number
  randomOrder: boolean
}
type FileInfo = { mimeType: string; path: string }
type CacheFile = { active: string; activeIndex: number }
type Action = 'SET' | 'REFRESH' | 'PREV' | 'NEXT'

// helpers
const resolvePath = (path: string) => path.replace('~', HOME)
const timeout = (ms: number) => new Promise(resolve => setTimeout(resolve, ms))
class Throttle {
  throttling = false
  constructor(private delay: number) {}
  should_throttle() {
    if (this.throttling) return true
    else {
      this.throttling = true
      setTimeout(() => { this.throttling = false }, this.delay)
    }
  }
}
// function throttler(delay: number) {
//   let call_in_flight = false
//   return () => {
//     if (call_in_flight) return false
//     else {
//       call_in_flight = true
//       setTimeout(() => {
//         call_in_flight = false
//       }, delay)
//     }
//   }
// }
async function sendAction(action: Action) {
  try {
    const conn = await Deno.connect({ port: PORT })
    const buffer = encoder.encode(action)
    await conn.write(buffer)
  } catch (e) {
    if (e.name === 'ConnectionRefused')
      console.error(`A wallpal daemon does not appear to be running.
Make sure you call 'wallpal daemon' in another context first.`)
    Deno.exit(1)
  }
}
function isValidAction(action: string): action is Action {
  return ['REFRESH', 'PREV', 'NEXT'].includes(action)
}
const encoder = new TextEncoder()
const decoder = new TextDecoder()

// environment variables
const HOME = Deno.env.get('HOME')!
const XDG_DIR = Deno.env.get('XDG_DIR')
const PORT = parseInt(Deno.env.get('PORT') || '4500')
// application files
const CONFIG_FILE = resolvePath(`${XDG_DIR || '~'}/.config/wallpal.json`)
const CACHE_FILE = resolvePath('~/.cache/wallpal_current_wallpaper.json')

class WallPal {
  displayProc: Optional<Deno.Process> = null
  firstNonMediaFile: Optional<string> = null
  wallpaperDirCache: FileInfo[] = []
  wallpaperDirIndex: number

  constructor(private config: ConfigFile, private cache: Optional<CacheFile>) {
    this.wallpaperDirIndex = cache?.activeIndex || 0
  }

  async triggerProcess(cmd: string[]) {
    const proc = Deno.run({ cmd })
    this.displayProc = proc
    const status = await proc.status()
    console.log({ status })
    if (proc.pid === this.displayProc.pid) this.displayProc = null
  }

  async loadWallpaperDir() {
    const wallpaperDirCache: FileInfo[] = []
    const walkIterator = fs.walk(resolvePath(this.config.wallpapersDir), { followSymlinks: true })
    for await (const { path, isFile } of walkIterator) {
      if (!isFile) continue
      const mimeProc = Deno.run({ cmd: ['file', '-b', '--mime-type', path], stdout: 'piped' })
      const mimeType = decoder.decode(await mimeProc.output()).trim()
      wallpaperDirCache.push({ mimeType, path })
    }
    this.wallpaperDirCache = wallpaperDirCache
  }

  async setWallpaper({ path, mimeType }: FileInfo) {
    if (this.wallpaperDirCache.length === 0)
      return console.log(`No wallpapers found in ${this.config.wallpapersDir}.`)
    this.displayProc?.kill(Deno.Signal.SIGKILL)
    this.cache = { active: path, activeIndex: this.wallpaperDirIndex }
    if (mimeType === 'image/gif' || mimeType.startsWith('video')) {
      console.log('Setting animated wallpaper', path)
      // this.triggerProcess(['feh', '--bg-max', path])
      this.triggerProcess(['mpv', '--wid=0', '--really-quiet', '--mute=yes', '--loop', path])
    } else if (mimeType.startsWith('image')) {
      console.log('Setting wallpaper', path)
      this.triggerProcess(['feh', '--bg-max', path])
    } else {
      throw new Error(`Fatal: expected media mime types. Recieved ${mimeType}`)
    }
    await fs.writeJson(CACHE_FILE, this.cache)
  }

  async doAction(action: Action) {
    // TODO handle no wallpapers found
    switch (action) {
      case 'SET':
        await this.setWallpaper(this.wallpaperDirCache[this.wallpaperDirIndex])
        break
      case 'REFRESH':
        this.wallpaperDirIndex = 0
        await this.loadWallpaperDir()
        await this.setWallpaper(this.wallpaperDirCache[this.wallpaperDirIndex])
        break
      case 'PREV':
        this.wallpaperDirIndex = (this.wallpaperDirIndex - 1) % this.wallpaperDirCache.length
        if (this.wallpaperDirIndex < 0)
          this.wallpaperDirIndex = this.wallpaperDirCache.length + this.wallpaperDirIndex
        await this.setWallpaper(this.wallpaperDirCache[this.wallpaperDirIndex])
        break
      case 'NEXT':
        this.wallpaperDirIndex = (this.wallpaperDirIndex + 1) % this.wallpaperDirCache.length
        await this.setWallpaper(this.wallpaperDirCache[this.wallpaperDirIndex])
        break
    }
  }
  // async doActionRandom(action: Action) {
  //   switch(action) {
  //     case 'SET':
  //       await this.setWallpaper(this.wallpaperDirCache[this.wallpaperDirIndex])
  //       break
  //     case 'REFRESH':
  //       await this.loadWallpaperDir()
  //       this.wallpaperDirIndex = Math.floor(Math.random() * this.randomIndexesRemaining.length)
  //       this.randomIndexesPicked.add(this.wallpaperDirIndex)
  //       this.randomIndexesRemaining.delete(this.wallpaperDirIndex)
  //       await this.setWallpaper(this.wallpaperDirCache[this.wallpaperDirIndex])
  //       break
  //     case 'PREV':
  //       this.wallpaperDirIndex = (this.wallpaperDirIndex - 1) % this.wallpaperDirCache.length
  //       if (this.wallpaperDirIndex < 0) this.wallpaperDirIndex = this.wallpaperDirCache.length + this.wallpaperDirIndex
  //       await this.setWallpaper(this.wallpaperDirCache[this.wallpaperDirIndex])
  //       break
  //     case 'NEXT':
  //       this.wallpaperDirIndex = Math.floor(Math.random() * this.wallpaperDirCache.length)
  //       if (this.randomIndexesRemaining.length) {
  //         this.randomIndexesRemaining.
  //       }
  //       this.wallpaperDirIndex = (this.wallpaperDirIndex + 1) % this.wallpaperDirCache.length
  //       await this.setWallpaper(this.wallpaperDirCache[this.wallpaperDirIndex])
  //       break
  //   }
  // }

  // event triggers

  // TODO REFRESH should reset the loop
  async *intervalIt(): AsyncGenerator<Action, void, unknown> {
    console.log(`Advancing wallpaper every ${this.config.intervalMins} minutes.`)
    while (true) {
      await timeout(this.config.intervalMins * 60 * 1000)
      yield 'NEXT'
    }
  }

  async *configChangeIt(): AsyncGenerator<Action, void, unknown> {
    console.log(`Edit ${CONFIG_FILE} to change the wallpapers folder.`)
    const throttle = new Throttle(1000)
    for await (const event of Deno.watchFs(CONFIG_FILE)) {
      if (event.kind === 'modify') console.log(event.kind)
      if (!throttle.should_throttle()) {
        console.log('Config file changed, refreshing wallpaper.')
        this.config = (await fs.readJson(CONFIG_FILE)) as ConfigFile
        yield 'REFRESH'
      }
    }
  }
  async *connCommandIt(): AsyncGenerator<Action, void, unknown> {
    for await (const conn of Deno.listen({ port: PORT })) {
      let buffer = new Uint8Array(1024)
      const count = await conn.read(buffer)
      if (!count) continue
      const action = decoder.decode(buffer.subarray(0, count))
      if (isValidAction(action)) yield action
      else console.error(`Invalid action ${action} specified.`)
    }
  }

  async *keypressIt(): AsyncGenerator<Action, void, unknown> {
    console.log(`Use the arrow keys <- and -> to cycle through wallpapers.`)
    for await (const keypress of readKeypress()) {
      if (keypress.key === 'right') {
        console.log('Right arrow key pressed. Setting NEXT wallpaper.')
        yield 'NEXT'
      } else if (keypress.key === 'left') {
        console.log('Left arrow key pressed. Setting PREV wallpaper.')
        yield 'PREV'
      } else if (keypress.ctrlKey && keypress.key === 'c') {
        Deno.exit(0)
      }
    }
  }

  async daemon() {
    console.log(`Starting wallpal in ${this.config.wallpapersDir}.`)
    await this.loadWallpaperDir()
    await this.doAction('SET')
    // TODO merge async iterators
    await Promise.all([
      (async () => {
        for await (const action of this.intervalIt()) this.doAction(action)
      })(),
      (async () => {
        for await (const action of this.configChangeIt()) this.doAction(action)
      })(),
      (async () => {
        for await (const action of this.connCommandIt()) this.doAction(action)
      })(),
      (async () => {
        for await (const action of this.keypressIt()) this.doAction(action)
      })(),
    ])
  }
}

switch (Deno.args[0]) {
  case 'daemon':
    const config = (await fs.readJson(CONFIG_FILE)) as ConfigFile
    const cache: Optional<CacheFile> = fs.existsSync(CACHE_FILE)
      ? ((await fs.readJson(CACHE_FILE)) as CacheFile)
      : null
    const wallpal = new WallPal(config, cache)
    await wallpal.daemon()
    break
  case 'prev':
    await sendAction('PREV')
    break
  case 'next':
    await sendAction('NEXT')
    break
  case 'refresh':
    await sendAction('REFRESH')
    break
  default:
    console.log(`Usage: wallpal <daemon | prev | next | refresh>`)
    Deno.exit(1)
}
