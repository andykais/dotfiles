#!/bin/node

const readline = require('readline');
const { createReadStream } = require('fs')
const { exec } = require('child_process')
const { promisify } = require('util')
const shell = promisify(exec)

process.on('unhandledRejection', err => console.error(err))

const file = '/var/log/pacman.log'

const run = async () => {
  const dbFlag = process.argv[2] === 'aur'
    ? 'm' // aur packages
    : 'n' // regular packages
  const explicitly_installed_packages_output = await shell(`sh -c "pacman -Qqe${dbFlag}"`)
  const explicitly_installed_set = new Set(explicitly_installed_packages_output.stdout.split('\n'))
  explicitly_installed_set.delete('')

  const datetime_package_version = /\[(.*?)\] \[.*?\] installed ([a-z-_]+) \((.*?)\)/

  const packages = {}
  let longestPackage = 0
  let longestVersion = 0

  const rl = readline.createInterface({
    input: createReadStream(file),
    crlfDelay: Infinity
  })
    .on('line', (line) => {
      const match = datetime_package_version.exec(line)
      if (match && explicitly_installed_set.has(match[2])) {
        const [ _, datetime, package, version ] = match
        longestPackage = Math.max(longestPackage, package.length)
        longestVersion = Math.max(longestVersion, version.length)
        packages[package] = [ datetime, version ]
      }
    })
    .on('close', result => {
      for (const [package, [datetime, version] ] of Object.entries(packages)) {
        console.log(package.padEnd(longestPackage), version.padEnd(longestVersion), datetime)
      }
    })

}

run()
