
const timeout = (ms: number) => new Promise(resolve => setTimeout(resolve, ms))
function throttler(delay: number) {
  let lastCaller = Symbol()
  return async () =>  {
    const thisCaller = lastCaller = Symbol()
    await timeout(delay)
    return lastCaller === thisCaller
  }
}

const throttle = throttler(100)
console.log('hello')
await timeout(1000)
console.log('goodbye')
console.log(await throttle())
console.log(await throttle())
console.log(await throttle())
