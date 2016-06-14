#!/usr/bin/ruby

require_relative "pubsub.rb"
require "optparse"

server= "localhost:8082"
action = nil
num = 10000

opt=OptionParser.new do |opts|
  opts.on("-s", "--server SERVER (#{server})", "server and port."){|v| server=v}
  opts.on("--pub", "publish to 1M channels"){ action = :pub }
  opts.on("--sub", "try subscribing to some channels"){ action = :sub }
  opts.on("-n N", "number of channels"){ |v| num = v.to_i }
end
opt.parse!

if action == :pub
  pub = Publisher.new ""
  
  msgs = []
  (1..6).each do |i|
    msgs << i.to_s * 500
  end
  msgs << "FIN"
  pp msgs
  puts ""
  num.times do |n|
    pub.url= "http://#{server}/respawn/pub/#{n}"
    pub.post msgs
    print "\r#{n}       " if n % 1000 == 0
  end

end
  
