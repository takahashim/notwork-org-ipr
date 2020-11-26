require 'socket'

host = 'localhost'
port = 7007

gs = TCPServer.open(port)
while TRUE
  s = gs.accept
  p s.addr
  while line = s.gets
    s.write line
  end
  s.close
end
