class Temperature < ApplicationRecord
	#
	# Association
	#
	belongs_to :city

	#
	# Validation
	#
	validates_presence_of(
		:city,
		:temp_date
	)

	validates(
		:min_forecasted,
		numericality: {
			greater_than_or_equal_to:  -99,
			less_than_or_equal_to:  99
		}
	)

	validates(
		:max_forecasted,
		numericality: {
			greater_than_or_equal_to:  -99,
			less_than_or_equal_to:  99
		}
	)
end
