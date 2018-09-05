#!/usr/bin/env node

const {exec, execSync} = require('child_process');
const {resolve} = require('path');
const {readdirSync} = require('fs');
const {homedir} = require('os');

const tmuxinatorProjects = resolve(`${homedir()}/.tmuxinator`);

// utils
const timeout = millis => new Promise(resolve => setTimeout(resolve, millis));
const tmuxed = project => `uxterm -e '~/bin/work.sh on ${project}'`;

const soupedUpEnvironemnts = {
  toost: [
    'i3-msg append_layout ~/.config/i3/editor-compiler-chrome-layout.json',
    'google-chrome-stable',
    tmuxed`toost-editor`,
    tmuxed`toost-compiler`,
    `sleep 3; google-chrome-stable 'http://localhost:8080/api/graphiql'`,
  ],
  'scrape-pages': [
    tmuxed`scrape-pages-editor`,
    tmuxed`scrape-pages-compiler`,
  ],
  bum2: ['bum2-editor', 'bum2-cli'],
};

const individualEnvironments = readdirSync(tmuxinatorProjects)
  .map(project => project.replace(/\.y[a]?ml/, ''))
  .reduce(
    (acc, project) => ({
      ...acc,
      [`_${project}`]: [tmuxed(project)],
    }),
    {},
  );

const environments = {
  ...soupedUpEnvironemnts,
  ...individualEnvironments,
};

const askAndExecute = async () => {
  const answer = await new Promise((resolve, reject) => {
    cp = exec('dmenu', (error, stdout, stderr) => {
      if (error) resolve();
      else resolve(stdout.trim());
    });
    cp.stdin.write(Object.keys(environments).join('\n\r'));
    cp.stdin.end();
  });
  if (answer) {
    for (const project of environments[answer]) {
      // console.log(project)
      exec(project);
      await timeout(50);
    }
  }
};
askAndExecute();
