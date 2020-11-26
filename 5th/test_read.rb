require 'socket'
s = TCPServer.new(8888).accept
data = s.read 100000
p data.size
