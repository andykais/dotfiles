// import {
// initializeImageMagick,
// ImageMagick,
// MagickImage
// } from "https://deno.land/x/deno_imagemagick@0.0.1/mod.ts"
// import * as x from 'https://deno.land/x/deno_imagemagick@0.0.1'
// await initializeImageMagick()

// Go searching through your folders for images that appear to be wallpaper sized
import * as jpeg from 'https://deno.land/x/jpegts@1.1/mod.ts'
import * as fs from 'https://deno.land/std@0.74.0/fs/mod.ts'
import * as path from 'https://deno.land/std@0.74.0/path/mod.ts'
// import * as uuid from 'https://deno.land/std/uuid/mod.ts'
import EventEmitter from 'https://deno.land/x/event@0.1.0/mod.ts'

type PixelDimensions = { width: number; height: number }
const decoder = new TextDecoder()

const pixel_dimensions_regex = /(\d+)x(\d+)/
function parse_pixel_dimensions(input: string): PixelDimensions {
  const match = input.match(pixel_dimensions_regex)
  if (match) {
    return { width: parseInt(match[1]), height: parseInt(match[2]) }
  } else {
    throw new Error('No dimensions found')
  }
}
async function get_screen_dimensions(): Promise<PixelDimensions> {
  const proc = Deno.run({ cmd: ['xdpyinfo'], stdout: 'piped' })
  const output = decoder.decode(await proc.output())
  const [line] = output.split('\n').filter(line => line.includes('dimensions'))
  return parse_pixel_dimensions(line)
}

const valid_image_types = ['image/jpeg', 'image/jpg', 'image/png']
async function move_if_candidiate(filepath: string, id: number) {
  const mime_proc = Deno.run({ cmd: ['file', '-b', '--mime-type', filepath], stdout: 'piped' })
  const mime_type = decoder.decode(await mime_proc.output()).trim()
  mime_proc.close()
  if (valid_image_types.includes(mime_type)) {
    const magick_proc = Deno.run({ cmd: ['identify', filepath], stdout: 'piped' })
    const magick_output = decoder.decode(await magick_proc.output()).trim()
    magick_proc.close()
    const { width, height } = parse_pixel_dimensions(magick_output)
    if (width > height) {
      const image_ratio = height / width
      const screen_ratio = screen_dimensions.height / screen_dimensions.width
      const ratio_diff = Math.abs(image_ratio - screen_ratio)
      if (ratio_diff <= allowable_ratio_diff) {
        const symlink_filename = `${id.toString().padStart(5, '0')}-${path.basename(filepath)}`
        const symlink_path = path.join(symlink_destination_dir, symlink_filename)
        try {
          await Deno.symlink(filepath, symlink_path)
          return true
        } catch (e) {
          if (e.name !== 'AlreadyExists') throw e
        }
      }
    }
  }
  return false
}

const timeout = (n: number) => new Promise(resolve => setTimeout(resolve, n))
type Task = () => Promise<any>
type TaskEvents = {
  push: [Task]
}
class TaskScheduler extends EventEmitter<TaskEvents> {
  pending_tasks: Task[]
  in_progress_tasks: ReturnType<Task>[]
  constructor(private max_concurrency: number) {
    super()
    this.pending_tasks = []
    this.in_progress_tasks = []
    this.on('push', this.pending_tasks.push.bind(this.pending_tasks))
  }
  push(task: Task) {
    this.emit('push', task)
  }

  async poll_tasks() {
    while (true) {
      await timeout(50)
      const available_slots = this.max_concurrency - this.in_progress_tasks.length
      const newly_scheduled_tasks = this.pending_tasks.splice(0, available_slots)
      for (const task of newly_scheduled_tasks) {
        this.in_progress_tasks.push(task())
      }
    }
  }
  async start() {
    this.poll_tasks()
    while (true) {
      if (this.in_progress_tasks.length) {
        const [oldest_task] = this.in_progress_tasks
        await oldest_task.finally(() => {
          const index = this.in_progress_tasks.findIndex(t => t === oldest_task)
          this.in_progress_tasks.splice(index, 1)
        })
      }
      await timeout(100)
    }
  }
}

async function search_files(scheduler: TaskScheduler) {
  const walk_iterator = fs.walk(search_dir, { followSymlinks: false })
  const stats = { total: 0, symlinked: 0, completed: 0, start_time: new Date() }
  for await (const file of walk_iterator) {
    if (!file.isFile) continue
    const id = stats.total++

    if (file.path.includes('cutiegarden')) continue
    scheduler.push(() =>
      move_if_candidiate(file.path, id).then(symlinked => {
        if (symlinked) stats.symlinked++
        stats.completed++
        const percentage = ((stats.completed / stats.total) * 100).toFixed(3)
        const time_elapsed = (new Date().getTime() - stats.start_time.getTime()) / 1000
        // const estimated_completion_time = (((time_elapsed * (stats.total - stats.completed)) / stats.completed) / 60).toFixed(1)
        // const estimated_completion_time = (time_elapsed * stats.total) / stats.completed
        const estimated_completion_time = ((stats.total - stats.completed) * (time_elapsed / stats.completed) / 60).toFixed(1)
        // console.log(estimated_completion_time)
        // console.log(`Seconds elapsed: ${time_elapsed.toFixed(1)}s, Tasks completed: ${stats.completed}. Ratio: ${time_elapsed / stats.completed}`)
        console.log(
          `Total: ${stats.total}, Symlinked: ${stats.symlinked}, Completed: ${stats.completed} (${percentage}%). Estimated time till completion is ${estimated_completion_time}mins`
        )
      })
    )
    // if (stats.total === 600) break // remove the training wheels when you feel good about it
  }
  console.log(`Search completed in ${(new Date().getTime() - stats.start_time.getTime()) / 1000 / 60} minutes.`)
}

if (Deno.args.length < 2) {
  console.log(`find-wallpaper-candidates: find wallpapers roughly matching your wallpaper dimensions

Usage: find-wallpaper-candidates <search_dir> <symlink_destination_dir>`)
  Deno.exit(1)
}
const [search_dir, symlink_destination_dir] = Deno.args
const allowable_ratio_diff = Deno.args.length >= 3 ? parseFloat(Deno.args[2]) : 0.05
const screen_dimensions = await get_screen_dimensions()

const scheduler = new TaskScheduler(100)
console.log('Beginning search...')
await Promise.all([scheduler.start(), search_files(scheduler)])
console.log('Search complete.')
