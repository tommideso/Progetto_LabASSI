# AO CHEF

## Introduzione applicazione

Chef a domicilio quindi lo chef mette i propri menu online, raggio di distanza da casa sua, chat con lo chef e calendario disponibilità, foto varie.
Io persona cerco in base alla distanza e prezzo e tipo di cucina, scelgo il “piano” / menu tra quelli che lo chef mi propone, scelgo data e orario e PAGO

### Features varie

-   Allergeni e preferenze alimentari (vegano, vegetariano, senza glutine, ecc)
    -   Conferma prima di prenotare se ci sono allergie che potrebbero causare problemi
-   Aggiungere menu ai preferiti
-   Recensioni sia per chef che per utenti
-   Chat con chef (per chiedere info, allergie, ecc sia prima che dopo la prenotazione)
-   Possibilità di richiedere camerieri extra / degustazione vini / Mise en place
-   API:
    -   Stripe per i pagamenti
    -   OAuth con Google/Apple e vari
    -   API per la geolocalizzazione
    -   Database cibo per vedere le calorie e i valori nutrizionali del cibo
    - API per calendario ad esempio con collegamento con calendar
    - API per la chat??
                    
- Normalmente si pagano 10 euro di commissioni ad ogni menu. L'utente gold invece non paga nessuna commissione. Nella schermata di pagamento appare un avviso che consiglia all'utente di fare il pro per non pagare le commissioni

## Utenti
- Utente Gold/Pro : non paga le commissioni e vede menu specifici
-   Admin:
    -   Puo vedere tutte le recensione e cancellarle
    -   Eliminare menu
    -   Bloccare chef per verifiche se recensioni pessime ?!


## Pagine varie

Home uguale per tutti gli utenti non loggati  
Pagina del menu  
Visualizzare profilo chef

Cliente loggato:
1.	Conferma prenotazione (dove metti i tuoi dati) e pagamento
2.	Visualizzare le mie prenotazioni
3.	Pagina per visualizzare la singola prenotazione con possibilità di mettere recensione
4.	Chat (Dalla pagina dello chef e menu/appena arriva prenotazione si crea una chat)
5.	Preferiti
6.	Pagina del profilo con possibilità di modificare i tuoi dati

Chef loggato:
1.  Homepage chef (è la pagina principale in cui viene reindirizzato una volta loggato)
2.	Creare il menu -> extra come misenplass…
3.	Visualizzare i miei menu
4.	Visualizzare prenotazioni (magari con un calendario)
5.	Singola prenotazione in cui vedere anche punteggio cliente
6.	Chat (aprire solo dalla prenotazione/appena arriva prenotazione si crea una chat)
7.	Pagina del profilo con possibilità di modificare i tuoi dati


Pagine fatte:
1. Homepage quando non sei loggato o sei loggato come cliente.
2. Pagina del menu.
3. Homepage chef.
4. Pagina creazione del menu.
5. Profilo pubblico chef.
6. Completamento profilo cliente e chef.
7. Registrazione e login.
8. Pagina per modificare il profilo dello chef.
9. Pagina per modificare/visualizzare profilo del cliente e visualizzare le prenotazioni
10. Chat (uguali lato chef e lato client).
11. Pagina menu preferiti di un cliente .
12. Pagina relativa ad una singola prenotazione lato cliente. C'è inoltre la possibilità di lasciare una recensione.

Pagine da fare:
1. Pagina relativa ad una singola prenotazione lato chef. Può vedere gli utenti, ognuno con la media delle recensioni e può decidere di confermare o bloccare la prenotazione. Inoltre ha la possibilità dopo di lasciare una recensione.
2. Lista prenotazioni di uno chef.
3. Lista menu di uno chef.
4. Conferma prenotazione da parte di un cliente con pagamento.



# HOMEPAGE per utenti non registrati e clienti

## Search
bisogna compilare tutte le cose prima di fare la ricerca

mettere altre feature?? una per ogni campo? ad esempio il campo 'quando' deve dare la possibilità di selezionare anche pranzo/cena, etc.; il campo 'dove' deve dare la possibilità di usare la geolocalizzazione

mostrano i primi x risultati per l'infinite scroll / paginazione

## Profile popup for registered user
agli utenti registrati cliccando sull'iconcina in alto a destra compare un menu con profilo chat preferiti, prenotazioni e logout

## Register / login
invece agli utenti non registrati compare l'opzione di registrarsi e login

## Filter 
li chiamiamo 'filtri aggiuntivi'. fanno un fetch al database nel contesto della ricerca e mostrano i primi x risultati per l'infinite scroll / paginazione

due scenari: selezione del menu (tipi di menu) o filtri in alto a destra (valori nutrizionali, prezzo, etc.)


#  PAGINA DEL MENU 

1. Se l'utente non ha compilato gli compare il tasto 'controlla la disponibilità'.                 
Se l'utente ha compilato dipende:
2. Se l'utente è registrato gli compare 'prenota ora'
3. Se l'utente non è registrato e clicca 'prenota ora' appare un popup subito sopra il pulsante che gli dice di registrarsi/accedere per prenotare (con reindirizzazione alla pagina di registraizone/accesso)

# HOMEPAGE DELLO CHEF

Nell'header ci sta logo, un numero con stellina che rappresenta la 'media delle recensioni' e la foto del profilo; cliccandola si apre un menu con:
- Profilo (molto simile a quella del cliente)
- Prenotazioni
- Menu
- Chat
Nella schermata principale ci sono:
1. Alcuni menu, con accanto la scritta 'per vederli tutti o aggiungerli' che porta alla schermata menu
2. Le prenotazioni attive, con accanto la scritta 'per vedere tutte le prenotazioni' che porta alla schermata prenotazioni
3. Ultime recensioni (cioè le ultime recensioni prese da tutti i menu)  
Per vedere le recensioni bisogna andare nella schermata relativa del menu 

