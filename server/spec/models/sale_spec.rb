require 'rails_helper'

describe Sale do
  subject(:sale) { described_class.create(sale_params) }
  
  let(:sale_params) do
    {
      :widget => widget,
      :quantity => quantity
    }
  end
  let(:widget) do 
    Widget.create(
      :name => "do-dad",
      :quantity => 6,
      :value_in_cents => 456
    )
  end
  let(:quantity) { 3 }

  describe "validations" do
    context "quantity is not present" do
      let(:sale_params) { { :widget => widget } }

      it "is not valid" do
        expect(sale.valid?).to eq(false)
      end
    end

    context "widget is not present" do
      let(:sale_params) { { :quantity => quantity } }

      it "is not valid" do
        expect(sale.valid?).to eq(false)
      end
    end

    context "both widget and quantity are present" do
      it "is valid" do
        expect(sale.valid?).to eq(true)
      end
    end
  end

  describe ".total_sale_in_cents" do
    it "returns the correct amount in cents" do
      expected_amount_in_cents = widget.value_in_cents * quantity

      expect(sale.total_sale_in_cents).to eq(expected_amount_in_cents)
    end
  end
end