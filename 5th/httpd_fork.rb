#!/usr/bin/env ruby

require 'http_test_stuff'

# 子プロセスの後始末．意味は異なるが，
# trap("CHLD"){ Process::wait }
# でもよい．
trap("CHLD", "SIG_IGN")

ns = TCPServer.new(8888)
loop do
  s = ns.accept
  fork{
    begin
      HTTPTestStuff.start(s)
    rescue
      print "#{$!.type} : #{$!}\n"
    ensure
      s.close
    end
  }
  s.close  # 親側のソケットは閉じる
end
