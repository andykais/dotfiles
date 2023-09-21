import * as flags from "https://deno.land/std@0.159.0/flags/mod.ts";
import * as io from "https://deno.land/std@0.159.0/io/mod.ts";
import * as streams from "https://deno.land/std@0.136.0/streams/conversion.ts";
import { Command, ValidationError } from "https://deno.land/x/cliffy@v0.25.2/command/mod.ts";

import * as rx from 'npm:rxjs'


interface Process {
  pid: number
  command: string
}

interface Lsof {
  cmd: string
  pid: string
  user: string
  fd: string
  type: string
  device: string
  size: string
  node: string
  name: string
}

interface SearchOptions {
  exact: boolean
}

class CliError extends Error {}

class Parsers {
  public static parse_ps_ax(process_str: string) {
    const match = process_str.match(/(\d+)\s+(.*?)\s+(.*?)\s+(.*?)\s+(.*)/)
    if (match === null) throw new Error(`Parse failed on str '${process_str}'`)
    const [_, pid_str, tty, stat, time, command] = match
    const pid = parseInt(pid_str)
    if (Number.isNaN(pid)) throw new Error(`Parse failed on pid parse: '${pid_str}`)
    return { pid, tty, stat, time, command }
  }

  public static parse_lsof(lsof_line: string): Lsof {
    const match = lsof_line.match(/(.*?)\s+(.*?)\s+(.*?)\s+(.*?)\s+(.*?)\s+(.*?)\s+(.*?)\s+(.*?)\s+(.*)/)
    if (match === null) throw new Error(`Parse failed on str '${lsof_line}'`)
    const [_, cmd, pid, user, fd, type, device, size, node, name] = match
    return { cmd, pid, user, fd, type, device, size, node, name }
  }
}

class Proctor {
  private static instrument = <T extends Array<any>, R>(name: string, lambda: (...args: T) => R) => {
    return async (...args: T) => {
      const start_time = performance.now()
      const result = await lambda(...args)
      const end_time = performance.now() - start_time
      console.log(`Completed in ${end_time / 1000} seconds`)
      return result
    }
  }

  private static text_decoder = new TextDecoder()
  private static async exec(cmd: string[]) {
    const [exec_path, ...args] = cmd
    const proc = new Deno.Command(exec_path, { args })
    const result = await proc.output()
    if (result.success === false) throw new Error(`Deno.spawn(${cmd}) failed with exit code ${result.code}`)
    return Proctor.text_decoder.decode(result.stdout)
  }
  private static async *exec_pipe(cmd: string[]) {
    const [exec_path, ...args] = cmd
    const proc = Deno.spawnChild(exec_path, { args })
    const reader = streams.readerFromStreamReader(proc.stdout.getReader())
    for await (const output_line of io.readLines(reader)) {
      yield output_line
    }
    await proc.status
  }

  public static load = Proctor.instrument('load', async (search_pattern: string, options: SearchOptions) => {
    const proc = await Deno.spawnChild('ps', { args: ['ax'] })
    const reader = streams.readerFromStreamReader(proc.stdout.getReader())
    const processes: Process[] = []
    let index = 0
    const search_pattern_regex = new RegExp(search_pattern)
    for await (const process_str of io.readLines(reader)) {
      index ++
      if (index === 1) continue
      const { pid, command } = Parsers.parse_ps_ax(process_str)
      if (search_pattern_regex.test(command)) processes.push({ pid, command })
    }
    await proc.status
    if (options.exact) {
      if (processes.length !== 1) {
        const proc_display = processes.map(p => `  ${p.pid}   ${p.command}`).join('\n')
        throw new CliError(`Failed to find exactly 1 process, found ${processes.length}:\n${proc_display}`)
      }
    }
    return new Proctor(processes)
  })

  private constructor(private processes: Process[]) {}

  public view_files = Proctor.instrument('view_files', async () => {
    const [process] = this.processes
    const lsof_generator = Proctor.exec_pipe(['lsof', '-p', process.pid.toString()])
    const obs = rx.from(lsof_generator)
      .pipe(
        rx.filter((_: string, index: number) => index > 0),
        rx.map(Parsers.parse_lsof),
      )
    const files = await this.collect<Lsof>(obs)
    files.sort((a, b) => {
      if (a.name.startsWith('/') && b.name.startsWith('/') === false) return -1
      if (a.name.startsWith('/') === false && b.name.startsWith('/')) return 1
      return a.name.localeCompare(b.name)
    })
    for (const file of files) {
      console.log('  ', file.type, file.node, file.name)
    }
  })

  public view_network = Proctor.instrument('view_network', async () => {

  })

  collect = <T>(obs: any) => new Promise<T[]>(resolve => {
    const result: T[] = []
    obs.subscribe({
      next: (val: T) => result.push(val),
      complete: () => resolve(result)
    })
  })

  async view_resources() { 
    throw new Error('unimplemented')
  }

}


const main = new Command()
  .name("proctor")
  .description("display rich information on individual processes")
  .option("--files", "List open files by the particular process")
  .option("--resources", "Display resource information on a particular process")
  .option("--network", "Display resource information on a particular process")
  .option("--exact", "Search pattern must not yield more than one process")
  .option("--flat", "Combine reports from multiple processes")
  .arguments("<process_search_pattern>")
  .action(async ({ files, resources, exact = false }, process_search_pattern) => {
    let action: 'resources' | 'files' | 'network' = 'resources' // default to resource view
    if ([files, resources].every(flag => flag)) throw new Error('Cannot set both --files and --resources')
    if (files) action = 'files' as const

    const proctor = await Proctor.load(process_search_pattern, { exact: exact })

    switch(action) {
      case 'resources': {
        await proctor.view_resources()
        break
      }
      case 'files': {
        await proctor.view_files()
        break
      }
      case 'network': {
        await proctor.view_network()
        break
      }
      default:
        throw new Error(`Unexpected code path, unknown action '${action}'`)
    }
  })

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

// show processes that have tcp connections open, also resolve foriegn ips to domain names
//
// usage:
// proctor 'grep process filter'
//
// proctor 'mpv.*themovietitle' --required-count 1
//
// proctor # this is graph everything
