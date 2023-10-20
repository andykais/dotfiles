import * as z from 'npm:zod@3.22.2'
import * as flags from 'https://deno.land/std@0.202.0/flags/mod.ts'
import { TextDelimiterStream } from "https://deno.land/std@0.202.0/streams/text_delimiter_stream.ts";


const decoder = new TextDecoder()
const encoder = new TextEncoder()


const args = flags.parse(Deno.args)
let search: string | RegExp
let replace: string

if (args._.length === 2) {
  [search, replace] = z.string().array().min(1).max(2).parse(args._)
  replace ??= ''
} else if (args._.length === 1) {
  const results = args._[0].toString().split('/')
  const [s, search_regex, replace_regex, regex_flags] = z.tuple([
    z.literal("s"),
    z.string(),
    z.string(),
    z.union([z.literal("g"), z.literal("i"), z.literal("")]).optional()
  ]).parse(args._[0].toString().split('/'))
  search = new RegExp(search_regex, regex_flags)
  replace = replace_regex
} else {
  console.log(`Usage: replace <search> [replace]`)
  Deno.exit(1)
}

const newline_stream = Deno.stdin.readable
  .pipeThrough(new TextDecoderStream())
  .pipeThrough(new TextDelimiterStream("\n", { disposition: 'discard' }))

for await (const line of newline_stream) {
  const result = line.replace(search, replace)
  // console.log(line)
  console.log(result)
}
