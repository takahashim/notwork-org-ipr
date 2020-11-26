require 'socket'

host = 'localhost'
port = 8888
CRLF = "\r\n"
URL = ARGV[0] or (puts "Usage: #{$0} URL"; exit)

BODY = <<EOS
<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">
<HTML><HEAD><TITLE>301 Moved Permanently</TITLE></HEAD>
<BODY><H1>301 Moved Permanently</H1>
Moved to <A href="#{URL}">URL</A>
</BODY></HTML>
EOS

def send_response_with_location(s)
  s.write "HTTP/1.0 301 Moved Permanently"+CRLF
  s.write "Date: #{Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')}"+CRLF
  s.write "Content-Type: text/html"+CRLF
  s.write "Location: #{URL}"+CRLF
  s.write "Content-Length: #{BODY.size}"+CRLF+CRLF
  s.write BODY
  print "disconnect: #{s.peeraddr[3]}\n"
  s.close
end

gs = TCPServer.open(port)
while true
  ns = gs.accept
  p ns.peeraddr
  Thread.start do
    s = ns
    while (line = s.gets) != CRLF
      p line
    end
    send_response_with_location(s)
  end
end
