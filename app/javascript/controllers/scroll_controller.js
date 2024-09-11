import { Controller } from "@hotwired/stimulus";

// usiamo stimulus per iniettare codice js allo scopo di resettare la scrollbar all'apertura della chat
export default class extends Controller {
    // quando la pagina è caricata
    connect() {
        console.log("Connected to the room");
        this.messages = document.getElementById("messages");

        // Crea un'istanza di MutationObserver
        this.observer = new MutationObserver(this.resetScroll.bind(this));

        // Configura l'osservatore per osservare i cambiamenti nei figli del nodo
        const config = { childList: true };

        // Avvia l'osservazione del nodo target
        this.observer.observe(this.messages, config);

        this.resetScroll();
    }

    // quando si esce dalla pagina
    disconnect() {
        console.log("Disconnected from the room");

        // Disconnetti l'osservatore quando il controller viene disconnesso
        if (this.observer) {
            this.observer.disconnect();
        }
    }

    resetScroll() {
        console.log("Resetting scroll");
        this.messages.scrollTop = this.messages.scrollHeight - this.messages.clientHeight;
    }
}