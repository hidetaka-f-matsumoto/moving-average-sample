class MovingAverage
  def initialize(num: 3, thd: 200)
    @buff = []
    @num = num
    @num.freeze
    @thd = thd
    @thd.freeze
  end
  def update(sample)
    # いきなり THD 以上の変化は無視
    return if @buff.length > 0 and (sample - current).abs > @thd
    # 直近の値を取り込む
    @buff.push(sample)
    # 古くなった値を捨てる
    @buff.shift(@buff.length - @num) if @buff.length > @num
    # 直近 N 件で平均
    current
  end
  private
  def current
    @buff.reduce(:+) / @buff.length
  end
end
