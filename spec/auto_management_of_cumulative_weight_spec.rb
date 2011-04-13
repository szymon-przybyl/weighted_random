require 'spec_helper'

describe WeightedRandom, "auto management of cumulative weight" do

  def cumulative_weight_of(name)
    TestModel.find_by_name(name).cumulative_weight
  end

  before(:each) do
    TestModel.destroy_all
  end

  context "when there are no records saved" do
    describe "on single record create " do
      before(:each) do
        TestModel.create :name => 'first-77', :weight => 77
      end

      it "sets cumulative weight of that record to its weight" do
        cumulative_weight_of('first-77').should be(77)
      end
    end

    describe "on collection of records create " do
      before(:each) do
        TestModel.create [
          {:name => 'first-50', :weight => 50},
          {:name => 'second-1', :weight => 1},
          {:name => 'last-10',  :weight => 10}
        ]
      end

      context "sets cumulative weight of" do
        specify "first record to its weight" do
          cumulative_weight_of('first-50').should be(50)
        end

        specify "second record to first record weight + its weight" do
          cumulative_weight_of('second-1').should be(51)
        end

        specify "third record to first record weight + second record weight + its weight" do
          cumulative_weight_of('last-10').should be(61)
        end
      end
    end
  end

  context "when there are some records saved" do
    before(:each) do
      TestModel.create [
        {:name => 'first-50',  :weight => 50, :cumulative_weight => 50},
        {:name => 'second-10', :weight => 10, :cumulative_weight => 60},
        {:name => 'last-1',    :weight => 1,  :cumulative_weight => 61}
      ]
    end

    describe "on single record create" do
      before(:each) do
        TestModel.create :name => 'new-10', :weight => 10
      end

      it "sets cumulative weight of that record to maximum cumulative weight of existing records + its weight" do
        cumulative_weight_of('new-10').should be(71)
      end

      context "does not change cumulative weights of existing records" do
        specify "first" do
          cumulative_weight_of('first-50').should be(50)
        end

        specify "last" do
          cumulative_weight_of('last-1').should be(61)
        end
      end
    end

    describe "on collection of records create" do
      before(:each) do
        TestModel.create [
          {:name => 'next-10',    :weight => 10},
          {:name => 'another-20', :weight => 20}
        ]
      end

      context "sets cumulative weight of" do
        specify "first created record to max cumulative weight for existing records + its weight" do
          cumulative_weight_of('next-10').should be(71)
        end

        specify "second created record to max cumulative weight for existing records + first record weight + its weight" do
          cumulative_weight_of('another-20').should be(91)
        end
      end

      context "does not change cumulative weights of existing records" do
        specify "first" do
          cumulative_weight_of('first-50').should be(50)
        end

        specify "last" do
          cumulative_weight_of('last-1').should be(61)
        end
      end
    end
  end

end
