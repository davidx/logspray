#!/usr/bin/ruby

require 'rubygems'
require 'carrot'
require 'choice'

Choice.options do
  header ''
  header 'Specific options:'

  option :host, :required =>true do
    short '-h'
    long '--host=HOST'
    desc 'The hostname or ip of the amqp server (required)'
    default '10.10.10.100'
  end

  option :queue,:required =>true do
    short '-q'
    long '--queue=QUEUE'
    desc 'The queue'
  end

  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end
end

HOST = Choice.choices[:host]
QUEUE = Choice.choices[:queue]

client = Carrot.new(:host => HOST)
q = client.queue(QUEUE)
while (line = $stdin.gets) do
  q.publish(line)
end
