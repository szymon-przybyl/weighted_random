require 'spec_helper'

describe WeightedRandom, "weighted randomization" do

  def times_drawed(name)
    counter = 0
    rand_times.times { counter += 1 if TestModel.weighted_rand.name == name }
    counter
  end

  context "in 1000 rands" do
    let(:rand_times) { 1000 }

    before(:each) do
      TestModel.destroy_all
      # Set random number generator seed, so every test will receive the same sequence of numbers
      Kernel.srand(77)
    end

    describe "deviation tolerance" do
      before(:each) do
        TestModel.create [
          {:name => 'first-50',  :weight => 50},
          {:name => 'second-25', :weight => 25},
          {:name => 'third-10',  :weight => 10},
          {:name => 'fourth-5',  :weight => 5},
          {:name => 'fifth-3',   :weight => 3},
          {:name => 'sixth-2',   :weight => 2},
          {:name => 'seventh-1', :weight => 1},
          {:name => 'last-4',    :weight => 4}
        ]
      end

      it "draws record with weight 50% of overall within 50 of 500 times (5%   of 50%)" do
        times_drawed('first-50').should be_within(50).of(500)
      end

      it "draws record with weight 25% of overall within 40 of 250 times (4%   of 25%)" do
        times_drawed('second-25').should be_within(40).of(250)
      end

      it "draws record with weight 10% of overall within 25 of 100 times (2.5% of 10%)" do
        times_drawed('third-10').should be_within(25).of(100)
      end

      it "draws record with weight 5%  of overall within 20 of 50  times (2%   of 5%)" do
        times_drawed('fourth-5').should be_within(20).of(50)
      end

      it "draws record with weight 3%  of overall within 15 of 30  times (1.5% of 3%)" do
        times_drawed('fifth-3').should be_within(15).of(30)
      end

      it "draws record with weight 2%  of overall within 10 of 20  times (1%   of 2%)" do
        times_drawed('sixth-2').should be_within(10).of(20)
      end

      it "draws record with weight 1%  of overall within 7  of 10  times (0.7% of 1%)" do
        times_drawed('seventh-1').should be_within(7).of(10)
      end
    end

    describe "boundary records with weight 1 (10% of overall)" do
      before(:each) do
        TestModel.create [
          {:name => 'first-1',  :weight => 1},
          {:name => 'second-8', :weight => 8},
          {:name => 'last-1',   :weight => 1}
        ]
      end

      context "draws within 25 of 100 times (2.5% of 10%)" do
        it "first" do
          times_drawed('first-1').should be_within(25).of(100)
        end

        it "last" do
          times_drawed('last-1').should be_within(25).of(100)
        end
      end
    end
  end

end
