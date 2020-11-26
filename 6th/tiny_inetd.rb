#!/usr/bin/env ruby
require 'socket'

# ポートとコマンドの対応表．先頭は待ち受け用
# のソケットを格納するために開けておく
InetdConf = [
  [ nil, 10013, "finger" ],
  [ nil, 10079, "date"   ]
]

Listners = Array.new
InetdConf.each{ |conf|
  print "start #{conf[1]} -> #{conf[2]}\n"
  s = TCPServer.new(conf[1])
  Listners << s
  conf[0] = s
}

# 子プロセスがゾンビにならないように
trap("CHLD", "SIG_IGN")

while true
  if socks = IO.select(Listners, nil, nil, 0)
    socks[0].each{ |sock|
      # 接続を行ない，コマンドを取り出す．
      s = sock.accept
      command = InetdConf.assoc(sock)[2]
      fork{
        # 標準入出力をソケットにつなぎ替える
        STDIN.reopen(s)
        STDOUT.reopen(s)
        STDERR.reopen(s)
        exec(command)   # コマンドを実行する
      }
      s.close
    }
  end
end
