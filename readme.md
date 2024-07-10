# AO CHEF

## Introduzione applicazione

Chef a domicilio quindi lo chef mette i propri menu online, raggio di distanza da casa sua, chat con lo chef e calendario disponibilità (per 'calendario disponibilità' si intendono SOLO le prenotazioni, cioè non vengono considerati gli impegni esterni dello chef), foto varie.
Io persona cerco in base alla distanza e prezzo e tipo di cucina, scelgo il “piano” / menu tra quelli che lo chef mi propone, scelgo data e orario e PAGO

## Features varie

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
    -   API per calendario ad esempio con collegamento con calendar (.ics): quando una prenotazione viene accettata chef e cliente ricevono un evento nel calendario
    -   API per la chat
    -   Per le email
-   Quando un cliente prenota per un pranzo/cena in un determinato giorno, il giorno scelto diventa automaticamente bloccato per altre prenotazioni e questo diventa visibile mediante un calendario che il cliente visiona in fase di prenotazione (nel calendario ci sono SOLO le altre prenotazioni, non rientrano gli impegni esterni dello chef)
-   Quando un cliente prenota un menu, lo chef ha tot tempo per rifiutare la prenotazione.
-   Le prenotazioni rifiutate vengono eliminate sia per il cliente che per lo chef. 

### Questione allergeni/ preferenze:

-   Gli allergeni/preferenze dell'utente sono utilizzati come campi preferiti già selezionati nella ricerca ma possono essere tolti o modificati in base alle esigenze delle altre persone che mangiano.
-   Il cliente al momento della ricerca può spuntare una checkbox per vedere tra i risultati:
    -   Sia i menu che non contengono proprio quell'allergene o che già soddisfano le preferenze alimentari.
    -   Sia i menu modificabili senza gli allergeni selezionati, o in modo da soddisfare le preferenze alimentari.
-   Lo chef può spuntare una checkbox per dire se è disposto a fare modifiche al menu:
    -   In quel caso può selezionare per quale allergene/preferenza può fare un menu diverso (tramite una select?).
    -   Al cliente al momento della prenotazione apparirà oltre ai soliti campi un campo di testo dove inserisce quanti menu modificati fare per ogni preferenza/allergene. Il campo di testo deve essere compilato se nella ricerca hai inserito la possibilità dei menu modificati.

Così ha più senso che uno chef può accettare o meno una prenotazione.

## Mockup fatti

1. Homepage quando non sei loggato o sei loggato come cliente.
2. Pagina del menu.
3. Homepage chef.
4. Pagina creazione del menu.
5. Profilo pubblico chef.
6. Completamento profilo cliente e chef.
7. Registrazione e login.
8. Pagina per modificare/visualizzare il profilo dello chef.
9. Pagina per modificare/visualizzare profilo del cliente e visualizzare le prenotazioni
10. Chat (uguali lato chef e lato client).
11. Pagina menu preferiti di un cliente .
12. Pagina relativa ad una singola prenotazione lato cliente. C'è inoltre la possibilità di lasciare una recensione.
13. Pagina visualizzazione singolo menu per lo chef
14. Lista prenotazioni di uno chef.
15. Pagina relativa ad una singola prenotazione lato chef. Può vedere gli utenti, ognuno con la media delle recensioni e può decidere di confermare o bloccare la prenotazione. Inoltre ha la possibilità dopo di lasciare una recensione.
16. Lista menu di uno chef.
17. Conferma prenotazione da parte di un cliente con pagamento.
18. Admin ??

# Utenti non loggati / Clienti: Pagine e funzionalità

## Search

-   Campo di ricerca (_default search bar_)con:
    -   Dove (con opzione per geolocalizzazione e indirizzo preferito)
    -   Quando (data e se pranzo/cena)
    -   Numero di persone
    -   Allergeni e preferenze alimentari
-   Pulsanti per filtrare (_filter_) per tipo di cucina (terra, mare, indiano, etc.)
-   Filtri aggiuntivi (_advanced filters_) (tipo di cucina, valori nutrizionali, prezzo, etc.)
-   Ordinamento per distanza, prezzo, valutazione, etc.

Vengono mostrati i primi _x_ risultati e tramite infinite scroll o paginazione si possono vedere gli altri.

## Pagina del singolo menu

-   Se l'utente non ha compilato gli compare il tasto 'controlla la disponibilità'.
-   Se l'utente ha compilato:
    -   Se l'utente è registrato gli compare 'prenota ora'
    -   Se l'utente non è registrato e clicca 'prenota ora' appare un popup che gli dice di registrarsi/accedere per prenotare (con reindirizzamento alla pagina di registrazione/accesso)
-   Il cliente può prenotare solo per un giorno compreso tra 1 e 14 giorni dalla data attuale

## Pagina profilo pubblico dello chef (visibile da tutti)

