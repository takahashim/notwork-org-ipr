require "thread"

q = Queue.new
for i in 0..4
  q.enq i
  Thread.start do
    j = q.deq
    sleep 0.1
    print j
  end
end
sleep 1
print "\n"
