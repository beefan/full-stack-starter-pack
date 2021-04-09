require 'rails_helper'

describe Widget do
  describe "validations" do
    subject(:widget) { described_class.create(widget_params) }

    let(:widget_params) do
      {
        :name => name,
        :value_in_cents => value_in_cents,
        :quantity => quantity,
        :user => user
      }
    end
    let(:name) { "do-dad" }
    let(:value_in_cents) { 100_00 }
    let(:quantity) { 40 }
    let(:user) do 
      User.create(
        :email => "hi@test.com", 
        :username => "pops89",
        :password => "secure" 
      )
    end

    context "without a name" do
      let(:widget_params) do
        {
          :value_in_cents => value_in_cents,
          :quantity => quantity,
          :user => user
        }
      end

      it "is not valid" do
        expect(widget.valid?).to eq(false)
      end
    end

    context "without a value_in_cents" do
      let(:widget_params) do
        {
          :name => name,
          :quantity => quantity,
          :user => user
        }
      end

      it "is not valid" do
        expect(widget.valid?).to eq(false)
      end
    end

    context "without a quantity" do
      let(:widget_params) do
        {
          :name => name,
          :value_in_cents => value_in_cents,
          :user => user
        }
      end

      it "is not valid" do
        expect(widget.valid?).to eq(false)
      end
    end

    context "without a user" do
      let(:widget_params) do
        {
          :name => name,
          :value_in_cents => value_in_cents,
          :quantity => quantity
        }
      end

      it "is not valid" do
        expect(widget.valid?).to eq(false)
      end
    end

    context "with all required parameters" do
      it "is valid" do
        expect(widget.valid?).to eq(true)
      end
    end
  end
end