# CREAZIONE DEL MENU (dalla pagina dei menu dello chef)

1. Titolo del menu
2. Foto (plurale) con la possibilità di selezionare quella che viene mostrata come foto principale
3. Descrizione (opzionale ?) del menu e ACCANTO PREZZO E MIN. E MAX. PERSONE
4. Allergeni presenti nel menu tramite una checkbox
5. Due extra: Vino (degustazione ?) e mise en place; ogni opzione ha checkbox e costo (al momento del pagamento del client viene mostrato come extra e può essere anche non scelto) 
6. Meccanismo per aggiungere le portate. Per ogni portata:
    - Nome del piatto.
    - Select per selezionare se primo antipasto etc.
    - Opzionale ingredienti con peso  

Quando si aggiunge una portata compare in alto e se ne possono aggiungere altre. Quando si è finito e a patto che ci sia ALMENO 1 portata, si può aggiungere il menu con un pulsante in basso a destra.

Prima di confermare vengono mostrate tutte le portate, la descrizione, etc. insomma un'anteprima di quello che vedrà poi il client. Da qui se si conferma il menu viene pubblicato.

# PROFILO PUBBLICO DELLO CHEF (visibile da tutti)

1. Foto profilo e a destra descrizione del prof.
2. Valutazione totale sotto la foto e sempre sotto la foto pulsante per chattare
3. Carosello a scorrimento per vedere i diversi menu
4. In basso mappa con diametro di distanza entro cui lo chef lavora

# COMPLETAMENTO PROFILO 'CLIENTE'

Per ora sono stati inseriti solo email e password (è la pagina a cui si arriva dopo la conferma dell'email). In questa pagina bisogna inserire:

1. Nome e cognome con foto profilo opzionale
2. Indirizzo con API di google
3. Telefono
4. Allergeni

# COMPLETAMENTO PROFILO 'CHEF'

Solito discorso: sono stati inseriti solo email e password (è la pagina a cui si arriva dopo la conferma dell'email). In questa pagina bisogna inserire:

1. Nome e congome con foto profilo
2. Indirizzo di lavoro con API di google (mettiamo con slider il raggio)
3. Telefono
4. Descrizione di sé

# REGISTRAZIONE 

1. Email
2. Password
3. Registrazione con OAuth

# LOGIN 

1. Email
2. Password
3. Hai dimenticato la password?
4. Login con OAuth

# MODIFICARE/VISUALIZZARE PROFILO CLIENTE e VISUALIZZARE LISTA PRENOTAZIONI

Campi uguali alla pagina di completamento profilo cliente ma modificabile solo premendo "modifica profilo".
Lista delle prenotazioni (di default compaiono in ordine cronologico), quando una prenotazione diventa passata si colora di grigio.   
- Si possono filtrare per data, attive/passate, chef ...

# MODIFICARE PROFILO CHEF

Uguale alla pagina completamento profilo chef ma con campi già compilati e modificabili

# CHAT

 - Lo chef può parlare solo con i suoi clienti o con utenti che gli hanno scritto
 - Un cliente può parlare con qualsiasi chef anche prima di aver fatto la prenotazione

# PAGINA MENU PREFERITI DI UN CLIENTE

- Pagina con varie card per ogni menu (uguali a quelle nella homepage del cliente/ non loggati)

Incorporarlo direttamente nella pagina profilo?

# PAGINA SINGOLA PRENOTAZIONE LATO CLIENTE

1. Nome del menu (se ci clicchi ti riporta alla pagina di visualizzazione del menu)
2. Foto principale del menu
2. Quando (data e se pranzo, cena ...)
3. Nome e foto dello chef (se clicchi ti riporta alla pagina del profilo dello chef)
4. Numero di persone
5. Prezzo totale
6. Indirizzo "di consegna" con mappa
7. Extra
8. Form che compare solo dopo la data della prenotazione per lasciare una recensione scritta e numerica al menu e solo numerica per lo chef.

# PAGINA SINGOLA PRENOTAZIONE LATO CHEF

1. Nome del menu (se ci clicchi ti riporta alla pagina di visualizzazione del menu)
2. Foto principale del menu
2. Quando (data e se pranzo, cena ...)
3. Foto, nome e cognome, media recensioni cliente 
4. Numero di persone
5. Prezzo totale
6. Indirizzo "di consegna" con mappa
7. Extra
8. Numero di menu modificati per ogni allergene/preferenza alimentare
9. Form che compare solo dopo la data della prenotazione per lasciare una recensione numerica al cliente.   
... DA FINIRE




### Questione allergeni/ preferenze:
- Gli allergeni/preferenze dell'utente sono utilizzati come campi preferiti già selezionati nella ricerca ma possono essere tolti o modificati in base alle esigenze delle altre persone che mangiano.
- Il cliente al momento della ricerca può spuntare una checkbox per vedere tra i risultati:
    - Sia i menu che non contengono proprio quell'allergene o che già soddisfano le preferenze alimentari.
    - Sia i menu modificabili senza gli allergeni selezionati, o in modo da soddisfare le preferenze alimentari.
- Lo chef può spuntare una checkbox per dire se è disposto a fare modifiche al menu:
    - In quel caso può selezionare per quale allergene/preferenza può fare un menu diverso (tramite una select?).
    - Al cliente al momento della prenotazione apparirà oltre ai soliti campi un campo di testo dove inserisce quanti menu modificati fare per ogni preferenza/allergene. Il campo di testo deve essere compilato se nella ricerca hai inserito la possibilità dei menu modificati.

Così ha più senso che uno chef può accettare o meno una prenotazione.


