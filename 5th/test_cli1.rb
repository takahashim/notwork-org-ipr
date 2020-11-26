require "socket"
data = "a" * 100000
s = TCPSocket.new("localhost", 8888)
s.write data
