import { DelimiterStream } from "https://deno.land/std@0.202.0/streams/mod.ts";
import * as path from "https://deno.land/std@0.184.0/path/mod.ts";
import * as datetime from "https://deno.land/std@0.184.0/datetime/mod.ts";
import * as flags from "https://deno.land/std@0.184.0/flags/mod.ts";
import { Webview } from "https://deno.land/x/webview/mod.ts";
import { Command, ValidationError } from "https://deno.land/x/cliffy@v0.25.2/command/mod.ts";
import { StatsInput, type CpuStats } from '../../utils/proc_pid_stat.ts'
import { Duration, DurationStruct } from '../../utils/duration.ts'



// getconf CLK_TCK
const CLK_TCK = parseInt(new TextDecoder().decode((await new Deno.Command('getconf', { args: ['CLK_TCK'] }).output()).stdout))

class CliError extends Error {}


class ProcfileSystem {
  static async read_procfile(name: string, options?: { pid?: number }) {
    let procfile_path = ['/', 'proc', name]
    if (options?.pid) procfile_path.splice(2, 0, options.pid.toString())
    const proc_contents = await Deno.readTextFile(path.join(...procfile_path))
    return proc_contents
  }
}

interface ProcInfoResults {
  cpu: {
    stats: CpuStats
    retrieved_at: Date
  }
}
class Process {
  pid: number
  #command: string | undefined
  #proc_infos: ProcInfoResults | undefined
  #updated_at: Date | undefined

  constructor(pid: number) {
    this.pid = pid
  }

  async retrieve_data() {
    this.#proc_infos = {
      cpu: {
        retrieved_at: new Date(),
        stats: StatsInput.parse(await ProcfileSystem.read_procfile('stat', { pid: this.pid })),
      },
    }
    return this.#proc_infos
  }

  get command() {
    if (this.#command) return this.#command
    else throw new Error(`Process ${this.pid} has not retrieved its command line data yet`)
  }

  async read_data() {
    if (this.#proc_infos === undefined) {
      await this.retrieve_data()
      this.#command = await ProcfileSystem.read_procfile('cmdline', { pid: this.pid })
    }

    const old_infos = this.#proc_infos!
    const new_infos = await this.retrieve_data()

    const cpu_time_old = old_infos.cpu.stats.utime + old_infos.cpu.stats.stime
    const cpu_time_new = new_infos.cpu.stats.utime + new_infos.cpu.stats.stime
    const cpu_time_window = cpu_time_new - cpu_time_old
    const cpu_time_window_seconds = cpu_time_window / CLK_TCK
    const time_window = datetime.difference(old_infos.cpu.retrieved_at, new_infos.cpu.retrieved_at)
    const time_window_seconds = time_window.milliseconds! / 100
    const cpu_percentage = cpu_time_window_seconds / time_window_seconds

    console.log(`${Date.now()} cpu_time_window_seconds: ${cpu_time_window_seconds}, time_window_seconds: ${time_window_seconds}, percentage: ${cpu_percentage}%`)

    return {
      cpu_percentage,
    }
  }
}

export interface ExaminerOptions {
  interval?: DurationStruct
  yield?: 'all' | 'one_at_a_time'
}

export class Examiner {
  #process_lookup: ProcessPatternMatcher
  #options: ExaminerOptions
  #processes: Process[] = []
  #pids: number[] = []

  // processes matching inputted pattern
  constructor(process_pattern: string | number, options?: ExaminerOptions) {
    this.#process_lookup = new ProcessPatternMatcher(process_pattern.toString())
    this.#options = {...options}
  }

  async #find_processes() {
    const pids = await this.#process_lookup.get_pids()
    this.#processes = pids.map(pid => new Process(pid))
  }

  async *receive_data() {
    if (this.#options.yield === 'all') throw new Error('unimplemented')

    await this.#find_processes()

    for (const process of this.#processes) {
      const proc_data = await process.read_data()
      const process_data = {
        pid: process.pid,
        command: process.command,
        proc_data,
      }
      yield process_data
      // console.log(process.command, data.cpu_percentage)
    }
  }
}

export class ProcessPatternMatcher {
  #text_decoder = new TextDecoder()
  #newline_encoded = new TextEncoder().encode("\n")

  constructor(public process_pattern: string) {}

  async get_pids(): Promise<number[]> {
    // more efficient, but cant match process numbers.
    // potentially this is mitigated with a process number cli flag, but for now I want to match anything
    // const command = new Deno.Command('pgrep', { args: ['-f', this.process_pattern] })

    const command = new Deno.Command('ps', { args: ['ax', '--format', 'pid,command'], stdout: 'piped' })
    const proc = command.spawn()
    const file = await Deno.open('./deno.json')

    const newline_stream = new DelimiterStream(this.#newline_encoded)
    const ps_lines_stream = proc.stdout
      .pipeThrough(new DelimiterStream(this.#newline_encoded))
      .pipeThrough(new TextDecoderStream())

    for await (const line of ps_lines_stream) {
      console.log(line)
      console.log()
    }

    // for await (const line of readLines(file)) {
    //   console.log({line})
    // }
    // // poop. I cant get this working
    // // for await (const line of proc.stdout) {
    // for await (const line of readLines(proc.stdout.getReader())) {
    //   console.log({line: this.#text_decoder.decode(line)})
    // }

    return []
  }
}


const html = `
  <html>
  <body>
    <h1>Hellooo deno v${Deno.version.deno}</h1>
  </body>
  </html>
`;




console.log('starting main...')
const main = new Command()
  .name("examiner")
  .description("graph process information on a pattern of processes")
  .arguments("<process_search_pattern>")
  .action(async (options, process_search_pattern) => {
    const webview = new Webview();

    webview.navigate(`data:text/html,${encodeURIComponent(html)}`);
    webview.run();
  })

if (import.meta.main) {
  try {
    await main.parse()
  } catch (e) {
    if (e instanceof CliError || e instanceof ValidationError) {
      console.error(e.message)
      // Deno.exit(1)
    } else {
      throw e
    }
  }
}

