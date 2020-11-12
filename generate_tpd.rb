require 'json'

str = File.read 'tpd.txt' # copied from the TPD excel table

arr = str.encode(Encoding::UTF_8).split(?\n).map { _1.split ?\t }
arr.map! do |sub|
	unique_id, benefit, taxonomic_uniqueness, feasibility_of_success, *costs =
			sub.map { _1.start_with?(' $') ? _1.delete(?,)[2..].to_f : _1 }
	{
			unique_id: unique_id,
			benefit: benefit.to_f,
			taxonomic_uniqueness: taxonomic_uniqueness.to_f,
			feasibility_of_success: feasibility_of_success.to_f,
			costs: costs
	}
end
File.write 'tpd.json', JSON.generate(arr)
