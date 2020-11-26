#!/usr/bin/env ruby

require 'http_test_stuff'
require 'thread'

ns = TCPServer.new(8888)

loop do
  s = ns.accept
  Thread.start{
    begin
      HTTPTestStuff.start(s)
    rescue
      print "#{$!.type} : #{$!}\n"
    ensure
      s.close
    end
  }
end
