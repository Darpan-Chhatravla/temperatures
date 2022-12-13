class ResetTemperaturesJob < ApplicationJob
  queue_as :default

  # Refresh/Create min and max forecasted temperature using timer api
  def perform(city_id, reset_all=false)
    city = City.find_by_id(city_id)

    if reset_all
      city.temperatures.destroy_all
    end

    city.set_temperature
  end
end
