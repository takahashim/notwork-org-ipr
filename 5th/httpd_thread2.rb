#!/usr/bin/env ruby

require 'http_test_stuff'
require 'thread'

queue = Queue.new
for i in 1..5
  Thread.start{
    while true
      # ���塼���饽���åȤ���Ф�
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
 # ��³��Ԥʤ����塼�˥����åȤ��ɲä���
 queue.push ns.accept
end
