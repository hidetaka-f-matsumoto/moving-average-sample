#! /usr/bin/env ruby
require './gpx'
require './moving_average'

# 距離
def dist(p1, p2)
  x = (p1[:lon] - p2[:lon]) * 6378150 * Math.cos(Math::PI * 35 / 180) / 360 # 35@Tokyo.
  y = (p1[:lat] - p2[:lat]) * 2 * Math::PI * 6378150 / 360
  Math.sqrt(x*x + y*y)
end

# 入力gpx
fin = ARGV[0]
# 出力csv
fout = open(fin + '.csv', 'w+')
# 変換
p_prev = nil
ma = MovingAverage.new
Gpx.new(fin).points.each_with_index {|p, i|
  # dist-diff, time-diff, ele-ori, ele-mod
  if i == 0
    fout.puts "0, 0, #{p[:ele]}, #{ma.update(p[:ele])}"
  else
    fout.puts "#{dist(p, p_prev)}, #{p[:time] - p_prev[:time]}, #{p[:ele]}, #{ma.update(p[:ele])}"
  end
  p_prev = p
}
fout.close
