require_relative 'plant'

BEGIN_TIME = Time.now

def Array.product array, *arrays
	array.to_a.to_enum :product, *arrays.map(&:to_a)
end

TAKEN = 14796153683959
TAKEN_ARRAY = TAKEN.to_a
DURATION = TAKEN.max_by(&:duration).duration

FACTOR = 100.0 / TAKEN.reduce(1) { _1 * (DURATION - _2.duration + 1) }

result = Array.product(*TAKEN.map { 0..DURATION - _1.duration }).min_by.with_index do |starts, i|
	print "\r#{(i * FACTOR).round}%"
	DURATION.times.sum do |year|
		TAKEN_ARRAY.zip(starts).sum do |plant, start|
			year >= start ? plant.costs[year - start] || 0 : 0
		end ** 2
	end
end

puts "\r100%"
p result
puts "Time passed: #{Time.now - BEGIN_TIME}s"
