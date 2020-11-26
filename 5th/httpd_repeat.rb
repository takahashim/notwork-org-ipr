#!/usr/bin/env ruby

require 'http_test_stuff'

ns = TCPServer.new(8888)
while true
  s = ns.accept
  begin
    HTTPTestStuff.start(s)
  rescue
    print "#{$!.type} : #{$!}\n"
  ensure
    s.close
  end
end
