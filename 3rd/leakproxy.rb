#!/usr/bin/env ruby

require 'socket'

class LeakProxy
  FROM_CLIENT = "MESSAGE FROM CLIENT"
  FROM_SERVER = "MESSAGE FROM SERVER"

  private

  def initialize(local_port, host, port)
    @local_port, @host, @port = local_port, host, port
    @which = @last = nil
  end

  def print_headline
    print "---------- #{@which} ----------\n" if @which != @last
  end

  # 転送するデータを横取りして処理するためのメソッド．
  # 処理したいデータに応じて再定義する．
  def process_data(data) 
    print_headline
    data.each{ |line| print line.dump, "\n" }
  end

  def leak(cli, svr)
    while(true)
      ary = IO::select([cli, svr]) # データの到着を待つ
      begin
        # クラアントからサーバへ送る情報
        if ary[0].member? cli
          @which = FROM_CLIENT
          data = cli.sysread(4096)
          process_data(data) # 中継するデータを処理する
          svr.syswrite data
          @last = @which
        end
        # サーバからクラアントへ送る情報
        if ary[0].member? svr
          @which = FROM_SERVER
          data = svr.sysread(4096)
          process_data(data) # 中継するデータを処理する
          cli.syswrite data
          @last = @which
        end
      rescue EOFError
        return
      end
    end
  end

  public

  def start
    s = TCPServer.new(@local_port)
    loop do
      cli = s.accept
      Thread::start{
        print "connect from #{cli.peeraddr[3]}.\n"
        svr = TCPSocket.new(@host, @port)
        leak(cli, svr)
        cli.close
        svr.close
        print "connection closed.\n"
        Thread::exit
      }
    end
  end
end

if $0 == __FILE__
  def usage
    STDERR.print "Usage: leakproxy local_port host:port\n"
    exit 1
  end
  usage unless ARGV.size == 2
  local_port = ARGV[0]
  host, port = ARGV[1].split(':')
  usage unless local_port and host and port
  app = LeakProxy.new(local_port, host, port)
  app.start
end
