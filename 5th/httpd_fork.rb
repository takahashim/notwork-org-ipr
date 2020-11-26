#!/usr/bin/env ruby

require 'http_test_stuff'

# �ҥץ����θ��������̣�ϰۤʤ뤬��
# trap("CHLD"){ Process::wait }
# �Ǥ�褤��
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
  s.close  # ��¦�Υ����åȤ��Ĥ���
end
