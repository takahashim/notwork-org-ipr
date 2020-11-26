#!/usr/bin/env ruby

require 'http_test_stuff'
require 'thread'

queue = Queue.new
for i in 1..5
  Thread.start{
    while true
      # キューからソケットを取り出す
      s = queue.pop
      begin
        HTTPTestStuff.start(s)
      rescue
        print "#{$!.type} : #{$!}\n"
      ensure
        s.close
      end
    end
  }
end

ns = TCPServer.new(8888)
while true
 # 接続を行ないキューにソケットを追加する
 queue.push ns.accept
end