1. Foto profilo e a destra descrizione del prof.
2. Media voti allo chef (non ai menu) e pulsante per chattare -> sotto la foto
3. Carosello a scorrimento per vedere i diversi menu
4. In basso mappa con diametro di distanza entro cui lo chef lavora

# Chef: Pagine e funzionalità

## Header

Nell'header la media delle recensioni si riferisce alle recensioni _dello chef_ e non ai menu.

## Homepage

1. Alcuni menu, con accanto la scritta 'per vederli tutti o aggiungerli' che porta alla schermata menu
2. Le prenotazioni attive, con accanto la scritta 'per vedere tutte le prenotazioni' che porta alla schermata prenotazioni
3. Ultime recensioni (cioè le ultime recensioni prese da tutti i menu)  
   Per vedere le recensioni bisogna andare nella schermata relativa del menu (cliccando sulla recensione si va alla pagina del menu)

## Pagina creazione del menu

> Per arrivare a questa pagina c'è un pulsante nella pagina dei menu dello chef

1. Titolo del menu
2. Foto (plurale) con la possibilità di selezionare quella che viene mostrata come foto principale
3. Descrizione (opzionale) del menu e
4. Prezzo
5. Min e max persone
6. Tipo di cucina (terra, mare ...) se ne può selezionare più di 1.
7. Allergeni presenti nel menu tramite una checkbox
8. Due extra: Vino e mise en place  
   ogni opzione ha checkbox e costo (al momento del pagamento del client viene mostrato come extra e può essere anche non scelto)
9. Meccanismo per aggiungere le portate. Per ogni portata:
    - Nome del piatto.
    - Select per selezionare se primo antipasto etc.
    - Opzionale ingredienti con peso
10. Seleziona se vuole fare menu modificati e in caso affermativo seleziona per quale allergene/preferenza alimentare può fare un menu modificato.

Quando si aggiunge una portata compare in alto e se ne possono aggiungere altre. Quando si è finito e a patto che ci sia ALMENO 1 portata, si può aggiungere il menu con un pulsante in basso a destra.

Prima di confermare vengono mostrate tutte le portate, la descrizione, etc. insomma un'anteprima di quello che vedrà poi il client. Da qui se si conferma il menu viene pubblicato.

## Form di completamento profilo chef

