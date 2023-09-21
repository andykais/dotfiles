import * as datetime from 'https://deno.land/std/datetime/mod.ts'
import { type Entries } from 'npm:type-fest'

const CONVERSIONS = {
  seconds: 1000,
  minutes: 1000 * 60,
  hours:   1000 * 60 * 60,
  days:    1000 * 60 * 60 * 24,
  years:   1000 * 60 * 60 * 24 * 365,
}


interface DurationStruct {
  milliseconds?: number
  seconds?: number
  minutes?: number
  hours?: number
  days?: number
  years?: number
}

class Duration {
  #duration: DurationStruct
  #milliseconds: number

  private constructor(duration: DurationStruct) {
    this.#duration = duration
    this.#milliseconds = 0
    for (const [unit, value] of Object.entries(duration) as Entries<typeof CONVERSIONS>) {
      this.#milliseconds += value * CONVERSIONS[unit]
    }
  }

  static of(duration: DurationStruct): Duration {
    return new Duration(duration)
  }

  public get milliseconds() { return this.#milliseconds }
  public get seconds()      { return this.#milliseconds / CONVERSIONS.seconds }
  public get minutes()      { return this.#milliseconds / CONVERSIONS.minutes }
  public get hours()        { return this.#milliseconds / CONVERSIONS.hours }
  public get days()         { return this.#milliseconds / CONVERSIONS.days }
  public get years()        { return this.#milliseconds / CONVERSIONS.years }
}

export { Duration }
export type { DurationStruct }
