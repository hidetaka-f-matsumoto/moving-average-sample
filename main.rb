#! /usr/bin/env ruby
require './gpx'

# 移動平均
def moving_average(samples, num: 3)
  lasts = []
  samples.map {|curr|
    # いきなり 100m 以上の変化は無視
    next if lasts.length > 0 and (curr - lasts.reduce(:+) / lasts.length).abs > 100
    # 直近の値を取り込む
    lasts.push(curr)
    # 古くなった値を捨てる
    lasts.shift(lasts.length - num) if lasts.length > num
    # 直近 N 件で平均
    lasts.reduce(:+) / lasts.length
  }
end

# samples = ARGV[0].split(',').map(&:to_f)
# p "in:  #{samples}"
# p "out: #{moving_average(samples)}"

# 入力gpx
fin = ARGV[0]
# 変換
gpx = Gpx.new(fin)
eles_ori = gpx.points.map {|p| p[:ele] }
eles_mod = moving_average(eles_ori, num: 10)
# 元データ書き出し
fout_ori = open(fin + '_ori.dat', 'w+')
eles_ori.each {|ele| fout_ori.puts ele }
fout_ori.close
# 修正後データ書き出し
fout_mod = open(fin + '_mod.dat', 'w+')
eles_mod.each {|ele| fout_mod.puts ele }
fout_mod.close
