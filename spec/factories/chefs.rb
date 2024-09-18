FactoryBot.define do
    factory :chef do
        association :user, factory: :user, ruolo: 'chef'
        telefono { 3456789012 }
        indirizzo { Faker::Address.full_address }
        raggio { Faker::Number.between(from: 5, to: 50) }
        descrizione { Faker::Restaurant.description }

        after(:build) do |chef|
            chef.user.ruolo = 'chef'
        end
    end
end
