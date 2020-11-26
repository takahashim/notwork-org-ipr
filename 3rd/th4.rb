for i in 0..4
  Thread.start(i) do |j|
    sleep 0.1
    print j
  end
end
sleep 1
print "\n"
