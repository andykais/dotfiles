import { Duration } from '../src/utils/duration.ts'
import { Examiner } from '../src/app/examiner/cli.ts'

import * as z from 'npm:zod@3.22.2'

Deno.test('basic', async () => {
  const examiner = new Examiner(Deno.pid, { interval: Duration.of({ seconds: 1 }) })
  // examiner.set_processes([Deno.pid])
  for await (const data of examiner.receive_data()) {
    console.log({data})
  }
  // while (true) {
  //   await examiner.get_data()
  //   await new Promise(resolve => setTimeout(resolve, 1000))
  // }
})
