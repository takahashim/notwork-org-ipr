require 'socket'
s = TCPServer.new(8888).accept
data = s.sysread 100000
p data.size
