#!/usr/bin/env/ruby

require "socket"

def daemon
  fork do
    Process::setsid
    fork do
      Dir::chdir("/")
      File::umask(0)
      STDIN.close; STDOUT.close; STDERR.close
      yield
    end
  end
  exit!
end

host = ARGV[0] || "localhost"
port = ARGV[1] || 10000

u = UDPSocket.open
u.bind(host, port)
puts "daytime: start on #{host}:#{port}"
daemon do
  loop do
    _, addr = u.recvfrom(256, 0)
    u.send(Time.now.inspect + "\r\n",
           0, addr[2], addr[1])
  end
end