Solito discorso: sono stati inseriti solo email e password (è la pagina a cui si arriva dopo la conferma dell'email). In questa pagina bisogna inserire:

1. Nome e congome con foto profilo
2. Indirizzo di lavoro con API di google (mettiamo con slider il raggio)
3. Telefono
4. Descrizione di sé

## Pagina visualizzazione/modifica profilo chef

Campi uguali alla pagina di completamento profilo chef ma modificabile premendo "modifica profilo".
Da qui può vedere anche la media di tutte le sue recensioni numeriche lasciate dai clienti (non le recensioni ai menu)
-  Lo chef può modificare tutti i campi tranne le portate

## Pagina singola prenotazione (lato chef)

> Un codice legato alla prenotazione (non l'ID vero e proprio) breve così da essere facilmente individuabile dall'admin

1. Nome del menu (se ci clicchi ti riporta alla pagina di visualizzazione del menu)
2. Foto principale del menu
3. Quando (data e se pranzo, cena ...)
4. Foto, nome e cognome, media recensioni cliente
5. Link alla chat con lo chef
6. Numero di persone
7. Prezzo totale
8. Indirizzo "di consegna" con mappa
9. Extra
10. Numero di menu modificati per ogni allergene/preferenza alimentare
11. Form che compare solo dopo la data della prenotazione per lasciare una recensione numerica al cliente.
12. Visualizza recensione lasciata dal cliente
13. Possibilità di rifiutare/cancellare la prenotazione

## Pagina visualizzazione/modifica menu (lato chef)

-   Pulsante per disattivare il menu
-   Possibilità di vedere le ultime prenotazioni per quel menu
-   Bottone modifica menu sempre cliccabile (le modifiche che può fare sono tutti i campi tranne le portate)
-   Uno chef può solo rimuovere allergeni (lo chef si è scordato di scrivere che il menu è senza glutine)
-   Il prezzo può essere modificato ma per gli utenti che hanno già fatto la prenotazione nella pagina della prenotazione rimane quello che hanno pagato al momento della prenotazione

## Pagina con tutte le prenotazioni (lato chef)

Lista di prenotazioni in ordine cronologico. Si possono filtrare per data, attive/passate, cliente ...  
Una prenotazione ha tre possibili stati:

1.  Da confermare --> giallo
2.  Confermata --> verde
3.  Passata --> grigio

Di ogni prenotazione lo chef può vedere:

-   Nome del menu
-   Data e se pranzo o cena
-   Nome e cognome del cliente
-   Numero di persone
-   Bottone per rifiutarla

# Clienti: Pagine e funzionalità

## Form di completamento profilo cliente

Per ora sono stati inseriti solo email e password (è la pagina a cui si arriva dopo la conferma dell'email). In questa pagina bisogna inserire:

1. Nome e cognome con foto profilo opzionale
2. Indirizzo con API di google
3. Telefono
4. Allergeni

## Pagina visualizzazione/mofica profilo cliente

-   Campi uguali alla pagina di completamento profilo cliente ma modificabile solo premendo "modifica profilo".
-   Prenotazioni in ordine cronologico: vengono mostrate solo _x_ prenotazioni e si può vedere il resto tramite infinite scroll o paginazione.
    Si possono filtrare per data, attive/passate, chef ...

    -   Una prenotazione ha quattro possibili stati:
        1.  In attesa di conferma --> giallo
        2.  Rifiutata --> rosso
        3.  Confermata --> verde
        4.  Passata --> grigio

## Pagina menu preferiti di un cliente

> Per aggiungere/rimuovere un menu ai preferiti c'è un pulsante nella pagina del menu
> Pagina con varie card per ogni menu (uguali a quelle nella homepage del cliente/ non loggati).

## Pagina singola prenotazione (lato cliente)

> Un codice legato alla prenotazione (non l'ID vero e proprio) breve così da essere facilmente individuabile dall'admin

1. Nome del menu (se ci clicchi ti riporta alla pagina di visualizzazione del menu)
2. Foto principale del menu
3. Quando (data e se pranzo, cena ...)
4. Nome e foto dello chef (se clicchi ti riporta alla pagina del profilo dello chef)
5. Link alla chat con lo chef
6. Numero di persone
7. Prezzo totale
8. Indirizzo "di consegna" con mappa
9. Extra
10. Form che compare solo dopo la data della prenotazione per lasciare una recensione scritta e numerica al menu e solo numerica per lo chef.
11. Visualizzare recensione lasciata dallo chef


# Admin (o servizio clienti)

## Funzioni principali

1. Gestire e rimborsare le prenotazioni "problematiche". Il workflow è il seguente: l'utente contatta in chat l'admin, l'admin clicca sul nome utente e attraverso il profilo dell'utente accede alla prenotazione "problematica". Qui può rimborsare la prenotazione.
2. Bloccare temporaneamente uno chef per verifiche se riceve molte recensioni pessime.
3. Disattivare temporaneamente il menu di un chef.
4. L'admin può bannare l'utente ed in caso gestire opportunamente la cosa:
    - il suo account e tutte le sue recensioni vengono eliminate

## Pagine e funzionalità

-   L'admin ha un homepage con tutti gli chef, che possono essere filtrati in funzione della media delle recensioni
-   L'admin vede attraverso l'homepage una "notifica" sulle chat aperte da parte degli utenti e degli chef
-   Cliccando su uno chef, compare la solita pagina ma con funzionalità aggiuntive:
    1. Sulla pagina stessa dello chef, può vedere tutte le prenotazioni
    2. Sulla pagina stessa dello chef, ha la possibilità di bloccare lo chef
    3. Cliccando su una prenotazione, l'admin ha la possibilità rimborsare totalmente il cliente in caso di problemi (ad es. se la prenotazione è stata rifiutata dallo chef oltre il tempo limite, oppure i clienti hanno avuto problemi con il cibo, etc.)
    4. Cliccando su un menu, l'admin ha la possibilità di disattivarlo (ad esempio puoi chiedere allo chef di cambiare alcune cose e fino a quel momento lo tiene disattivato). Il menu disattivato dall'admin non può essere disattivato dallo chef (quindi è un altro stato rispetto al menu disattivato dallo chef)
-   Inoltre cliccando su un cliente, l'admin può vedere tutte le sue prenotazioni
-   Nell'homepage dell'admin oltre agli chef compare un tab con gli utenti (come nel caso degli chef, possono essere filtrati e ordinati in base alla media delle recensioni)

# Chat

-   Lo chef può parlare solo con i suoi clienti o con utenti che gli hanno scritto
-   Un cliente può parlare con qualsiasi chef anche prima di aver fatto la prenotazione
-   Chat con admin (o servizio clienti) sempre disponibile tramite un pulsante nel footer
-   Admin può parlare con tutti

# Header:

-   Cliente: Tramite una icona può accedere alle sue chat
-   Chef: Tramite una icona può accedere alle sue chat

# Footer:

-   FAQ
-   Chat con assistenza clienti
-   Logo

# DA DEFINIRE

3. Utente gold?
    - Normalmente si pagano 10 euro di commissioni ad ogni menu. L'utente gold invece non paga nessuna commissione. Nella schermata di pagamento appare un avviso che consiglia all'utente di fare il pro per non pagare le commissioni


