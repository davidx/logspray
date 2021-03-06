#!/usr/bin/env ruby

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
require 'date'
require 'fileutils'

Choice.options do
  header ''
  header 'Specific options:'

  option :host, :required => true do
    short '-host'
    long '--host=HOST'
    desc 'The hostname or ip of the amqp server (required)'
  end

  option :queue, :required => true do
    short '-q'
    long '--queue=QUEUE'
    desc 'The queue'
  end
  option :logfile, :required => true do
    short '-f'
    long '--logfile=LOGFILE'
    desc 'The logfile to output to'
  end
  option :logdir do
    short '-d'
    long '--logdir=LOGDIR'
    desc 'The logdir to use'
    default '/var/log/logspray'
  end
  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end
end

DATE=DateTime.now.strftime("%Y%m%d")
HOST = Choice.choices[:host]
QUEUE = Choice.choices[:queue]
LOGDIR = Choice.choices[:logdir]
LOGFILE = Choice.choices[:logfile] || "#{DEFAULT_LOGDIR}/#{QUEUE}/#{DATE}_#{QUEUE}.log"

FileUtils.mkdir_p(File.dirname(LOGFILE))

client = Carrot.new(:host => HOST)
q = client.queue(QUEUE)

file = File.open(LOGFILE, "a")
while msg = q.pop(:ack => true)
  file.syswrite(msg)
  q.ack
end
file.close
Carrot.stop

