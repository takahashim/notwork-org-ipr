require 'socket'

host, port, path = "localhost", 80, "/"

if %r!http://(.*?)(?::(\d+))?(/.*)! =~ ARGV[0]
  host = $1
  port = $2.to_i if $2
  path = $3
end

s = TCPSocket.new(host, port)

s.print "GET #{path} HTTP/1.0\r\n\r\n"
print s.read
s.close
