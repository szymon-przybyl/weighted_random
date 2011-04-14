TIMES = (ENV['N'] || 1000).to_i

require 'active_record'
require 'active_support'

$LOAD_PATH << File.join(File.dirname(__FILE__), '../lib')

require 'weighted_random'

# Insert ActiveRecord extension
WeightedRandom::Railtie.insert

class Exhibit < ActiveRecord::Base
  establish_connection :adapter => 'sqlite3', :database => ':memory:'
  connection.create_table self.table_name, :force => true do |t|
    t.string :name
    t.integer :weight
    t.integer :cumulative_weight
  end
  connection.add_index self.table_name.to_sym, :cumulative_weight

  weighted_randomizable
  attr_accessible :name, :weight
end

require 'benchmark'

HASHES = []
TIMES.times { |i| HASHES[i] = { :name => 'Sample name', :weight => rand(1000) } }

Benchmark.bmbm do |bm|
  bm.report 'WRModel.create with one hash' do
    TIMES.times { |i| Exhibit.create HASHES[i] }
  end

  Exhibit.delete_all

  bm.report "WRModel.create with collection of #{TIMES/10} hashes" do
    10.times { |i| Exhibit.create HASHES[i*TIMES/10, TIMES/10] }
  end

  Exhibit.delete_all
  Exhibit.create HASHES

  bm.report "WRModel.weighted_rand on table with #{TIMES} records" do
    TIMES.times { Exhibit.weighted_rand }
  end

end
