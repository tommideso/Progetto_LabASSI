FactoryBot.define do
  factory :dish do
    nome { "MyString" }
    tipo_portata { "MyString" }
    ingredienti { "MyText" }
    menu { nil }
  end
end
