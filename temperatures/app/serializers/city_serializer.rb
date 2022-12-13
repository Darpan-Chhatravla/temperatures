class CitySerializer < ApplicationSerializer
  attributes(
    :slug,
    :latitude,
    :longitude
  )
end
