for i in 0..4
  Thread.start do
    print i
  end
end
sleep 1
print "\n"
