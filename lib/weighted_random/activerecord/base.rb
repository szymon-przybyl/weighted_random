module ActiveRecord
  class Base
    def self.weighted_randomizable
      extend WeightedRandom
    end
  end
end
