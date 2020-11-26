#! /usr/local/bin/ruby

require 'socket'
require 'thread'

$total = 0

trap('PIPE') {
  $total += 1
  puts "trap:#$total"
}

max = 5

th = []
1.upto(max) do
  th << Thread.start {
    s = TCPSocket.open('localhost', 22222)
    begin
      s.print "jjj\n"
      print s.gets
      if s.gets.nil?
	puts 'EOF'
      end
    rescue Errno::EPIPE
      puts "err:#$total"
    end
  }
end

1.upto(max) do
  th.pop.join
end
