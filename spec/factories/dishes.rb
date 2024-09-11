FactoryBot.define do
  factory :dish do
    nome { Faker::Food.dish }
    tipo_portata { "Antipasto" }
    ingredienti {Faker::Food.ingredient}
    association :menu
  end
end
