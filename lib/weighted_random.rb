require 'weighted_random/railtie'

module WeightedRandom

  module Loader
    def weighted_randomizable
      extend WeightedRandom::ClassMethods
    end
  end

  module ClassMethods
    def weighted_rand
      self.where("cumulative_weight > #{Kernel.rand(self.maximum('cumulative_weight')-1)}").order('cumulative_weight').first
    end

    def create_with_cumulative_weight(collection)
      self.create self.compute_and_insert_cumulative_weight(collection)
    end

    def compute_and_insert_cumulative_weight(collection)
      weight_sum = 0
      collection.collect do |item|
        weight_sum += item[:weight]
        item[:cumulative_weight] = weight_sum
        item
      end
    end
  end

end
