require 'socket'

host = 'localhost'
port = 7007

s = TCPSocket.open(host, port)
while line = gets
 s.write line
 print  s.gets
end
