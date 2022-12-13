require 'rails_helper'

RSpec.describe "Cities", type: :request do
  let(:city) { create(:city) }

  describe "GET /v1/cities" do
    context 'Return list of cities' do
      it 'returns success response' do
        get(v1_cities_path)
        data = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(data["data"].size).to eq City.count
      end
    end
  end

  describe "GET /v1/cities/historical_temperatures" do
    context 'Return temperatures list' do
      it 'returns success response' do
        city.set_temperature
        get(historical_temperatures_v1_cities_path(slug: city.slug, start_date: Date.current, end_date: Date.current))

        data = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(data["data"].size).to be > 0
      end

      it 'returns failed incase of invalid slug date' do
        get(historical_temperatures_v1_cities_path(slug: nil, start_date: Date.current, end_date: Date.current))
        expect(response.status).to eq 422
      end

      it 'returns failed incase of invalid start date' do
        get(historical_temperatures_v1_cities_path(slug: city.slug, start_date: nil, end_date: Date.current))
        expect(response.status).to eq 422
      end

      it 'returns failed incase of invalid end date' do
        get(historical_temperatures_v1_cities_path(slug: city.slug, start_date: Date.current, end_date: nil))
        expect(response.status).to eq 422
      end
    end
  end

  describe "POST /v1/cities" do
    context 'Create new city' do
      it 'returns success response' do
        post(
          '/v1/cities',
          params: {
            slug: 'Ardal',
            latitude: 38.4853276,
            longitude: 47.8911209
          }
        )

        data = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(data["status"]).to eq 201
        expect(data["messages"]["success"]).to eq "Ardal successfully created!"
      end

      it 'returns failed in case of invalid slug' do
        post(
          '/v1/cities',
          params: {
            slug: 'Ardal$$$',
            latitude: 38.4853276,
            longitude: 47.8911209
          }
        )

        data = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(data["status"]).to eq 400
        expect(data["messages"]["errors"]).to eq ["Slug should contain only letters"]
      end

      it 'returns failed in case of duplicate location' do
        post(
          '/v1/cities',
          params: {
            slug: 'Ardal',
            latitude: city.latitude,
            longitude: city.longitude
          }
        )

        data = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(data["status"]).to eq 400
        expect(data["messages"]["errors"]).to eq ["Latitude already in use", "Longitude already in use"]
      end
    end
  end

  describe "PATCH  /v1/cities/update" do
    context 'Update the city' do
      it 'returns success response' do
        patch(update_v1_cities_path(slug: city.slug, latitude: 38.4853276, longitude: 47.8911209))

        data = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(data["status"]).to eq 200
        expect(data["messages"]["success"]).to eq "#{city.slug} successfully updated!"
      end

      it 'returns validation errors' do
        patch(update_v1_cities_path(slug: city.slug, latitude: 33338.4853276, longitude: 44447.8911209))

        data = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(data["status"]).to eq 400
        expect(data["messages"]["errors"]).to eq ["Latitude is invalid", "Longitude is invalid"]
      end
    end
  end

  describe "DELETE /v1/cities/delete" do
    context 'Delete the city' do
      it 'returns success response' do
        delete(delete_v1_cities_path(slug: city.slug))

        data = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(data["status"]).to eq 200
        expect(data["messages"]["success"]).to eq "#{city.slug} successfully deleted!"
      end
    end
  end
end
