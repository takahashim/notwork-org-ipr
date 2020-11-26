#! /usr/local/bin/ruby

total = 0

trap('HUP') {
  total += 1
  p total
}

1.upto(5) do
  Process.kill 'HUP', $$
  sleep 1
end
