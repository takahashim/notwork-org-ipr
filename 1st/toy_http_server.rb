# super simple http server
#   Usage: ruby toy_http_server.rb (port)
 
require "socket"

DocumentRoot = '/home/foo/www/docs'  ## document root directory

port = ARGV.shift || 8080
CRLF = "\r\n"

def send_response(s, num, mes, line)
  s.write "HTTP/1.0 #{num} #{mes}"+CRLF
  s.write "Date: #{Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')}"+CRLF
  s.write "Content-Type: text/html"+CRLF
  s.write "Content-Length: #{line.size}"+CRLF+CRLF
  s.write line
  print "disconnect: #{s.addr[3]}\n"
  s.close
end

sock = TCPServer.open(port)
printf("http server started on %d\n", port)

while TRUE
  ns = sock.accept
  print "connect:    #{ns.addr[3]}\n"

  Thread.start do
    s = ns
    header = []

    request_line = s.gets
    
    ## 5????????????????
    if %r|^GET\s+(/[^\s]*)\s+(HTTP/\d+.\d+)|i !~ request_line

      ## ???????????0
      line = "<html><title>400 Bad Request</title>
<body><h1>Bad Request</h1><p>This server cannot understand your requset.</p>
</body></html>"
      send_response(s, 400, "Bad Request", line)
      Thread.exit
    end

    path, http_version = $1, $2

    ## ????????????????
    if ! FileTest.file?(DocumentRoot + path)

      ## ?????404
      line = "<html><title>404 File Not Found</title>
<body><h1>File Not Found</h1><p>request URI #{path} is not found.</p>
</body></html>"
      send_response(s, 404, "File Not Found", line)
      Thread.exit
    end

    while str = s.gets
      header << str
      if str == CRLF
	 f = open(DocumentRoot + path,"r")
	 line = f.readlines(CRLF).join(CRLF)
	 send_response(s, 200, "OK", line)
      end
    end
  end
end
