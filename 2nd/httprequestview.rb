#!/usr/local/bin/ruby
#  httprequestview.rb -- HTTP Request viewer
#  2000/04/30 by Maki
#
#  usage:
#    ruby httprequestview.rb [port]

require "socket"
require "thread"

CRLF = "\r\n"
port = ARGV.shift || 8080

### from cgi.rb
def escapeHTML(string)
  str = string.dup
  str.gsub!(/&/n, '&amp;')
  str.gsub!(/\"/n, '&quot;')
  str.gsub!(/>/n, '&gt;')
  str.gsub!(/</n, '&lt;')
  str
end

### main
gs = TCPServer.open(port)
addr = gs.addr

printf("server is on %s\n", addr[1])

while true
  ns = gs.accept
  print "accepted: #{ns.peeraddr[3]}\n"

  Thread.start do
    s =	ns
    lines = []
    while request = s.gets
      break if /^[\r\n]+$/ =~ request
      lines << escapeHTML(request)
    end
    mes = lines.join("<br>")

    print "sending message...\n"

    ## send header
    s.write "HTTP/1.0 200 OK"+CRLF
    s.write "Date: #{Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')}"+CRLF
    s.write "Content-Type: text/html"+CRLF
    s.write "Content-Length: #{mes.length}"+CRLF
    s.write CRLF

    ## send body
    s.write "<HTML><TITLE>Request Header Viewer</TITLE>"+CRLF
    s.write "<BODY>"
    s.write "<H2>Request Header Viewer</H2>"
    s.write "<HR>"
    s.write "<BLOCKQUOTE><PRE>"
    s.write mes
    s.write "</PRE></BLOCKQUOTE>"
    s.write "<HR>"
    s.write "</BODY></HTML>"

    print "disconnect: #{s.peeraddr[3]}\n"
    s.close
  end
end
