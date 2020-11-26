i0, j0 = 0, 0
[1,2].each do |i0|
  j0 = i0
end
p defined?(i0)    #=> "local-variable"
p defined?(j0)    #=> "local-variable"

[1,2].each do|i1| # i1 は初出
  j1 = i1         # j1 も初出
end
p defined?(i1)    #=> nil
p defined?(j1)    #=> nil
