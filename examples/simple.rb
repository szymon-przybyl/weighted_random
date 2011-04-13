ROOT = File.join(File.dirname(__FILE__), '..')

require 'active_record'
require 'active_support'

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'weighted_random')

# Load WeightedRandom module!
require File.join(ROOT, 'lib/weighted_random')

# Load ActiveRecord extension inserter
WeightedRandom::Railtie.insert


class LastName < ActiveRecord::Base
  establish_connection :adapter => 'sqlite3', :database => ':memory:'
  connection.create_table self.table_name, :force => true do |t|
    t.string :name
    t.integer :weight
    t.integer :cumulative_weight
  end

  weighted_randomizable
  attr_accessible :name, :weight, :cumulative_weight
end


LastName.create! [
  {:name => 'Smith',    :weight => 10},
  {:name => 'Johnson',  :weight => 8},
  {:name => 'Williams', :weight => 7},
  {:name => 'Jones',    :weight => 6},
  {:name => 'Brown',    :weight => 6},
  {:name => 'Davis',    :weight => 5},
  {:name => 'Miller',   :weight => 4},
  {:name => 'Wilson',   :weight => 3}
]

10.times { puts LastName.weighted_rand }
