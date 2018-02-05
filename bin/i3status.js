#!/bin/node

const fs = require('fs')
const child_process = require('child_process')
const os = require('os')
const { promisify } = require('util')
const [ exec, read ] = [ child_process.exec, fs.readFile ].map(f => promisify(f))
const DEBUG = process.env.DEBUG === 'true'
const header = JSON.stringify({ version: 1 }) + '[\n[]'
const colors = {
  healthy: '#00ff00',
  uneasy: '#ffff00',
  sick: '#ff0000',
  normal: '#dcdcdc'
}
const unicodes = {
  degree: '°',
  lightningBolt: '⚡', // console.log('\u{26A1}')
  upload: '↑',
  download: '↓',
  moonPhases: [
    { char: '🌑', time: 184566, phase: 'new' },
    { char: '🌒', time: 553699, phase: 'waxingCrescent' },
    { char: '🌓', time: 922831, phase: 'firstQuarter' }, // 
    { char: '🌔', time: 1291963, phase: 'waxingGibbous'}, // waxingGibbous
    { char: '🌕', time: 1661096, phase: 'full' }, // full
    { char: '🌖', time: 2030228, phase: 'waningGibbous' }, // waningGibbous
    { char: '🌗', time: 2399361, phase: 'thirdQuarter' }, // thirdQuarter
    { char: '🌘', time: 2768493, phase: 'waningCrescent' } // waningCrescent
    // { char: '🌑', time: 184566, phase: 'new' },
    // { char: '🌒', time: 553699, phase: 'waxingCrescent' },
    // { char: '🌓', time: 922831, phase: 'firstQuarter' },
    // { char: '🌔', time: 1291963, phase: 'waxingGibbous'},
    // { char: '🌕', time: 1661096, phase: 'full' },
    // { char: '🌖', time: 2030228, phase: 'waningGibbous' },
    // { char: '🌗', time: 2399361, phase: 'thirdQuarter' },
    // { char: '🌘', time: 2768493, phase: 'waningCrescent' }

  ],
  capacity: (percent) =>
  ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
    .find((char, i, { length }) => percent / 100 <= (i + 1) / length)
}
const DANGER_THRESHOLDS = {
  cpu: 75, // over
  mem: 75, // over
  battery: 25 // under
}

// utilites
const debug = (...args) => DEBUG && console.log('>', ...args, '\n')
const i3log = (json) => DEBUG || console.log(`,${JSON.stringify(json)}`)


const optional = (str, { atStart } = {}) => str
  ? (atStart
    ? str.padEnd(str.length + 1)
    : str.padStart(str.length + 1))
  : ''

const normalize = (percentArray) => {
  const max = Math.max(...percentArray)
  const min = Math.min(...percentArray)
  return percentArray.map(p => (p - min) / (max - min) * 100)
}

const parseTable = (tableString, columnKeys, optFunc) => {
  const tableData = []
  return tableString.split('\n')
    .map(line => {
      return line
        .trim()
        .split(/\s+/)
        .reduce((acc, item, i) => {
          if (i < columnKeys.length && columnKeys[i] !== '_') {
            acc[columnKeys[i]] = optFunc ? optFunc(item, { col: i }) : item
          }
          return acc
      }, {})
    })
}

const humanReadable = (bytes, { sigfig = 2, unitsFunc } = {}) => {
  const {
    readable,
    magnitude
  } = bytes > 1e9
  ? { readable: bytes / 1e9, magnitude: 'G' }
  : bytes > 1e6
  ? { readable: bytes / 1e6, magnitude: 'M' }
  : { readable: bytes / 1e6, magnitude: 'K' }
  return `${readable.toFixed(sigfig)}${unitsFunc ? unitsFunc(magnitude) : magnitude}`
}

const track = {}
track.start = title => {
  if (DEBUG) track[title] = process.hrtime()
}
track.log = title => {
  if (DEBUG) {
    const startTime = track[title]
    if (!startTime) throw new Error(`${title} never started tracking`)
    const [ seconds, nanoseconds ] = process.hrtime(startTime)
    debug(`${title} took: ${(seconds + nanoseconds / 1e9).toFixed(3)}s`)
  }
}

