require "socket"
data = "a"
s = TCPSocket.new("localhost", 8888)
s.write data
while true; end
