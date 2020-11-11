require_relative 'plant'

BEGIN_TIME = Time.now
SORTED_TPD = TPD.sort

def puts_plants_set taken
	puts TPD.sum('') { taken.include?(_1) ? '|' : ' ' }
end

def max_effective_benefit_recursive remaining_funds, pos
	input = [remaining_funds, pos]
	return @cache[input] if @cache[input]
	return @cache[input] = [0, 0] if pos >= @plants.size || (plant = @plants[pos]).rounded_cost > remaining_funds
	benefit_if_not_take, set_if_not_take = max_effective_benefit_recursive remaining_funds, pos + 1
	benefit_if_take, set_if_take = max_effective_benefit_recursive remaining_funds - plant.rounded_cost, pos + 1
	benefit_if_take += plant.integerized_effective_benefit
	set_if_take = set_if_take.add plant
	@cache[input] = benefit_if_take > benefit_if_not_take ? [benefit_if_take, set_if_take] : [benefit_if_not_take, set_if_not_take]
end

def max_effective_benefit_under funds
	max_effective_benefit_recursive funds, 0
end

def max_time_efficiency_under funds
	@plants = SORTED_TPD.clone
	max_time_efficiency, max_time_efficiency_taken = 0r, []
	loop do
		@cache = {}
		max_effective_benefit, taken = max_effective_benefit_under funds
		plant_to_be_removed, index_to_be_removed = @plants.each_with_index.max_by { |plant, i| taken.include?(plant) ? plant.duration : 0 }
		puts_plants_set taken
		break unless plant_to_be_removed && taken.include?(plant_to_be_removed)
		new_time_efficiency = max_effective_benefit.quo plant_to_be_removed.duration
		max_time_efficiency, max_time_efficiency_taken = new_time_efficiency, taken if new_time_efficiency > max_time_efficiency
		@plants.delete_at index_to_be_removed
	end
	[max_time_efficiency, max_time_efficiency_taken]
end

def max_efficiency_under
	funds = TPD.sum &:rounded_cost
	max_efficiency, max_efficiency_taken, max_efficiency_funds = 0r, 0, funds
	loop do
		puts "Funds: #{funds}"
		max_time_efficiency, taken = max_time_efficiency_under funds
		break if taken.empty?
		cost = taken.sum &:rounded_cost
		new_efficiency = max_time_efficiency / cost
		max_efficiency, max_efficiency_taken, max_efficiency_funds = new_efficiency, taken, cost if new_efficiency > max_efficiency
		funds = cost - 1
	end
	[max_efficiency, max_efficiency_taken, max_efficiency_funds]
end

(0..510000).step 3000 do |funds|
	IO.write 'output.txt',
	         "#{funds}: #{max_time_efficiency_under(funds).join ' '}\n",
	         mode: 'a'
end

puts "Time passed: #{Time.now - BEGIN_TIME}"
