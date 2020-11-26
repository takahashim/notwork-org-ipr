require 'socket'

host = 'localhost'
port = 7007

gs = TCPServer.open(port)
while TRUE
  ns = gs.accept
  p ns.addr
  Thread.start do
    s = ns
    while line = s.gets
      s.write line
    end
    s.close
  end
end
