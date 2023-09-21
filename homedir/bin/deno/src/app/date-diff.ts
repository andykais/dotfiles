import parse from 'https://deno.land/x/date_fns@v2.22.1/parse/index.js'
import format from 'https://deno.land/x/date_fns@v2.22.1/format/index.js'
import difference_in_days from 'https://deno.land/x/date_fns@v2.22.1/differenceInDays/index.ts'

const FORMAT = 'M/d/yyyy'

if (Deno.args.length > 2 || Deno.args.length < 1) throw new Error('Usage: <start_date> [end_date]')
const parsed_dates = Deno.args.map(date => parse(date, FORMAT, new Date(), {}))
if (parsed_dates.length === 1) parsed_dates.push(new Date())
const [start, end] = parsed_dates

const years_diff = difference_in_days(end, start) / 365
console.log(`difference between ${format(start, FORMAT, {})} and ${format(end, FORMAT, {})} is ${years_diff.toFixed(1)} years.`)
