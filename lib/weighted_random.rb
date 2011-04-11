module WeightedRandom
  def compute_and_insert_cumulative_weight(collection)
    weight_sum = 0
    collection.collect do |item|
      weight_sum += item[:weight]
      item[:cumulative_weight] = weight_sum
      item
    end
  end

  def create_with_cumulative_weight(collection)
    self.create! self.compute_and_insert_cumulative_weight(collection)
  end

  def weighted_rand
    self.where("cumulative_weight >= #{rand(self.maximum('cumulative_weight'))}").order('cumulative_weight').first
  end
end

require 'weighted_random/activerecord/base'
