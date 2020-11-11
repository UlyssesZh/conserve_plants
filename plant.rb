require 'json'

class Float
	def integerize
		(self * 100).round
	end
	def rounded
		(self / 100).round
	end
end

Plant = Struct.new :id, :unique_id, :benefit, :taxonomic_uniqueness, :feasibility_of_success, :costs, keyword_init: true do
	include Comparable
	def <=> other
		rounded_cost <=> other.rounded_cost
	end
	def integerized_effective_benefit
		@effective_benefit ||= benefit.integerize * taxonomic_uniqueness.integerize * feasibility_of_success.integerize
	end
	def rounded_cost
		@rounded_cost ||= rounded_costs.sum
	end
	def rounded_costs
		@rounded_costs ||= costs.map &:rounded
	end
	def duration
		@duration ||= costs.size - costs.reverse_each.find_index(&:positive?)
	end
	def to_s
		unique_id
	end
end

class Integer
	include Enumerable
	def add plant
		self | 1 << plant.id
	end
	def delete plant
		self & ~(1 << plant.id)
	end
	def include? plant
		self[plant.id] == 1
	end
	def empty?
		zero?
	end
	def each
		return to_enum __method__ unless block_given?
		TPD.each { yield _1 if include? _1 }
	end
end

TPD = JSON.parse(File.read 'tpd.json').map.with_index { Plant.new id: _2, **_1.transform_keys(&:to_sym) }
