require 'socket'
SERV_PORT = 7007
MAXLINE = 100
host = 'localhost'

sock = UDPSocket.new()
sock.bind(host,SERV_PORT)

while true
  dat = sock.recvfrom(MAXLINE)
  line, addrinfo = dat
  p addrinfo
  s_proto, s_port, s_host, s_ip = addrinfo
  sock.send(line, 0, s_host, s_port)
end
