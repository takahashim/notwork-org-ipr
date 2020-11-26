#! /usr/local/bin/ruby

require 'socket'

gs = TCPServer.open(22222)
socks = [gs]

loop do
  nsock = IO.select(socks)
  next if nsock == nil
  for s in nsock[0]
    if s == gs
      socks.push(j = s.accept)
      print j, " is accept\n"
    else
      if s.eof?
	print s, " is gone\n"
	s.close
	socks.delete(s)
      else
	str = s.gets    # 一行入力して
	s.write(str)    # 一行返して
	s.close         # close する
	socks.delete(s)
      end
    end
  end
end
