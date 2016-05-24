#! /usr/bin/env ruby
require 'time'
require 'nokogiri'

class Gpx
  attr_reader :points
  def initialize(file)
    doc = Nokogiri::XML(open(file))
    trackpoints = doc.css('gpx/trk/trkseg/trkpt')
    @points = []
    trackpoints.each do |trkpt|
      @points << {
        lat: trkpt.xpath('@lat').to_s.to_f,
        lon: trkpt.xpath('@lon').to_s.to_f,
        ele: trkpt.css('ele').text.to_f,
        time: Time.parse(trkpt.css('time').text).to_i
      }
    end
  end
  def to_s
    @points.join(',')
  end
end

# p Gpx.new(ARGV[0])