const delay = (ms) => new Promise((resolve, reject) => setTimeout(resolve, ms))

// info grabbers
const getDate = () => {
  const now = Date.now()
  // moon phase
  // TODO use https://github.com/mourner/suncalc
  // const moonPhase = (() => {
    // const lp = 2551443
    // const newMoon = 592500
    // const phase = ( now - newMoon ) % lp
    // const phaseNumber = ( ( phase / 86400 ) + 1) * 100000
    // const { char } = unicodes.moonPhases.find(({ time }) => phaseNumber < time) || unicodes.moonPhases[unicodes.moonPhases.length - 1]
    // return char
  // })()

  const date = (new Date(now)).toLocaleString('en-us', {
    weekday: 'short',
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    timeZoneName: 'short',
  }).replace(/,/g, '')

  return {
    name: 'time',
    full_text: date
  }
}

const getTimeSinceShutdown = async () => {
  const timeSinceStr = await read('/proc/uptime')
  const [ secondsSince ] = timeSinceStr.toString().split(' ').map(parseInt)
  debug(secondsSince)
  let val
  if (secondsSince > 86400) {
    val = (secondsSince / 60 / 60 / 24).toFixed(1) + 'd'
  } else if (secondsSince > 3600) {
    val = parseInt(secondsSince / 60 / 60) + 'h'
  } else if (secondsSince > 60) {
    val = parseInt(secondsSince / 60) + 'm'
  } else {
    val = parseInt(secondsSince) + 's'
  }
  debug(secondsSince / 60 / 60 / 24)
  debug(val)
  return {
    name: 'timeSince',
    full_text: `startup ${val} ago`
  }
}
const getBatteries = async () => {
  const { stdout } = await exec('acpi -b')
  const batteries = stdout.split('\n')
    .filter((_, i) => i < 2)
    .map((info, i) => {
      const percent = info.match(/\d+%/)[0]
      const active = Boolean(info.match(/Discharging|Charging/))
      const remaining = active
        ? ' ' + info.replace(/.+\d+%, /, '').replace(/ .*/, '')
        : ''
      const status = info.includes('Charging') ? 'CHR' : 'BAT'
      return {
        name: `bat${i}`,
        full_text: `${active ? unicodes.lightningBolt.padEnd(2) : ''}${status} ${percent}${remaining}`,
        color: parseInt(percent) < DANGER_THRESHOLDS.battery && status === 'BAT' ? colors.sick : colors.normal
      }
    })
  return batteries
}

const getCPU = () => {
  const cores = os.cpus()
    .map(({ times: { user, nice, idle }}) => (user+nice)*100/(user+nice+idle))
  const avg = cores.reduce((acc, c) => c + acc, 0) / cores.length

  const maxCore = Math.max(...cores)
  // relative distance
  // const coresText = avg > DANGER_THRESHOLDS.cpu && normalize(cores).map(unicodes.capacity).join(' ')
  // out of 100 distance
  const coresText = cores.find(c => unicodes.capacity(c) !== unicodes.capacity(0)) && cores.map(unicodes.capacity).join(' ')

  return {
    name: 'cpu',
    full_text: `CPU ${avg.toFixed(2)}%${optional(coresText)}`,
    color: avg > DANGER_THRESHOLDS.cpu ? colors.sick : colors.normal
  }
}

const getMem = () => {
  const total = os.totalmem() / 1e9
  const used = total - os.freemem() / 1e9
  const percent = used / total * 100

  return {
    name: 'mem',
    full_text: `MEM ${used.toFixed(1)}G ${percent.toFixed(2)}%`,
    color: percent > DANGER_THRESHOLDS.mem ? colors.sick : colors.normal
  }
}

const getTemp = async () => {
  const { stdout } = await exec('acpi -t')
  const [ _1, _2, status, temp ] = stdout.split(/\s+/)
  return {
    name: 'temp',
    full_text: `TEMP ${temp} ${unicodes.degree}C`,
    color: status !== 'ok,' ? colors.sick : colors.normal
  }
}

