FactoryBot.define do
  factory :city do
    slug { 'Bijar' }
    latitude { 32.735278 }
    longitude { 59.466667 }
    created_at { DateTime.now }
    updated_at { DateTime.now }
  end

  trait :without_slug do
    slug { nil }
  end

  trait :without_latitude do
    latitude { nil }
  end

  trait :without_longitude do
    longitude { nil }
  end

  trait :with_invalid_slug do
    slug { 3222.9925 }
  end

  trait :with_invalid_latitude do
    latitude { 3222.9925 }
  end

  trait :with_invalid_longitude do
    longitude { 4777.419722 }
  end
end
