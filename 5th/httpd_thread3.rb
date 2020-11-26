#!/usr/bin/env ruby

require 'http_test_stuff'
require 'thread'

ns = TCPServer.new(8888)
mutex = Mutex.new

for i in 1..5
  Thread.start{
    while true
      begin
        s = nil
        mutex.synchronize{ s = ns.accept }
        HTTPTestStuff.start(s)
      rescue
        print "#{$!.type} : #{$!}\n"
      ensure
        s.close
      end
    end
  }
end

while true; sleep 60; end
