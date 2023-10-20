import * as flags from "https://deno.land/std@0.143.0/flags/mod.ts";

const USAGE = `demon [DEMON_OPTS] --exec <command> <command_opts>

DEMON_OPTS:
  --ext         File extensions to watch for changes
  --directory   Directory to watch for changes
  --pattern     File/directory patterns to watch for changes
`

const args = flags.parse(Deno.args)

const demon_args: string[] = []
const exec_args: string[] = []
let arg_parser: 'demon' | 'exec'  = 'demon'
for (const arg of Deno.args) {
  console.log({arg})
  if (arg === '--exec' | '-c') {

  }
  if (arg_parser === 'demon') {
  }
  console.log(arg)
}
