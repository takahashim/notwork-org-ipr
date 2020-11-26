# usage:
# ruby daytime.rb [host [, port [, timeout]]]
require "socket"
require "timeout"

u = UDPSocket.open
host    = ARGV[0] || "localhost"
port    = ARGV[1] || 13
timeout = ARGV[2] || 2
u.send('\0', 0, host, port)
len, flags = 256, 0
begin
  timeout(timeout){print u.recvfrom(len, flags)[0].inspect, "\n"}
rescue TimeoutError
  puts "#{File.basename($0)}: `#{host}': Timeout (#{timeout}sec)"
end
