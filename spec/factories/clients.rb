FactoryBot.define do
    factory :client do
      association :user, factory: :user, ruolo: 'client'
      telefono { 345677987 }
      indirizzo { Faker::Address.full_address }
      allergeni { { "glutine" => Faker::Boolean.boolean, "soia" => Faker::Boolean.boolean, "noci" => Faker::Boolean.boolean, "lattosio" => Faker::Boolean.boolean, "crostacei" => Faker::Boolean.boolean, "arachidi" => Faker::Boolean.boolean } }
      after(:build) do |client|
        client.user.ruolo = 'client'
      end
    end
  end
  