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

  # ž������ǡ����򲣼�ꤷ�ƽ������뤿��Υ᥽�åɡ�
  # �����������ǡ����˱����ƺ�������롥
  def process_data(data) 
    print_headline
    data.each{ |line| print line.dump, "\n" }
  end

  def leak(cli, svr)
    while(true)
      ary = IO::select([cli, svr]) # �ǡ�����������Ԥ�
      begin
        # ���饢��Ȥ��饵���Ф��������
        if ary[0].member? cli
          @which = FROM_CLIENT
          data = cli.sysread(4096)
          process_data(data) # ��Ѥ���ǡ������������
          svr.syswrite data
          @last = @which
        end
        # �����Ф��饯�饢��Ȥ��������
        if ary[0].member? svr
          @which = FROM_SERVER
          data = svr.sysread(4096)
          process_data(data) # ��Ѥ���ǡ������������
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
