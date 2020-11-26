#!/usr/local/bin/ruby
#
# serverutils.rb -- ServerUtils Module
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi, GOTOU YUUZOU
#
# $Id: serverutils.rb,v 1.8 2000/10/26 17:49:17 gotoyuzo Exp $

require "socket"
require 'thread'

require 'config'
require 'log'

module WEBrick
  module ServerUtils
    class SimpleServer
      def SimpleServer.start
        yield
      end
    end

    ## daemon²½
    class Daemon < SimpleServer
      def Daemon.start
        fork do
          Process::setsid
          fork do
            unless $DEBUG
              Dir::chdir("/")
              File::umask(0)
              STDIN.close; STDOUT.close; STDERR.close
            end
            yield
          end
        end
        exit!
      end
    end

    def WEBrick.start_server(port = nil, server_type = nil)
      unless port
        port = Config::Port
      end
      unless server_type
        server_type = ServerUtils::SimpleServer
      end

      @log = Log.new(Config::LogFile, Log::INFO)
      @log.level = Log::DEBUG if $DEBUG
      num_threads = Config::ThreadNum

      server_type.start{
        queue = Queue.new
        @log.log(Log::DEBUG,
		 "TCPServer: Port = #{port}")
        ns = TCPServer.new(port)

        @log.log(Log::DEBUG,
		 "thread initializing...")
        for i in 1..num_threads
          Thread.start{
            loop do
                s = queue.pop
              begin
                @log.log(Log::DEBUG,
			 "connect: from #{s.peeraddr[3]}.")
                yield s
              rescue
                @log.log(Log::FATAL,
			 "error: #{$!.type}, #{$!}")
              ensure
                @log.log(Log::DEBUG,
			 "disconnect: from #{s.peeraddr[3]}.")
                s.close
              end
            end
          }
        end

        loop do
          begin
            s = ns.accept
            s.sync = true
            @log.log(Log::DEBUG,
		     "recieved connection.")
            queue.push s
          rescue
            @log.log(Log::FATAL,
		     "error: #{$!.type}, #{$!}")
          end
        end
      }
    end
  end
end

if __FILE__ == $0
  include WEBrick

  Config.load

  typetab = {
    0, ServerUtils::SimpleServer,
    1, ServerUtils::Daemon,
    2, Thread,
  }

  type = typetab[ARGV[0] ? ARGV[0].to_i : 0]

  WEBrick.start_server(nil, type){ |sock|
    print "#$$ #{sock.inspect}\n"
  }

  if type == Thread # keep main thread
    while true; end
  end
end
