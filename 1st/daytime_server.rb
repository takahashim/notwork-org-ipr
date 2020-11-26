require "socket"

def daemon
  fork do
    Process::setsid
    fork do
      Dir::chdir("/")
      File::umask(0)
      [STDIN,STDOUT,STDERR].each{|fd| fd.close}
      yield
    end
  end
  exit!
end

host = ARGV[0] || "localhost"
port = ARGV[1] || 10000
len, flags = 256, 0

u = UDPSocket.open
u.bind(host, port)
puts "#{File.basename($0)}: start on `#{host}' port #{port}"
daemon do
  loop do
    _, addr = u.recvfrom(len, flags)
    u.send(Time.now.inspect + "\r\n", flags, addr[2], addr[1])
  end
end
