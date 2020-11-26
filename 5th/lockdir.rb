file = "data"
lock = "Lock.foo"

class LockError; end
class Lock
  def initialize(name)
    @name = name
  end

  def synchronize(try = -1)
    # mkdirを試み、成功したら
    # ブロックを評価して、
    # 試行回数を返す。
    # 正の引数は最大試行回数

    init = try
    begin
      Dir::mkdir(@name)
      yield if block_given?
      return init - try
    rescue Errno::EEXIST
      if try != 0
	sleep rand(0)
	try -= 1
	retry
      end
      raise LockError, "Busy"
    ensure
      Dir::rmdir(@name)
    end
  end
end

if __FILE__ == $0
  N = 100
  require "thread"
  job = []
  q = Queue.new

  for x in 1..N
    x.times do |n|
      Thread::new(n){|k|
	l = Lock.new(lock)
	q.enq l.synchronize do
	  open(file, "r+") {|f|
	    d = f.read.to_i
	    sleep rand(0)
	    f.rewind
	    f.puts d+1
	  }
	end
      }
    end

    sum = 0
    x.times{ sum += q.deq }
    puts "#{x} #{sum.to_f/x}"
  end
end
