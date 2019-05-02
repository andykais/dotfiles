#!/bin/env node

const readline = require('readline');
const {spawn} = require('child_process');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
});

const [command, ...args] = process.argv.slice(2);

// TODO handle case with no command
const runCommand = data =>
  new Promise((resolve, reject) => {
    const stdoutBuf = [];
    const stderrBuf = [];

    const pipeable = spawn(command, args);
    // console.log('pipin');
    pipeable.stdin.write(data);
    pipeable.stdin.end();
    pipeable.stdout.on('data', data => stdoutBuf.push(data));
    pipeable.stderr.on('data', data => stderrBuf.push(data));

    pipeable.on('exit', code => {
      if (code !== 0) reject(`${command} had non zero exit code ${code}`);
      else {
        const stdout = Buffer.concat(stdoutBuf).toString();
        const stderr = Buffer.concat(stderrBuf).toString();
        resolve({stdout, stderr});
      }
    });
    pipeable.on('error', reject);
  });

let changedSinceStarting = false;
let output = '';
rl.on('line', line => {
  output += '\n' + line;
  // console.log(output);
  changedSinceStarting = true;
  scheduler();
});

let inProgress = false;
const executor = async () => {
  inProgress = true;
  changedSinceStarting = false;
  const {stdout, stderr} = await runCommand(output);
  console.clear();
  // console.log({stdout});
  const newlineCount = stdout.split('\n').length
  process.stdout.write(stdout);
  // process.stderr.write(stderr);
  // readline.moveCursor(0,0)
  // readline.moveCursor(0, -newlineCount)
  // readline.moveCursor(process.stdout, 0)
  // process.stdout.moveCursor(0, -newlineCount);
  // readline.cursorTo(process.stdout, 0)
  // console.log(newlineCount);
  inProgress = false;
};

const scheduler = async () => {
  if (!inProgress) {
    while (changedSinceStarting) {
      await executor();
    }
  }
};
