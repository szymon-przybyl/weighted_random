ROOT = File.join(File.dirname(__FILE__), '..')

require 'rspec'

require 'active_record'
require 'active_support'

# Load WeightedRandom module!
require File.join(ROOT, 'lib/weighted_random')

# Load ActiveRecord extension inserter
WeightedRandom::Railtie.insert


# Model for tests
class TestModel < ActiveRecord::Base
  establish_connection :adapter => 'sqlite3', :database => ':memory:'
  connection.create_table self.table_name, :force => true do |t|
    t.string :name
    t.integer :weight
    t.integer :cumulative_weight
  end

  weighted_randomizable
  attr_accessible :name, :weight
end
