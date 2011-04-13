require 'weighted_random/railtie'

module WeightedRandom

  module Loader
    def weighted_randomizable
      extend WeightedRandom::ClassMethods
      include WeightedRandom::InstanceMethods
    end
  end

  module ClassMethods
    def weighted_rand
      where("cumulative_weight > #{Kernel.rand(maximum('cumulative_weight'))}").order('cumulative_weight').first
    end

    def self.extended base
      base.class_eval do
        before_create :set_cumulative_weight_of_new_record
      end
    end
  end

  module InstanceMethods
    private

      def set_cumulative_weight_of_new_record
        self.cumulative_weight = self.class.maximum('cumulative_weight').to_i + self.weight
      end
  end

end
