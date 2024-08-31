require 'open-uri' 
 
30.times.with_index do |i| 
    menu = Menu.find_or_initialize_by(titolo: "Menu #{i}") 
    menu.update!( 
        descrizione: Faker::Food.description, 
        prezzo_persona: Faker::Number.decimal(l_digits: 2, r_digits: 2), 
        min_persone: Faker::Number.between(from: 2, to: 10), 
        max_persone: Faker::Number.between(from: 11, to: 20), 
        tipo_cucina: Faker::Food.dish, 
        allergeni: {  
            "glutine" => Faker::Boolean.boolean,  
            "soia" => Faker::Boolean.boolean,  
            "noci" => Faker::Boolean.boolean,  
            "lattosio" => Faker::Boolean.boolean,  
            "crostacei" => Faker::Boolean.boolean,  
            "arachidi" => Faker::Boolean.boolean  
        }, 
        preferenze_alimentari: {  
            "vegano" => Faker::Boolean.boolean,  
            "glutine" => Faker::Boolean.boolean  
        }, 
        adattabile: { 
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
        }, 
        extra: {  
            "mise en place" => "true",  
            "vino" => Faker::Boolean.boolean  
        }, 
        prezzo_extra: Faker::Number.decimal(l_digits: 2, r_digits: 2), 
        disattivato: Faker::Boolean.boolean 
    ) 
 
    # Download and attach the image 
    image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: ['food']) 
    downloaded_image = URI.open(image_url) 
    menu.images.attach(io: downloaded_image, filename: "menu_#{i + 1}.jpg") 
 
    menu.save! 
end



# menu1 = Menu.find_or_initialize_by(titolo: "Menu Vegano")
# menu1.update!(
#     descrizione: "Un menu adatto a chi segue una dieta vegana.",
#     prezzo_persona: 25.50,
#     min_persone: 2,
#     max_persone: 10,
#     tipo_cucina: "Vegano",
#     allergeni: { "glutine" => "false", "soia" => "true", "noci" => "true", "lattosio" => "false", "crostacei" => "true", "arachidi" => "false" },
#     preferenze_alimentari: { "vegano" => "true", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "true",
#             "glutine" => "false"
#         },
#         "allergeni" => {
#             "glutine" => "false", 
#             "soia" => "true", 
#             "noci" => "true", 
#             "lattosio" => "false", 
#             "crostacei" => "true", 
#             "arachidi" => "false"
#         }
#     },
#     extra: { "mise en place" => "false", "vino" => "true" },
#     prezzo_extra: 5,
#     disattivato: "false"
# )

# menu2 = Menu.find_or_initialize_by(titolo: "Menu Carnivoro")
# menu2.update!(
#     descrizione: "Un menu ricco di piatti a base di carne, ideale per gli amanti della carne.",
#     prezzo_persona: 30.00,
#     min_persone: 3,
#     max_persone: 12,
#     tipo_cucina: "Carnivoro",
#     allergeni: { "glutine" => "false", "soia" => "true", "noci" => "true", "lattosio" => "false", "crostacei" => "true", "arachidi" => "false" },
#     preferenze_alimentari: { "vegano" => "true", "glutine" => "false" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "true",
#             "glutine" => "false"
#         },
#         "allergeni" => {
#             "glutine" => "false", 
#             "soia" => "true", 
#             "noci" => "true", 
#             "lattosio" => "false", 
#             "crostacei" => "true", 
#             "arachidi" => "false"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 10,
#     disattivato: "false"
# )

# menu3 = Menu.find_or_initialize_by(titolo: "Menu Mediterraneo")
# menu3.update!(
#     descrizione: "Un menu ispirato alla cucina mediterranea, ricco di sapori freschi e ingredienti genuini.",
#     prezzo_persona: 28.00,
#     min_persone: 2,
#     max_persone: 8,
#     tipo_cucina: "Mediterraneo",
#     allergeni: { "glutine" => "true", "soia" => "false", "noci" => "true", "lattosio" => "true", "crostacei" => "true", "arachidi" => "false" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "false", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "true", 
#             "arachidi" => "false"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 7,
#     disattivato: "false"
# )

# menu4 = Menu.find_or_initialize_by(titolo: "Menu Vegetariano")
# menu4.update!(
#     descrizione: "Un menu perfetto per chi segue una dieta vegetariana, con piatti gustosi e nutrienti.",
#     prezzo_persona: 22.00,
#     min_persone: 2,
#     max_persone: 10,
#     tipo_cucina: "Vegetariano",
#     allergeni: { "glutine" => "true", "soia" => "true", "noci" => "true", "lattosio" => "true", "crostacei" => "false", "arachidi" => "false" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "true", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "false", 
#             "arachidi" => "false"
#         }
#     },
#     extra: { "mise en place" => "false", "vino" => "true" },
#     prezzo_extra: 4,
#     disattivato: "false"
# )

# menu5 = Menu.find_or_initialize_by(titolo: "Menu Pesce")
# menu5.update!(
#     descrizione: "Un menu dedicato agli amanti del pesce, con piatti freschi e saporiti.",
#     prezzo_persona: 35.00,
#     min_persone: 2,
#     max_persone: 8,
#     tipo_cucina: "Pesce",
#     allergeni: { "glutine" => "false", "soia" => "true", "noci" => "false", "lattosio" => "false", "crostacei" => "true", "arachidi" => "false" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "false", 
#             "soia" => "true", 
#             "noci" => "false", 
#             "lattosio" => "false", 
#             "crostacei" => "true", 
#             "arachidi" => "false"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 8,
#     disattivato: "false"
# )

