# Controllo degli accessi basato su modello RBAC
Questo documento descrive lo schema di controllo degli accessi basato sui ruoli (RBAC) implementato per il progetto. Lo schema definisce i ruoli, i permessi associati e le risorse a cui possono accedere gli utenti, garantendo un controllo granulare delle autorizzazioni.

| **Ruolo**  | **Descrizione**                |
|------------|--------------------------------|
| Admin      | Può disattivare i menù, gestire gli utenti, rimborsare le prenotazioni ed iniziare una conversazione con uno Chef. |
| Chef       | Può creare, modificare e cancellare menù. Può inoltre iniziare una conversazione con l'Admin. |
| Cliente    | Può prenotare un menù. Può inoltre confermare o disdire una prenotazione ed iniziare una conversazione con uno Chef o con l'Admin. |

| **Risorsa**      | **Descrizione**                         |
|------------------|-----------------------------------------|
| Chat             | Sistema di messaggistica con memoria della chat passata.    |
| Menù             | Sezione per la gestione dei menù.   |
| Prenotazioni     | Sezione per la gestione delle prenotazioni.     |
| Chef             | Gli utenti con ruolo Chef.   |

| **Permesso**    | **Descrizione**                          |
|-----------------|------------------------------------------|
| `create_menu`  | Permette di creare nuovi menù.       |
| `edit_menu`    | Permette di modificare menù esistenti.|
| `delete_menu`  | Permette di cancellare menù.         |
| `deactive_menu`| Permette di disattivare i menù.      | 
| `manage_users` | Permette di gestire gli utenti (ad esempio permette di bloccarli).   |
| `start_chat`   | Permette di iniziare una conversazione con uno Chef o con l'Admin.    |
| `make_and_manage_reservation` | Permette di prenotare un menù e di gestire la relativa prenotazione (confermare o disdire). |
| `refund_reservation` | Permette di rimborsare una prenotazione. |

| **Ruolo**  | **Permessi**                               |
|------------|--------------------------------------------|
| Admin      | `deactive_menu`, `manage_users`, `refund_reservation`, `start_chat` |
| Chef       | `create_menu`, `edit_menu`, `delete_menu`, `start_chat` |
| Client     | `make_and_manage_reservation`, `start_chat`  |

