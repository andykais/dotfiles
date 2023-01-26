// std modules
import * as fs from 'https://deno.land/std@0.149.0/fs/mod.ts'
import * as flags from 'https://deno.land/std@0.149.0/flags/mod.ts'
import * as yaml from "https://deno.land/std@0.149.0/encoding/yaml.ts";
import * as io from "https://deno.land/std@0.149.0/io/mod.ts";
// community modules
import * as keypress from 'https://deno.land/x/keypress@0.0.8/mod.ts'
import { listen } from 'https://deno.land/std@0.149.0/_deno_unstable.ts';


interface ConfigurationFile {
  wallpapers_dir: string
  interval_mins: number
  daemon_port: number
  daemon_file: string
  ipc_unix_socket: string
  random_order: boolean
}
type FileInfo = { mime_type: string; path: string }
type DaemonData = { active_path: string; active_index: number; wallpapers_dir: string }
type Action =
  | 'REFRESH'
  | 'NEXT'
  | 'PREV'
interface MessageContract {
  action: Action
}

const CONFIG_FILE = '~/.config/wallpal.yaml'
const CONFIG: ConfigurationFile = {
  wallpapers_dir: '~/Pictures/wallpapers',
  interval_mins: 60,
  daemon_port: 4500,
  daemon_file: '~/.cache/wallpal_current_wallpaper.json',
  ipc_unix_socket: '~/.cache/wallpal.sock',
  random_order: false,
}


abstract class WallPal {
  private home = Deno.env.get('HOME')!
  protected daemon_file: string
  protected config!: ConfigurationFile
  protected text_decoder = new TextDecoder()
  protected text_encoder = new TextEncoder()

  public constructor(private config_file: string) {
    this.daemon_file = '~/.cache/wallpal_current_wallpaper.json'
  }

  abstract do_action(action: Action): Promise<void>

  public async init() {
    const filepath = this.resolve_path(config_file)
    const file_contents = await Deno.readTextFile(filepath)
    const parsed_contents = yaml.parse(file_contents) as Partial<ConfigurationFile>
    const merged_config = {...CONFIG, ...parsed_contents}
    this.config = merged_config
    console.log(this.config)
  }

  protected resolve_path(path: string) {
    return path.replace('~', this.home)
  }

  protected log_perf(name: string, perf_start_ms: number) {
    const duration_ms = performance.now() - perf_start_ms
    console.log(`${name} took ${duration_ms} ms`)
  }
}

class WallPalDaemon extends WallPal {
  async do_action(action: Action) {
    console.log('display image', action)

  }

  public async init() {
    await super.init()
    const ipc_socket_filepath = this.resolve_path(this.config.ipc_unix_socket)
    const listener = Deno.listen({ path: ipc_socket_filepath, transport: 'unix' })
    for await (const conn of listener) {
      const perf_start = performance.now()
      const bytes = await io.readAll(conn)
      const stringified = this.text_decoder.decode(bytes)
      const message: MessageContract = JSON.parse(stringified)
      await this.do_action(message.action)
      this.log_perf(`perf action '${message.action}'`, perf_start)
    }
  }
}

class WallPalClient extends WallPal {
  async do_action(action: Action) {
    await super.init()
    const ipc_socket_filepath = this.resolve_path(this.config.ipc_unix_socket)
    const conn = await Deno.connect({ path: ipc_socket_filepath, transport: 'unix' })
    const message: MessageContract = { action }
    const stringified = JSON.stringify(message)
    const bytes = this.text_encoder.encode(stringified)
    conn.write(bytes)
  }
}



const args = flags.parse(Deno.args)
const config_file = args['config-file'] || CONFIG_FILE
const [cmd] = args._
switch (cmd) {
  case 'daemon': {
      const wallpal = new WallPalDaemon(config_file)
      await wallpal.init()
      break
  }
  case 'next':
  case 'prev':
  case 'refresh': {
    const wallpal = new WallPalClient(config_file)
    await wallpal.init()
    await wallpal.do_action(cmd.toUpperCase() as Action)
    break
  }
  default:
    console.log(`Usage: wallpal <daemon | prev | next | refresh>

    --help     Print this message
    --config   Specify a config filepath`)
    Deno.exit(1)
}
