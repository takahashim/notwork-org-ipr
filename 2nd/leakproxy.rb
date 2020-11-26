#!/usr/bin/env ruby

require 'socket'
require 'thread'

def leak(cli, prx)
  last_from = nil
  while(true)
    ary = IO::select([cli, prx])
    begin
      if ary[0].member? cli
        data = cli.sysread(1024)
        print("--------- MESSAGE FROM CLIENT ---------\n") if last_from != cli
        data.each_line { |line| print line.dump, "\n" }
        prx.syswrite data
        last_from = cli
      end
      if ary[0].member? prx
        data = prx.sysread(1024)
        print("--------- MESSAGE FROM SERVER ---------\n") if last_from != prx
        data.each_line { |line| print line.dump, "\n" }
        cli.syswrite data
        last_from = prx
      end
    rescue EOFError
      cli.close
      prx.close
      return
    end
  end
end

## main
if ARGV.size != 2
  STDERR.print "Usage: leakproxy local_port host:port\n"
  exit 1
end
local_port = ARGV[0]
host, port = ARGV[1].split(':')

STDOUT.sync = true
s = TCPServer.new(local_port)
while(true)
  ns = s.accept
  Thread.start{
    cli = ns
    print "connect from #{ns.peeraddr[3]}.\n"
    prx = TCPSocket.new(host, port)
    leak(cli, prx)
    print "connection closed.\n"
    Thread.exit
  }
end