const getVolume = async () => {
  const { stdout } = await exec('amixer get Master | grep "Front Left"')

  const [ volume, state ] = stdout.match(/\[.*?\]/g).map(d => d.replace(/[\[\]]/g, ''))
  if (state === 'on') return { name: 'volume', full_text: volume }
  else return { name: 'volume', full_text: '0%', color: colors.uneasy }
}
const getDiskSpace = async () => {
  const { stdout } = await exec(`df -k /dev/sda2`)
  const { available, usePercent } = parseTable(stdout, ['_', 'size','used','available','usePercent'], parseInt)[1]
  const availableHuman = available / Math.pow(1024, 2)
  return [{
    name: '/dev/sda2',
    full_text: `DISK: ${availableHuman.toFixed(1)}G`,
    color: availableHuman < 10 ? colors.sick : colors.normal
  }]
}

const byteData = {
  transmitted: 0,
  received: 0,
  tx: undefined,
  rx: undefined
}
const networkData = [
  {
    name: 'vpn',
    regex: /^tun0/,
    head: 'VPN:',
  },
  {
    name: 'wifi',
    regex: /^(wlp|wlan)/,
    head: 'W:'
  },
  {
    name: 'ethernet',
    regex: /^(en|eth)/,
    head: 'E:',
    hide_if_down: true
  },
  {
    name: 'usb',
    regex: /^usb/,
    head: 'U:',
    hide_if_down: true
  },
].map(e => ({
  bytes: byteData,
  devices: new Set(),
  ...e
}))
const getNetwork = async () => {
  const [ status, info ] = await Promise.all([ exec('ip link'), read('/proc/net/dev') ])

  const deviceStates = parseTable(status.stdout, ['_','device','_','_','_','_','_','_','state'],
    item => item.replace(':', ''))
    .filter(({ device }, i, { length }) =>
      i % 2 === 0 && i !== length - 1)
    // .forEach(({ device, state }) => {
      // const index = networkData.findIndex(({ regex }) => regex.test(device))
      // if (index !== -1) {
        // networkData[index].state = state
        // networkData[index].devices.add(device)
      // }
    // })


  const deviceBytes = parseTable(info.toString(), ['device','rBytes','_','_','_','_','_','_','_','tBytes'],
    item => item.replace(':', ''))
    .filter(({ device, rBytes, tBytes }, i, { length }) =>
      i > 1
      && i !== length - 1
      && !(rBytes === '0' && tBytes === '0'))
    // .forEach(({ device, rBytes, tBytes }) => {
      // const index = networkData.findIndex(({ regex }) => regex.test(device))
      // if (index !== -1) {
        // const { devices, bytes } = networkData[index]
        // networkData[index].devices.add(device)
        // networkData[index].bytes = {
          // rx: bytes.received ? rBytes - bytes.received : 0,
          // tx: bytes.transmitted ? tBytes - bytes.transmitted : 0,
          // transmitted: tBytes,
          // received: rBytes
        // }
      // }
    // })

  for (const entry of Object.values(networkData)) {
    const { state = 'DOWN', device: stateDevice } = deviceStates.find(
      ({ device, state = 'DOWN' }) => (entry.regex.test(device) && state !== 'DOWN')) || {}
    entry.state = state
    stateDevice && entry.devices.add(stateDevice)

    deviceBytes.filter(({ device }) => entry.regex.test(device))
      .forEach(({ device, rBytes, tBytes }) => {
        entry.devices.add(device)
        debug({
          received: entry.bytes.received,
          rBytes,
          tBytes
        })
        // debug(entry.bytes.received, rBytes)
        entry.bytes = {
          rx: entry.bytes.received ? rBytes - entry.bytes.received : 0,
          tx: entry.bytes.transmitted ? tBytes - entry.bytes.transmitted : 0,
          transmitted: tBytes,
          received: rBytes
        }
      })
  }

  const loggedEntries = []
  const networkInterfaces = os.networkInterfaces()
  let IPv6
  for (const entry of networkData) {
    const {
      name,
      head,
      hide_if_down,
      bytes,
      state,
      devices
    } = entry

    if (!state || state === 'DOWN') {
      if (!hide_if_down) {
        loggedEntries.push({ name, full_text: `${head} down`, color: colors.sick })
      }
    } else {
      if (name === 'wifi') {
        // get signal strength with: exec('nmcli dev wifi') (0.096s)
        const [ { stdout: networkName } ] = await Promise.all([ exec('iwgetid -r') ])
        const ssid = networkName.trim()

        const [ rx, tx, received ] = [ bytes.rx, bytes.tx, bytes.received ].map(humanReadable)
        const [ IPv4, IPv6Wifi ] = networkInterfaces[Array.from(devices)[0]]
        IPv6 = IPv6Wifi
        const { address } = IPv4
        const full_text = `${head} ${unicodes.upload} ${tx}b/s ${unicodes.download} ${rx}b/s of ${received}B at (${ssid} ${address})`
        // if (IPv6) loggedEntries.push({ name: 'ipv6', full_text: `IPv6 ${IPv6.address}`, color: colors.healthy })
        loggedEntries.push({ name, full_text, color: colors.healthy })

      } else if (name ==='vpn') {
        const [ transmitted, received ] = [ bytes.transmitted, bytes.received ].map(humanReadable)
        const full_text = `${head} ${unicodes.upload} ${transmitted}B ${unicodes.download} ${received}B`
        loggedEntries.push({ name, full_text, color: colors.healthy })
      } else if (name === 'ethernet') {
        const [ IPv4, IPv6Wifi ] = networkInterfaces[Array.from(devices)[0]]
        const { address } = IPv4

        debug(bytes)
        const [ rx, tx, received ] = [ bytes.rx, bytes.tx, bytes.received ].map(humanReadable)

        const full_text = `${head} ${unicodes.upload} ${tx}b/s ${unicodes.download} ${rx}b/s of ${received}B at ${address}`
        loggedEntries.push({ name, full_text, color: colors.healthy })
      } else if (name === 'usb') {
        const full_text = `${head} UP`
        loggedEntries.push({ name, full_text, color: colors.healthy })
      } else {
          throw new Error(`no handler for ${name}`)
      }
    }
  }

  return loggedEntries
}

