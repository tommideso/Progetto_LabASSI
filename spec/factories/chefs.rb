FactoryBot.define do
    factory :chef do
        association :user   
        telefono { 3456789012 }
        indirizzo { Faker::Address.full_address }
        raggio { Faker::Number.between(from: 5, to: 50) }
        descrizione { Faker::Restaurant.description }
        bloccato { Faker::Boolean.boolean }
    end
end




