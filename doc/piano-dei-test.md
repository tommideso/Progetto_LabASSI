Abbiamo realizzato i test con RSpec, un framework di testing per il linguaggio Ruby e utilizzato la gemma selenium web-driver per automatizzare i test di sistema sulle nostre funzionalità. Per creare gli oggetti necessari per i test abbiamo utilizzato la gemma factory_bot_rails.

Nella cartella spec é presente tutto ciò che riguarda i test, in particolare:
- **spec/factories**: contiene le factory per creare chef, clienti, menu necessari per i test.
- **spec/models**: contiene i test per i modelli  
      - spec/models/user_spec.rb: test per il modello User  
      - spec/models/menu_spec.rb: test per il modello Menu  
      - spec/models/reservation_spec.rb: test per il modello Reservation  

- **spec/controllers**: contiene i test per i controller  
        - spec/controllers/reservations_controller_spec.rb: test per il controller ReservationsController in particolare per il metodo create, verifica infatti che con parametri corretti viene creata una prenotazione correttamente. Invece, inserendo parametri errati non viene creata nessuna prenotazione.

- **spec/features**: contiene i test per due user stories che abbiamo implementato. 

        - spec/features/menu_spec.rb: test per la funzionalità di creazione di un menu.  

        Scenario1: "Chef crea un menu con successo", il flusso prevede che:  
            - Lo chef fa il login  
            - Va nella sua homepage   
            - Clicca su "Crea menu"  
            - Compila tutti i campi  
            - Clicca su "Crea menu"  
            - Viene reindirizzato alla pagina del menu appena creato 

            Il menu é satato cosi creato con successo e puó essere modificato:
            - Lo chef clicca su "Modifica"
            - Modifica il menu
            - Clicca su "Aggiorna modifiche"

        Scenario2: "Creazione menu fallisce perchè non tutti i campi sono stati compilati"
            - Lo chef fa il login
            - Va nella pagina del profilo 
            - Clicca su "Crea menu"
            - Compila solo alcuni campi
            - Clicca su "Crea menu"
            - Rimane nella stessa pagina e visualizza dei messaggi di errore

        - spec/features/reservation_spec.rb: test per la funzionalitá di creazione di una prenotazione.

        Scenario1: "Cliente prenota un menu con successo", il flusso prevede che:
            - Il cliente fa il login
            - Va nella pagina del menu
            - Compila tutti i campi della prenotazione
            - Clicca su "Prenota"
            - Viene reindirizzato alla pagina della prenotazione appena creata

        Scenario2: "Creazione prenotazione fallisce perchè non tutti i campi sono stati compilati"
            - Il cliente fa il login
            - Va nella pagina del menu
            - Compila solo alcuni campi della prenotazione
            - Clicca su "Prenota"
            - Rimane nella stessa pagina e visualizza un messaggio di errore
        
        Scenario3: "Utente non loggato non può prenotare un menu"
            - Utente non loggato va nella pagina del menu
            - Non visualizza il bottone "Prenota" e quindi non può prenotare il menu