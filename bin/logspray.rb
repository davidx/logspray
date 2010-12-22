#!/usr/bin/ruby

=begin
 Copyright (c) 2010 David Andersen | davidx.org | davidx at davidx.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
=end


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
