class TemperatureSerializer < ApplicationSerializer
  attributes(
    :date,
    :min_forecasted,
    :max_forecasted
  )

  def date
    object.temp_date
  end
end
