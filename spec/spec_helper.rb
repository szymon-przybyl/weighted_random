DIR = File.dirname(__FILE__)
ROOT = File.join(DIR, '..')

# Load WeightedRandom module!
require File.join(ROOT, 'lib/weighted_random')

require 'rspec'
require 'active_record'
require 'active_support'

# Load extension inserter
WeightedRandom::Railtie.insert

# Database configuration and connection
config = YAML::load(IO.read(DIR + '/config/database.yml'))
ActiveRecord::Base.establish_connection(config['test'])

# Test model
class TestModel < ActiveRecord::Base
  weighted_randomizable
  attr_accessible :name, :weight, :cumulative_weight

  connection.create_table self.table_name, :force => true do |t|
    t.string :name
    t.integer :weight
    t.integer :cumulative_weight
  end
end
