import { Command } from "https://deno.land/x/cliffy@v0.25.7/command/mod.ts";
import * as io from "https://deno.land/std@0.179.0/io/mod.ts";
import { iterateReader } from "https://deno.land/std@0.179.0/streams/iterate_reader.ts";

await new Command()
  .name("ded")
  .description("Deno powered sed.")
  .version("v1.0.0")
  .arguments("<regex_replace:string> [file:string]")
  .action(async (opts, regex_replace, file) => {
    const [_, regex_str, replace, flags] = regex_replace.split('/')
    const regex = new RegExp(regex_str, flags)
    const source_file = file ? await Deno.open(file, {read:true, write:true}) : undefined
    const source = source_file ?? Deno.stdin
    const text_encoder = new TextEncoder()

    const lines = []
    for await(const line of io.readLines(source)) {
      const full_line = line + '\n' // maybe this is the /m flag?
      const replacement = full_line.replace(regex, replace)
      if (source_file) lines.push(replacement)
      else Deno.stdout.write(text_encoder.encode(replacement))
    }
    if (file) await Deno.writeTextFile(file, lines.join(''))
  })
  .parse()
