class Api::V1::CitiesController < Api::V1::ApplicationController
  #
  # Filters
  #
  before_action :set_city,           only: %i[ show update destroy historical_temperatures ]
  before_action :set_start_end_date, only: %i[ historical_temperatures ]

  #
  # Actions
  #
  # GET /cities
  def index
    cities = City.all
    cities = run_object_serializer(cities, CitySerializer)
    render_success(cities, nil, true)
  end

  # GET /cities/historical_temperatures
  def historical_temperatures
    temperatures = @city.get_historical(@start_date, @end_date)
    temperatures = run_object_serializer(temperatures, TemperatureSerializer)
    render_success(temperatures, nil, true)
  end

  # POST /cities
  def create
    @city = City.new(city_params)

    if @city.save
      render_created({}, nil, "#{@city.slug} successfully created!")
    else
      render_validation_failed(@city.errors.full_messages, false)
    end
  end

  # PATCH/PUT /cities/:slug
  def update
    if @city.update(city_params)
      render_success({}, nil, "#{@city.slug} successfully updated!")
    else
      render_validation_failed(@city.errors.full_messages, false)
    end
  end

  # DELETE /cities/:slug
  def destroy
    render_success({}, nil, "#{@city.slug} successfully deleted!") if @city.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find_by_slug(params[:slug])
      render_unprocessable_entity("City #{params[:slug]} does not exist") and return if @city.blank?
    end

    # Only allow a list of trusted parameters through.
    def city_params
      params.permit(
        :slug,
        :latitude,
        :longitude
      )
    end

    # Set the date if range is valid
    def set_start_end_date
      @start_date = params[:start_date].try(:to_date)
      @end_date   = params[:end_date].try(:to_date)

      if @start_date.blank? || @end_date.blank? || @start_date > @end_date
        render_unprocessable_entity("Invalid start or/and end date") and return
      end
    end
end