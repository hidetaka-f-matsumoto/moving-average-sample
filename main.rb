#! /usr/bin/env ruby
require './gpx'

# 移動平均
$buff = []
def moving_average(sample, num: 3)
  # いきなり 200m 以上の変化は無視
  return if $buff.length > 0 and (sample - $buff.reduce(:+) / $buff.length).abs > 200
  # 直近の値を取り込む
  $buff.push(sample)
  # 古くなった値を捨てる
  $buff.shift($buff.length - num) if $buff.length > num
  # 直近 N 件で平均
  $buff.reduce(:+) / $buff.length
end

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
Gpx.new(fin).points.each_with_index {|p, i|
  # dist-diff, time-diff, ele-ori, ele-mod
  if i == 0
    fout.puts "0, 0, #{p[:ele]}, #{moving_average(p[:ele], num: 3)}"
  else
    fout.puts "#{dist(p, p_prev)}, #{p[:time] - p_prev[:time]}, #{p[:ele]}, #{moving_average(p[:ele], num: 3)}"
  end
  p_prev = p
}
fout.close
