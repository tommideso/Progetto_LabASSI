FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      nome { Faker::Name.first_name }
      cognome { Faker::Name.last_name }
      ruolo { [ 'chef', 'client' ].sample }
      password { "password" }
      confirmed_at { Time.now }
      completed { 2 }

      # Factory per l'admin
      factory :admin do
        email { "admin@admin.it" }  # Specifica l'email dell'admin
        nome { "Admin" }
        cognome { "Admin" }
        ruolo { "admin" }  # Ruolo impostato a 'admin'
        password { "admin@admin.it" }
        completed { 2 }  # Il valore completato specificato per l'admin
      end
    end
  end
