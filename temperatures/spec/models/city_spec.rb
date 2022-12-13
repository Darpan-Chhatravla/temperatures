require 'rails_helper'
require 'net/http'

RSpec.describe City, type: :model do
  it "has a valid factory" do
    expect(build(:city)).to be_valid
  end

  describe "validations" do
    it "is not valid without a slug" do
      city = build(:city, :without_slug)
      city.valid?
      expect(city.errors.messages[:slug]).to eq [I18n.t('activerecord.errors.models.city.attributes.slug.can_not_blank')]
    end

    it "is not valid without a latitude" do
      city = build(:city, :without_latitude)
      city.valid?
      expect(city.errors.messages[:latitude]).to eq [I18n.t('activerecord.errors.models.city.attributes.latitude.numericality_by_latitude')]
    end


    it "is not valid without a longitude" do
      city = build(:city, :without_longitude)
      city.valid?
      expect(city.errors.messages[:longitude]).to eq [I18n.t('activerecord.errors.models.city.attributes.longitude.numericality_by_longitude')]
    end

    it "is not valid with invalid slug" do
      city = build(:city, :with_invalid_slug)
      city.valid?
      expect(city.errors.messages[:slug]).to eq [I18n.t('activerecord.errors.models.city.attributes.slug.format_by_slug')]
    end

    it "is not valid with invalid latitude" do
      city = build(:city, :with_invalid_latitude)
      city.valid?
      expect(city.errors.messages[:latitude]).to eq [I18n.t('activerecord.errors.models.city.attributes.latitude.numericality_by_latitude')]
    end

    it "is not valid with invalid longitude" do
      city = build(:city, :with_invalid_longitude)
      city.valid?
      expect(city.errors.messages[:longitude]).to eq [I18n.t('activerecord.errors.models.city.attributes.longitude.numericality_by_longitude')]
    end
  end

  describe "Valid Timer api" do
    it "Link should contain lat long" do
      city = build(:city)
      expect(city.timer_api).to include("#{city.latitude}")
      expect(city.timer_api).to include("#{city.longitude}")
    end

    it "Timer Api should response valid JSON" do
      city = build(:city)
      expect(city.temperature_by_timer).to respond_to(:hash)
    end

    it "Timer Api should raise Net::ReadTimeout" do
      city = build(:city)
      allow(Net::HTTP).to receive(:get_response).and_raise(Net::ReadTimeout)
      expect(city.temperature_by_timer).to eq nil
    end
  end

  describe "Store temperature" do
    it "Should store valid temperature from timer api" do
      city        = create(:city)
      temperature = city.set_temperature
      expect(city.temperatures.count).to be > 0
    end

    it "Should store valid temperature from timer api" do
      city = create(:city)
      city.destroy
      expect(city.temperatures.count).to be == 0
    end

    it "Should return valid historical temperature" do
      city        = create(:city)
      temperature = city.set_temperature
      expect(city.get_historical(Date.current, Date.current).count).to be == 1
    end
  end
end
