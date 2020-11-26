require 'socket'
MAXLINE = 100
host = 'localhost'
port = 7007

s = UDPSocket.open()
s.bind('localhost', 0)
while line = gets
  s.send(line, 0, host, port)
  print s.recv(MAXLINE, 0)
end
