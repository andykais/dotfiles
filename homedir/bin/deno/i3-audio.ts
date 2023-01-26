import { Command, StringType } from "https://deno.land/x/cliffy@v0.25.6/command/mod.ts"


/* The old way:
bindsym XF86AudioMute        exec amixer -q set Master toggle     && pkill -f -SIGUSR1 i3status-rx
bindsym XF86AudioRaiseVolume exec amixer -q set Master 5%+ unmute && pkill -f -SIGUSR1 i3status-rx
bindsym XF86AudioLowerVolume exec amixer -q set Master 5%- unmute && pkill -f -SIGUSR1 i3status-rx
bindsym Shift+XF86AudioMute        exec amixer -q set Master toggle     && pkill -f -SIGUSR1 i3status-rx && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga
bindsym Shift+XF86AudioRaiseVolume exec amixer -q set Master 5%+ unmute && pkill -f -SIGUSR1 i3status-rx && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga
bindsym Shift+XF86AudioLowerVolume exec amixer -q set Master 5%- unmute && pkill -f -SIGUSR1 i3status-rx && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga
*/

const text_decoder = new TextDecoder()
const delta_type = new StringType()
const amixer_re = /[a-z][a-z ]*\: Playback [0-9-]+ \[([0-9]+)\%\] (?:[[0-9\.-]+dB\] )?\[(on|off)\]/i

async function exec(bin: string, ...args: string[]) {
  const proc = await new Deno.Command(bin, { args }).output()
  if (proc.code !== 0) throw new Error(`${bin} command failed\n${text_decoder.decode(proc.stderr)}`)
  return proc
}

await new Command()
  .name('i3-audio')
  .description('change i3 volume and refresh i3-status')
  .type('delta', delta_type)
  .arguments('<delta>')
  .action(async (options, delta) => {
    const amixer = await exec('amixer', 'set', 'Master', delta)
    const amixer_output = text_decoder.decode(amixer.stdout)
    const amixer_info = amixer_output.match(amixer_re)
    if (amixer_info === null) throw new Error(`failed to parse amixer output\n${amixer_output}`)
    const [_, volume, state] = amixer_info

    let text = `Volume ${volume}%`
    let icon = "~/bin/custom-icons/weather-clear-symbolic.symbolic-white.png"
    const volume_percent = Math.min(100, parseInt(volume)) / 5
    let progress = `█`.repeat(volume_percent)
    if (state === 'off') {
      icon = "~/bin/custom-icons/weather-clear-night-symbolic.symbolic-white.png"
      text = `Volume muted`
    }
    const expires = '1500'
    await exec('dunstify',
      '-i', icon,
      '-t', expires,
      '-h', `int:value:${volume}`,
      '-h', 'string:synchronous:brightness', `${text} ${progress}`,
      '-r', '1000')
  })
  .parse()
