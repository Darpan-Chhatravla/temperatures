require 'rails_helper'

RSpec.describe Temperature, type: :model do
  it "has a valid factory" do
    expect(build(:temperature)).to be_valid
  end

  describe "associations" do
    context ":city" do
      it "should have a valid city" do
        temperature = build(:temperature)
        expect(temperature.city).to be_valid
      end
    end
  end

  describe "validations" do
    it "is not valid without a temperature date" do
      temperature = build(:temperature, :without_temp_date)
      temperature.valid?
      expect(temperature.errors.messages[:temp_date].count).to eq(1)
    end

    it "is not valid without a temperature date" do
      temperature = build(:temperature, :without_min_forecasted)
      temperature.valid?
      expect(temperature.errors.messages[:min_forecasted].count).to eq(1)
    end

    it "is not valid without a temperature date" do
      temperature = build(:temperature, :without_max_forecasted)
      temperature.valid?
      expect(temperature.errors.messages[:max_forecasted].count).to eq(1)
    end
  end
end
