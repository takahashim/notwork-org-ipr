require 'socket'
MAXLINE = 100
host = 'localhost'
port = 7007

s = UDPSocket.open()
s.connect(host, port)
while line = gets
  s.send(line, 0)
  print s.recv(MAXLINE, 0)
end
