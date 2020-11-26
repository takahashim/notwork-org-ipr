#!/usr/bin/env ruby
require 'socket'

# �ݡ��Ȥȥ��ޥ�ɤ��б�ɽ����Ƭ���Ԥ�������
# �Υ����åȤ��Ǽ���뤿��˳����Ƥ���
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

# �ҥץ���������Ӥˤʤ�ʤ��褦��
trap("CHLD", "SIG_IGN")

while true
  if socks = IO.select(Listners, nil, nil, 0)
    socks[0].each{ |sock|
      # ��³��Ԥʤ������ޥ�ɤ���Ф���
      s = sock.accept
      command = InetdConf.assoc(sock)[2]
      fork{
        # ɸ�������Ϥ򥽥��åȤˤĤʤ��ؤ���
        STDIN.reopen(s)
        STDOUT.reopen(s)
        STDERR.reopen(s)
        exec(command)   # ���ޥ�ɤ�¹Ԥ���
      }
      s.close
    }
  end
end