const getStatus = async () => {
  // [ batteries, cpu, mem, temp, network ]
  const [ date, cpu, mem ] = [ getDate, getCPU, getMem, ].map(f => f()) // get sync
  const [ batteries, temp, volume, network, disks, timeSince ] = await Promise.all([ // get async
    getBatteries(),
    getTemp(),
    getVolume(),
    getNetwork(),
    getDiskSpace(),
    getTimeSinceShutdown()
  ])
  return [
    volume,
    ...network,
    mem,
    cpu,
    temp,
    ...disks,
    ...batteries,
    timeSince,
    date
  ].map(entry => DEBUG ? entry : ({ ...entry, separator: true, separator_block_width: 16 }))
}

const printStatus = async () => {
  try {
    track.start('getStatus')
    const status = await getStatus()
    track.log('getStatus')
    // debug(status)
    i3log(status)
  } catch(error) {
    debug(error)
    i3log({ name: 'bad', full_text: error.message, color: colors.sick })
  }
  if (DEBUG) process.exit(0)
}

let killing = false
process.on('unhandledRejection', (e) => console.error(e))
process.on('SIGUSR1', async () => {
  if (!killing) {
    killing = true
    track.start('update volume')
    const status = await getStatus()
    // const index = status.findIndex(({ name }) => name === 'volume')
    // volume = await getVolume()
    // status[index] = { ...volume, separator: true, separator_block_width: 16 }
    track.log('update volume')
    i3log(status)
    killing = false
  }
})
const loopPrint = async () => {
  DEBUG || console.log(header)
  while (true) {
    await printStatus()
    await delay(1000)
  }
}
// i3log(header) // put this here and shit gets weird
loopPrint()

// IDEAS:
/*
 * [x] four bars for the 4 cores: _--_ at their different percentages
 * [ ] show moon phases unicode chars
 * [x] networks measure speed from from start of second to end of second
 * [x] show disk space
 * [ ] show music play pause
 * [ ] number of keys pressed since startup
 * [ ] time since last reboot
 * [ ] when volume key hit, only update volume using 'state' for the other statuses if its faster
 */
