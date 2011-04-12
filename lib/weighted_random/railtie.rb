module WeightedRandom
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'weighted_random.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
            WeightedRandom::Railtie.insert
        end
      end
    end
  end

  class Railtie
    def self.insert
      ActiveRecord::Base.send(:extend, WeightedRandom::Loader)
    end
  end
end
