1. Gli utenti sono o clienti o chef o admin (_un utente appartiene per forza ad uno di questi_). Di ogni nome utente interessa l'id (chiave), email (chiave), nome, cognome, password.
    * Di ogni cliente interessano l'indirizzo, il telefono, gli allergeni e la foto profilo.   
    * Di ogni chef interessano l'indirizzo, il telefono, il raggio entro cui offre i propri menù, la foto profilo, la descrizione e se è stato bloccato da un admin.
2. **Gli chef possono offrire menù**. Ogni menù è relativo ad un solo chef ed uno chef può offrire 0 o più menù. Di ogni menù interessano l'id (chiave), il nome, descrizione, prezzo/persona, allergeni, min. persone, max. persone, il tipo della cucina, se si può adottare agli allergeni e/o preferenze alimentari, gli extra, le preferenze alimentari e se è disattivato o meno.
    * **Ogni menu contiene uno o più patti**. Di ogni piatto interessano il nome, il tipo della portata (antipasto, pranzo o cena) e, opzionali, gli ingredienti.
3. **I clienti possono effettuare prenotazioni**. Di ogni prenotazione interessa l'id (chiave), il numero (chiave), data, il menù scelto, **lo chef che offre tale menù**, lo stato, il numero delle persone, gli extra scelti, le modifiche richieste e l'indirizzo di consegna.
    * Una prenotazione può essere: in attesa di essere confermata, rifiutata (lo chef può rifiutarla entro 24 ore) e confermata (passate le prime 24 ore). 
    * Un cliente non può effettuare più di una prenotazione al giorno.
    * **In relazione ad una prenotazione** i clienti possono lasciare una recensione numerica e testuale allo chef, una recensione testuale al menù e gli chef possono lasciare una recensione numerica ai clienti.
    * **Un admin può rimborsare una prenotazione.**
    * Di ogni prenotazione bisogna salvare i dati del pagamento.
4. I menu possono essere modificati dallo chef. Un menù può essere modificato solo una volta al giorno. La prenotazione deve essere relativa **all'ultimo** menù salvato.
    * Il menù salvato ha gli stessi attributi del menù oltre ad un attributo 'idOriginale' che rimanda al menù originale.
