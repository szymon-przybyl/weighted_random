TIMES = (ENV['N'] || 1000).to_i
RECORDS = 1000

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

  weighted_randomizable
  attr_accessible :name, :weight, :cumulative_weight
end

require 'benchmark'

HASHES = []
RECORDS.times { |i| HASHES[i] = { :name => 'Sample name', :weight => rand(1000) } }

Benchmark.bmbm do |bm|
  bm.report 'WRModel.create for one record on empty table' do
    TIMES.times do |i|
      Exhibit.create HASHES[i % RECORDS]
      Exhibit.delete_all
    end
  end

  bm.report "WRModel.create for #{RECORDS} records on empty table" do
    (TIMES/RECORDS).times do |i|
      Exhibit.create HASHES
      Exhibit.delete_all
    end
  end

  Exhibit.create HASHES

  bm.report "WRModel.create for one record on table with #{TIMES}+ records" do
    TIMES.times { |i| Exhibit.create HASHES[i % RECORDS] }
  end

  Exhibit.delete_all
  Exhibit.create HASHES

  bm.report "WRModel.create for #{RECORDS} records on table with #{TIMES}+ records" do
    (TIMES/RECORDS).times { |i| Exhibit.create HASHES }
  end

  Exhibit.delete_all
  10.times { Exhibit.create HASHES }

  bm.report "WRModel.weighted_rand on table with #{TIMES*10} records" do
    TIMES.times { Exhibit.weighted_rand }
  end

end
