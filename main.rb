#! /usr/bin/env ruby
require './gpx'
require './moving_average'

# 距離
def dist(p1, p2)
  return 0 unless p2
  x = (p1[:lon] - p2[:lon]) * 6378150 * Math.cos(Math::PI * 35 / 180) / 360 # 35@Tokyo.
  y = (p1[:lat] - p2[:lat]) * 2 * Math::PI * 6378150 / 360
  Math.sqrt(x*x + y*y)
end

def interval(p1, p2)
  return 0 unless p2
  p1[:time] - p2[:time]
end

# 入力gpx
fin = ARGV[0]
# 出力csv
fout = open(fin + '.csv', 'w+')
# 変換
p_prev = nil
ma_ele = MovingAverage.new
ma_lat = MovingAverage.new(thd: 1)
ma_lon = MovingAverage.new(thd: 1)
Gpx.new(fin).points.each_with_index {|p, i|
  # dist-diff, time-diff, ele-ori, lat-ori, lon-ori ele-mod, lat-mod, lon-mod
  d = dist(p, p_prev)
  fout.puts "#{dist(p, p_prev)}, #{interval(p, p_prev)}, #{p[:ele]}, #{p[:lat]}, #{p[:lon]}, #{ma_ele.update(p[:ele])}, #{ma_lat.update(p[:lat])}, #{ma_lon.update(p[:lon])}"
  p_prev = p
}
fout.close
