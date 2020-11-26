len = {}

while gets
  rfc = $1 if /^(\d+)/
  len[rfc] = $1.to_i if /TXT=(\d+)/
end

len.sort{|j,i| i[1]<=>j[1]}.each_with_index{|r,i|
  puts "#{i+1}: #{r[0]}(#{r[1]})"
}
