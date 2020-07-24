#!/bin/env ruby

require 'English'
require 'json'
require 'thread'

COMMAND = 'streamlink twitch.tv/%s --json'.freeze

OPEN_STREAM = 'streamlink --quiet twitch.tv/%s %s --player mpv'.freeze

CONFIG_FILE = "#{Dir.home}/.config/strofi/channels".freeze

def get_channels
  channels = File.readlines(CONFIG_FILE)
  channels.map(&:strip)
end

def get_available_streams(channel)
  output = `#{format(COMMAND, channel)}`.chomp

  return [] unless $CHILD_STATUS.success?

  JSON.parse(output)['streams'].keys
end

def get_streams
  streams = {}
  threads = []

  get_channels.each do |channel|
    threads << Thread.new do
      streams[channel] = get_available_streams(channel)
    end
  end

  threads.each(&:join)
  streams
end

def rofi(list)
  `rofi -dmenu <<EOF\n#{list.join("\n")}\nEOF`.chomp
end

exit 1 unless File.exist?(CONFIG_FILE)

streams = get_streams
active_streams = streams.keys.reject { streams[_1] == [] }
exit 1 if active_streams.empty?

stream_choice = rofi(active_streams)
exit 1 if stream_choice.empty?

quality_choice = rofi(streams[stream_choice])
exit 1 if quality_choice.empty?

exec(format(OPEN_STREAM, stream_choice, quality_choice))
