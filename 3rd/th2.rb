for i in 0..4
  Thread.start do  #1'
    j = i          #3
    sleep 0.1
    print j        #2'
  end
end
sleep 1
print "\n"
