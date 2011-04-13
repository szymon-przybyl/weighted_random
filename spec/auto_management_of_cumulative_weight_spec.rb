require 'spec_helper'

describe WeightedRandom, "auto management of cumulative weight" do

  def cumulative_weight_of(name)
    TestModel.find_by_name(name).cumulative_weight
  end

  describe "#create_with_cumulative_weight sets cumulative_weight to" do
    before(:all) do
      TestModel.create_with_cumulative_weight [
        {:name => 'first-50',  :weight => 50},
        {:name => 'second-1', :weight => 1},
        {:name => 'last-10',  :weight => 10}
      ]
    end

    specify "50 for first record with weight 50" do
      cumulative_weight_of('first-50').should be(50)
    end

    specify "51 for second record with weight 1" do
      cumulative_weight_of('second-1').should be(51)
    end

    specify "61 for last record with weight 10" do
      cumulative_weight_of('last-10').should be(61)
    end
  end
end
