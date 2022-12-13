class City < ApplicationRecord
	require 'net/http'
	NO_SPECIAL_CHARACTRRS = /\A(^[\w\s-]*$)\Z/i

	#
	# Associations
	#
	has_many :temperatures, dependent: :destroy

	#
	# Validation
	#
	validates(
		:slug,
		presence: {
			message: :can_not_blank
		},
		uniqueness: {
			message: :uniqueness_by_slug
		},
		format: {
			with: City::NO_SPECIAL_CHARACTRRS,
			message: :format_by_slug
		},
		length: {
			maximum: 50,
			message: :to_long_by_slug
		}
	)

	validates(
		:latitude,
		numericality: {
			greater_than_or_equal_to:  -90,
			less_than_or_equal_to:  90,
			message: :numericality_by_latitude
		},
		uniqueness: {
			scope: [:longitude],
			message: :uniqueness_by_location
		}
	)

	validates(
		:longitude,
		numericality: {
			greater_than_or_equal_to: -180,
			less_than_or_equal_to: 180,
			message: :numericality_by_longitude
		},
		uniqueness: {
			scope: [:latitude],
			message: :uniqueness_by_location
		}
	)

	#
	# Callbacks
	#
	after_save :reset_temperatures

	#
	# Instance Methods
	#
	def get_historical(start_date, end_date)
		self.temperatures.where(temp_date: start_date..end_date)
	end

	# Timer API - It can be part of YML in case of system is calling multiple external APIs
	def timer_api
		"https://www.7timer.info/bin/astro.php?lon=#{longitude}&lat=#{latitude}&ac=0&unit=metric&output=json&tzshift=0"
	end

	# Net Http get to capture response
	def temperature_by_timer
		uri = URI(timer_api)
		response = Net::HTTP.get(uri)
		JSON.parse(response)
	rescue StandardError => e
		# Should log error e to ex: NewRelic, Rollbar
		nil
	end

	def get_city_temperature(temperatur=temperature_by_timer)
		temperatur = temperatur["dataseries"].map{|x| x["temp2m"]} rescue []

		{
			min_forecasted: temperatur.min,
			max_forecasted: temperatur.max
		}
	end

	# Create / Update Temperature [1. When new city will be created, 2. Every 3h from cron]
	def set_temperature(temp_date=Date.current)
		temperature = get_city_temperature
		city_temp   = Temperature.find_or_initialize_by(city_id: self.id, temp_date: temp_date)
		city_temp.min_forecasted = temperature[:min_forecasted]
		city_temp.max_forecasted = temperature[:max_forecasted]

		city_temp.save
	end

	#
	# Private Methods
	#
	private
		def reset_temperatures
			ResetTemperaturesJob.perform_later(self.id, true)
		end
end
