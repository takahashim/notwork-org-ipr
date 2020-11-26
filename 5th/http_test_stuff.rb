require 'socket'

module HTTPTestStuff
  # ������κݤ˥ڡ������ɤ߹���
  SamplePage = open("index.html").read
  CRLF = "\r\n"

  def start(sock)
    addr = sock.peeraddr
    print "connect from #{addr[2]}:#{addr[1]}\n" if $DEBUG

    request_line = sock.gets # Request-Line ���ɤ�
    raise "Bad Request" if request_line == nil
    while true               # �إå��������ɤ�
      line = sock.gets
      raise "Bad Request" if line == nil
      break if line == CRLF
    end

    # GET ���Ф��Ƥ��ɤ߹�����ڡ������֤���
    # ����ʳ��ϥ��顼�Ȥ��롥
    if /^GET\s+\S+\s+HTTP\/\d+\.\d+/ =~ request_line
      sock.write "HTTP/1.0 200 OK" + CRLF
      sock.write "Content-Type: text/html" + CRLF
      sock.write "Content-Length: #{SamplePage.size}" + CRLF
      sock.write CRLF
      sock.write SamplePage
    else
      sock.write \
        "HTTP/1.0 500 Internal Server Error" + CRLF + CRLF
    end
  end
  module_function :start

  # �����ʥ�ϥ�ɥ� Ctrc-C �� CPU ���֤����
  trap("INT"){
    print "%f %f %f %f\n" % Time.times.entries
    exit 0
  }
end
