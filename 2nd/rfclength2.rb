module Enumerable
  def sort_by
    res = []
    each_with_index{|e, i| res[i] = [yield(e), i, e]}
    res.sort!.filter{|e| e.pop}
  end
end

len = {}

while gets
  rfc = $1 if /^(\d+)/
  len[rfc] = $1.to_i if /TXT=(\d+)/
end

len.sort_by{|i| i[1]}.reverse!.each_with_index{|r,i|
  puts "#{i+1}: #{r[0]}(#{r[1]})"
}
