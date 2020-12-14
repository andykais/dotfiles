import { parse } from 'https://deno.land/std@0.77.0/flags/mod.ts'
import { readLines } from 'https://deno.land/std@0.80.0/io/bufio.ts'
import * as colors from 'https://deno.land/std@0.80.0/fmt/colors.ts'

const PACMAN_LOG = '/var/log/pacman.log'
const decoder = new TextDecoder()
const args = parse(Deno.args)

if (args.help) {
  console.log(`arch-packages.ts
A installed package viewer for arch linux

USAGE:
  arch-packages.ts [options]

OPTIONS:
  --help
      Prints help information
   --aur
     Only show aur packages`)
} else {
  const db_type_flag = args.aur ? '--foreign' : '--native'
  const cmd = ['pacman', '--query', '--quiet', '--explicit', db_type_flag]
  const proc = Deno.run({ cmd, stdout: 'piped' })
  const { code } = await proc.status()
  if (code !== 0) throw new Error(`Deno.run error\n${cmd.join(' ')}`)
  const raw_output = await proc.output()
  const output = decoder.decode(raw_output)
  const packages = new Set(output.trim().split('\n'))

  const column_headers = {
    name: 'Package Name',
    version: 'Version',
    datetime: 'Date Installed',
  }
  let name_column_width = column_headers.name.length
  let version_column_width = column_headers.version.length
  const print_packages = new Map()
  const pacman_log_regex = /\[(.+?)\] \[.+?\] installed ([a-zA-Z0-9-_]+) \((.+?)\)/

  const file_buffer = await Deno.readFile(PACMAN_LOG)
  const file_lines = decoder.decode(file_buffer).trim().split('\n')

  for (const line of file_lines) {
    const match = pacman_log_regex.exec(line)
    const [_, datetime, package_name, version] = match || []
    if (packages.has(package_name)) {
      name_column_width = Math.max(name_column_width, package_name.length)
      version_column_width = Math.max(version_column_width, version.length)
      print_packages.set(package_name, { version, datetime: new Date(datetime) })
    }
  }

  for (const [package_name, { version, datetime }] of print_packages) {
    const package_fmt = package_name.padEnd(name_column_width)
    const version_fmt = colors.gray(version.padEnd(version_column_width))
    const date_fmt = colors.gray(`${datetime.toDateString()} ${datetime.toTimeString().split(' ')[0]}`)
    console.log(package_fmt, version_fmt, date_fmt)
  }
  console.log()
  const package_type = args.aur ? 'aur' : 'native'
  console.log(`${print_packages.size} total ${package_type} packages installed.`)
}
