FactoryBot.define do
    factory :client do
      association :user
      telefono { 345677987 }
      indirizzo { Faker::Address.full_address }
      allergeni { { "glutine" => Faker::Boolean.boolean, "soia" => Faker::Boolean.boolean, "noci" => Faker::Boolean.boolean, "lattosio" => Faker::Boolean.boolean, "crostacei" => Faker::Boolean.boolean, "arachidi" => Faker::Boolean.boolean } }
    end
  end
  