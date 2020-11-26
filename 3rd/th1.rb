for i in 0..4
  Thread.start do #1
    sleep 0.1
    print i       #2
  end
end
sleep 1
print "\n"
