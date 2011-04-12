module WeightedRandom
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'weighted_random.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
          ActiveRecord::Base.send(:extend, WeightedRandom::Loader)
        end
      end
    end
  end
end