# menu6 = Menu.find_or_initialize_by(titolo: "Menu Gourmet")
# menu6.update!(
#     descrizione: "Un menu raffinato per chi desidera un'esperienza culinaria di alto livello.",
#     prezzo_persona: 50.00,
#     min_persone: 2,
#     max_persone: 6,
#     tipo_cucina: "Gourmet",
#     allergeni: { "glutine" => "true", "soia" => "true", "noci" => "true", "lattosio" => "true", "crostacei" => "true", "arachidi" => "true" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "true", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "true", 
#             "arachidi" => "true"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 15,
#     disattivato: "false"
# )

# menu7 = Menu.find_or_initialize_by(titolo: "Menu Fusion")
# menu7.update!(
#     descrizione: "Un menu che combina sapori e tecniche culinarie da diverse parti del mondo.",
#     prezzo_persona: 40.00,
#     min_persone: 2,
#     max_persone: 10,
#     tipo_cucina: "Fusion",
#     allergeni: { "glutine" => "true", "soia" => "true", "noci" => "true", "lattosio" => "true", "crostacei" => "true", "arachidi" => "true" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "true", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "true", 
#             "arachidi" => "true"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 12,
#     disattivato: "false"
# )

# menu8 = Menu.find_or_initialize_by(titolo: "Menu Italiano")
# menu8.update!(
#     descrizione: "Un menu classico italiano con piatti tradizionali e sapori autentici.",
#     prezzo_persona: 32.00,
#     min_persone: 2,
#     max_persone: 12,
#     tipo_cucina: "Italiano",
#     allergeni: { "glutine" => "true", "soia" => "false", "noci" => "true", "lattosio" => "true", "crostacei" => "false", "arachidi" => "false" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "false", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "false", 
#             "arachidi" => "false"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 6,
#     disattivato: "false"
# )

# menu9 = Menu.find_or_initialize_by(titolo: "Menu Asiatico")
# menu9.update!(
#     descrizione: "Un menu che porta i sapori dell'Asia direttamente sulla tua tavola.",
#     prezzo_persona: 38.00,
#     min_persone: 2,
#     max_persone: 10,
#     tipo_cucina: "Asiatico",
#     allergeni: { "glutine" => "true", "soia" => "true", "noci" => "true", "lattosio" => "false", "crostacei" => "true", "arachidi" => "true" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "true", 
#             "noci" => "true", 
#             "lattosio" => "false", 
#             "crostacei" => "true", 
#             "arachidi" => "true"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 10,
#     disattivato: "false"
# )

# menu10 = Menu.find_or_initialize_by(titolo: "Menu Messicano")
# menu10.update!(
#     descrizione: "Un menu piccante e saporito, perfetto per chi ama la cucina messicana.",
#     prezzo_persona: 27.00,
#     min_persone: 2,
#     max_persone: 8,
#     tipo_cucina: "Messicano",
#     allergeni: { "glutine" => "true", "soia" => "false", "noci" => "true", "lattosio" => "true", "crostacei" => "false", "arachidi" => "true" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "false", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "false", 
#             "arachidi" => "true"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 5,
#     disattivato: "false"
# )

# menu11 = Menu.find_or_initialize_by(titolo: "Menu Francese")
# menu11.update!(
#     descrizione: "Un menu elegante e raffinato, ispirato alla cucina francese.",
#     prezzo_persona: 45.00,
#     min_persone: 2,
#     max_persone: 6,
#     tipo_cucina: "Francese",
#     allergeni: { "glutine" => "true", "soia" => "false", "noci" => "true", "lattosio" => "true", "crostacei" => "true", "arachidi" => "false" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "false", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "true", 
#             "arachidi" => "false"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 12,
#     disattivato: "false"
# )

# menu12 = Menu.find_or_initialize_by(titolo: "Menu Indiano")
# menu12.update!(
#     descrizione: "Un menu speziato e aromatico, che porta i sapori dell'India sulla tua tavola.",
#     prezzo_persona: 29.00,
#     min_persone: 2,
#     max_persone: 10,
#     tipo_cucina: "Indiano",
#     allergeni: { "glutine" => "true", "soia" => "true", "noci" => "true", "lattosio" => "true", "crostacei" => "false", "arachidi" => "true" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "true", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "false", 
#             "arachidi" => "true"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 7,
#     disattivato: "false"
# )

# menu13 = Menu.find_or_initialize_by(titolo: "Menu Americano")
# menu13.update!(
#     descrizione: "Un menu ricco e abbondante, ispirato alla cucina americana.",
#     prezzo_persona: 35.00,
#     min_persone: 2,
#     max_persone: 12,
#     tipo_cucina: "Americano",
#     allergeni: { "glutine" => "true", "soia" => "true", "noci" => "true", "lattosio" => "true", "crostacei" => "true", "arachidi" => "true" },
#     preferenze_alimentari: { "vegano" => "false", "glutine" => "true" },
#     adattabile: {
#         "preferenze" => {
#             "vegano" => "false",
#             "glutine" => "true"
#         },
#         "allergeni" => {
#             "glutine" => "true", 
#             "soia" => "true", 
#             "noci" => "true", 
#             "lattosio" => "true", 
#             "crostacei" => "true", 
#             "arachidi" => "true"
#         }
#     },
#     extra: { "mise en place" => "true", "vino" => "true" },
#     prezzo_extra: 9,
#     disattivato: "false"
# )