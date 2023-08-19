---
title: Building text-based game in Ruby, part 1
subtitle: simultaneous, real-time input and output
description: How to do non-blocking input in a Ruby CLI app, as a foundation to a real-time text-based RPG where input and output happen in parallel in a terminal.
---

- [The simplest possible game loop](#the-simplest-possible-game-loop)
- [Getting some output](#getting-some-output)
- [Simultaneous input](#simultaneous-input)
- [Pros, cons, and future plans](#pros-cons-and-future-plans)

Not long ago [I resolved to make a game in Ruby](/posts/2023/why-make-a-text-based-game)—specifically a text-based game, because procuring sprites is tedious.

(The long version: instead of worrying about how the game *looks on-screen*, I'd rather focus on how the game *works* and be content with how it looks *in my imagination*.)

## The simplest possible game loop

To start us off, here's a loop that gets input from the player, then does something with it.

```ruby
loop do
  input = gets
  puts "You said: #{input}"
end
```

Of course, we'll have to add actual content in order for this to become a game. But first let's add a more fundamental element of fun: **things happening in real time**.

To see why, let's imagine that we've just begun our adventure, and our aspiring hero is in the newbie area, ready to take on a wolf or rat. Suddenly, one of the basic beasties appears out of nowhere and lunges! At this point, it would be pretty strange if the hero could sit there calmly contemplating what to do next while their aggressor is frozen mid-leap. And yet **our game loop currently blocks output while it's waiting for input**. Let's change that.

Here's a demonstration (slightly exaggerated) of the simultaneous input/output we're aiming for:

<img src="/images/worlds-realtime-teaser.gif" alt="A simple text-based game in the terminal, where output is appearing while input is being typed below the output." style="width:500px; margin-left: auto; margin-right:auto; display:block"/>

## Getting some output

Before we tackle simultaneous input, let's set up some output. Below are the `Runner` class containing our game loop but slightly modified, and the `Updater` class which reacts to input (echoing it) and updates game state (a timer that generates a message every second).

```ruby
class Runner
  def self.io_loop
    loop do
      input = nil # We'll implement this in the next section.

      if output = Updater.tick(input)
        puts output
      end
    end
  end
end

class Updater
  def self.tick(input)
    return "You said: #{input}" if input

    # On why not Time.now, see https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way
    @time_start ||= Process.clock_gettime(Process::CLOCK_MONOTONIC)

    time_now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    time_elapsed = time_now - @time_start

    if time_elapsed >= 1
      outputs = []

      @time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      return "One second has passed!"
    end
  end
end

# Run the game.
Runner.io_loop
```

The result:

<img src="/images/worlds-realtime-output.gif" alt='In the terminal, output of "One second has passed" appearing every second' style="width:500px; margin-left: auto; margin-right:auto; display:block"/>

Now let's bring back input, this time in a way that doesn't block output.

## Simultaneous input

First, some helper methods:

```ruby
class Helper
  # These methods call system commands setting the terminal to raw or normal mode.
  # Raw mode means each keystroke is sent straight from the terminal, so that we
  # can work with input directly rather than having to wait for a line of input.
  #
  # Note: The `stty` command only works on MacOS and Linux, so if you're on Windows
  # I suggest using WSL (https://learn.microsoft.com/en-us/windows/wsl) to have
  # Linux within Windows. That will also make your life as a Ruby dev on Windows
  # more pleasant in general.
  def self.io_mode_raw! = `stty raw`
  def self.io_mode_normal! = `stty -raw`

  # If the cursor weren't hidden, it would appear at the beginning of the line
  # due to ::io_mode_raw!
  def self.hide_cursor! = print "\033[?25l"
  def self.show_cursor! = print "\033[?25h"

  # Reads newly inputted characters in a way that doesn't block output,
  # to allow output above the input line.
  def self.read_nonblock
    line = ''

    while char = STDIN.read_nonblock(1, exception: false)
      return line if char == :wait_readable
      line << char
    end
  end

  # To allow output above the input line, wraps `puts` in a change to the
  # terminal mode. Also right-pads the output with spaces to prevent the input
  # from "bleeding over" into output wherever an output line is shorter than a
  # line being inputted.
  def self.puts(str)
    terminal_width = `tput cols`.to_i

    io_mode_normal!
    Kernel.puts str.ljust(terminal_width, ' ')
    io_mode_raw!
  end
end
```

Now let's expand the `Runner` class from the previous section. (The `Updater` class stays the same as before.)

```ruby
class Runner
  CURSOR = '█'
  INTERRUPT = "\x03" # Ctrl+C

  def self.io_loop
    loop do
      # We need our own input buffer here because the terminal input buffer is
      # disabled due to Helper::io_mode_raw!
      @input_buffer ||= ''

      new_input = Helper.read_nonblock

      if new_input
        return if new_input.include?(INTERRUPT)

        # Handle Enter.
        new_input_has_newline = new_input.include?("\n") || new_input.include?("\r")
        new_input = new_input.split(/[\n\r]/).first if new_input_has_newline

        # Add new input to buffer (or add nothing, if no new input).
        @input_buffer << (new_input || '')

        # Echo input. The \r is to make the line replacable by new output,
        # while the input line will re-appear below the new output; in effect,
        # to allow output above the input line.
        print "#{@input_buffer}#{CURSOR}\r"
      end

      # Empty the input buffer if Enter was pressed.
      if new_input_has_newline
        input = @input_buffer.strip
        @input_buffer = ''
      end

      # Allow the game to loop, and print output if any.
      if output = Updater.tick(input)
        Helper.puts output
      end

      # Reset input, to remain empty until next time Enter is pressed.
      input = nil if input
    end
  end
end
```

Running the game now involves a few extra lines:

```ruby
# Initial setup.
Helper.io_mode_raw!
Helper.hide_cursor!

# Run the game.
begin
  Runner.io_loop
ensure # when exiting back to the terminal.
  Helper.show_cursor!
  Helper.io_mode_normal!
end
```

And, violà! There we have the essentials for building a real-time text-based game. Here's what the above code looks like when run:

<img src="/images/worlds-realtime-input.gif" alt="A simple text-based game in the terminal, where output is appearing while input is being typed." style="width:500px; margin-left: auto; margin-right:auto; display:block"/>

## Pros, cons, and future plans

There are other ways to build a real-time text-based game: [Curses](https://github.com/ruby/curses), [Scarpe](https://github.com/scarpe-team/scarpe), [DragonRuby Game Toolkit](https://dragonruby.itch.io/), or a web app, to name a few.

So why take the approach I've outlined in this post? What I like about it is that **it's simple**. There's nothing more straightforward than writing to standard output, line by line, and that simplicity will speed up the development of the "guts" of the game.

This approach has its downsides, of course:

- It's visually unappealing.
- It's not very user-friendly, especially since hacking the terminal input means all the terminal's native text-editing features are gone.
  - To somewhat make up for this and the visual blandness, I'm adding colors and backspacing (to delete input), which you can see in [the GitHub repo](https://github.com/fpsvogel/worlds-console). (See [the 0.1.0 release](https://github.com/fpsvogel/worlds-console/tree/0.1.0) if you want to see just the features related to this post.)
- It doesn't work with screen readers.
- It requires installing a Ruby gem, which is not convenient for most people.

Later on I'm thinking of making a web interface for the game—in fact, **that has become a big motivator for me**, since it would give me a great excuse to get good at [Hotwire](https://hotwired.dev/) by using it to build a fancy real-time UI. But for now I'll stick with my minimalist terminal-hacking approach because of its convenience to me as I work on the game's back end.

What next? Now that our real-time input/output system is in place, we can start thinking about **how to organize the game world**. That'll be the topic of the next post in this series.
