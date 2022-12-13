FactoryBot.define do
  factory :temperature do
    association :city, factory: :city
    temp_date { Date.current }
    min_forecasted { 18 }
    max_forecasted { 29 }
    created_at { DateTime.now }
    updated_at { DateTime.now }
  end

  trait :without_temp_date do
    temp_date { nil }
  end

  trait :without_min_forecasted do
    min_forecasted { nil }
  end

  trait :without_max_forecasted do
    max_forecasted { nil }
  end
end
