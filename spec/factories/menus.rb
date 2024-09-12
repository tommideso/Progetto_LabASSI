FactoryBot.define do
    factory :menu do
      titolo { Faker::Food.dish }
      descrizione { Faker::Food.description }
      prezzo_persona { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
      min_persone { Faker::Number.between(from: 2, to: 10) }
      max_persone { Faker::Number.between(from: 11, to: 20) }
      tipo_cucina { Faker::Food.dish }
      allergeni {
        {
          "glutine" => Faker::Boolean.boolean,
          "soia" => Faker::Boolean.boolean,
          "noci" => Faker::Boolean.boolean,
          "lattosio" => Faker::Boolean.boolean,
          "crostacei" => Faker::Boolean.boolean,
          "arachidi" => Faker::Boolean.boolean
        }
      }
      preferenze_alimentari {
        {
          "vegano" => Faker::Boolean.boolean,
          "glutine" => Faker::Boolean.boolean
        }
      }
      adattabile {
        {
          "preferenze" => {
            "vegano" => Faker::Boolean.boolean,
            "glutine" => Faker::Boolean.boolean
          },
          "allergeni" => {
            "glutine" => Faker::Boolean.boolean,
            "soia" => Faker::Boolean.boolean,
            "noci" => Faker::Boolean.boolean,
            "lattosio" => Faker::Boolean.boolean,
            "crostacei" => Faker::Boolean.boolean,
            "arachidi" => Faker::Boolean.boolean
          }
        }
      }
      extra {
        {
          "miseenplace" => Faker::Boolean.boolean ? Faker::Number.decimal(l_digits: 2, r_digits: 2) : 0,
          "vino" => Faker::Boolean.boolean ? Faker::Number.decimal(l_digits: 2, r_digits: 2) : 0
        }
      }
      disattivato { Faker::Boolean.boolean }
      association :chef

      # Usa after(:build) per aggiungere i piatti prima della validazione
      after(:build) do |menu|
        menu.dishes << FactoryBot.build(:dish, menu: menu)
      end
  
      # mockato nei test
      stripe_price_id { Faker::Alphanumeric.alpha(number: 10) }
      stripe_product_id { Faker::Alphanumeric.alpha(number: 10) } 

    end
  end
  
  
   # titolo  "Menu 33"
        # menu.assign_attributes( 
        #     descrizione: Faker::Food.description, 
        #     prezzo_persona: Faker::Number.decimal(l_digits: 2, r_digits: 2), 
        #     min_persone: Faker::Number.between(from: 2, to: 10), 
        #     max_persone: Faker::Number.between(from: 11, to: 20), 
        #     tipo_cucina: Faker::Food.dish, 
        #     allergeni: {  
        #         "glutine" => Faker::Boolean.boolean,  
        #         "soia" => Faker::Boolean.boolean,  
        #         "noci" => Faker::Boolean.boolean,  
        #         "lattosio" => Faker::Boolean.boolean,  
        #         "crostacei" => Faker::Boolean.boolean,  
        #         "arachidi" => Faker::Boolean.boolean  
        #     }, 
        #     preferenze_alimentari: {  
        #         "vegano" => Faker::Boolean.boolean,  
        #         "glutine" => Faker::Boolean.boolean  
        #     }, 
        #     adattabile: { 
        #         "preferenze" => { 
        #             "vegano" => Faker::Boolean.boolean, 
        #             "glutine" => Faker::Boolean.boolean 
        #         }, 
        #         "allergeni" => { 
        #             "glutine" => Faker::Boolean.boolean, 
        #             "soia" => Faker::Boolean.boolean, 
        #             "noci" => Faker::Boolean.boolean, 
        #             "lattosio" => Faker::Boolean.boolean, 
        #             "crostacei" => Faker::Boolean.boolean, 
        #             "arachidi" => Faker::Boolean.boolean 
        #         } 
        #     }, 
        #     extra: {  
        #         "mise en place" => "true",  
        #         "vino" => Faker::Boolean.boolean  
        #     }, 
        #     prezzo_extra: Faker::Number.decimal(l_digits: 2, r_digits: 2), 
        #     disattivato: Faker::Boolean.boolean,
        #     chef: Chef.all.sample,
        # ) 
        # image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: ['food']) 
        # downloaded_image = URI.open(image_url) 
        # menu.images.attach(io: downloaded_image, filename: "menu_#{i + 1}.jpg") 
        
        # product = Stripe::Product.create({
        #     name: menu.titolo,
        #     active: true,
        #     description: menu.descrizione,
        #     metadata: {
        #         menu_id: menu.id,
        # }})
        # menu.stripe_product_id = product.id
    
        # price = Stripe::Price.create({
        #     product: menu.stripe_product_id,
        #     unit_amount: (menu.prezzo_persona * 100).to_i,
        #     currency: "eur"
        # })
        # menu.stripe_price_id = price.id
        # puts "Stripe product id: #{menu.stripe_product_id}"
        # puts "Stripe price id: #{menu.stripe_price_id}"