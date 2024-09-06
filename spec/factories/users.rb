FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }          
      nome { Faker::Name.first_name }           
      cognome { Faker::Name.last_name }         
      ruolo { ['chef', 'client'].sample }      
      password { "password" }                   
      confirmed_at { Time.now }                 
      completed { 1 }                           
    end
  end
  
