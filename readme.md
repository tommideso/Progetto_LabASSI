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
    - Geolocalizzazione
    -   MyFitnessPal (o altro database) opzionale per vedere le calorie del cibo
                    
- Normalmente si pagano 10 euro di commissioni ad ogni menu. L'utente gold invece non paga nessuna commissione. Nella schermata di pagamento appare un avviso che consiglia all'utente di fare il pro per non pagare le commissioni

## Utenti
- Utente Gold/Pro : non paga le commissioni e vede menu specifici
-   Admin:
    -   Puo vedere tutte le recensione e cancellarle
    -   Eliminare menu
    -   Bloccare chef per verifiche se recensioni pessime ?!


## Pagine varie

Home uguale per tutti
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
1.	Creare il menu -> extra come misenplass…
2.	Visualizzare i miei menu
3.	Visualizzare prenotazioni (magari con un calendario)
4.	Singola prenotazione in cui vedere anche punteggio cliente
5.	Chat (aprire solo dalla prenotazione/appena arriva prenotazione si crea una chat)
6.	Pagina del profilo con possibilità di modificare i tuoi dati