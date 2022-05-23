require "time"

FactoryBot.define do
  factory :customer do
    name { "Customer name" }
    address { "Customer address" }
  end

  factory :product do 
    name { "Product name" }
  end

  factory :order do
    customer
    product

    trait :paid do
      paid_at { Time.now - 1.day }
    end

    trait :shipped do
      shipped_at { Time.now - 1.hours }
    end

    trait :delivered do
      delivered_at { Time.now - 1.hours }
    end

    trait :recent do
      created_at { Time.now - 1.hour }
    end

    trait :old do
      created_at { Time.now - 1.week }
    end
  end
end