import { Controller } from "@hotwired/stimulus";

// usiamo stimulus per iniettare codice js allo scopo di resettare la scrollbar all'apertura della chat
export default class extends Controller {
    // quando la pagina è caricata
    connect() {
        console.log("Connected to the room");
        const messages = document.getElementById("messages");
        messages.addEventListener("DOMNodeInserted", this.resetScroll);
        this.resetScroll(messages);
    }
    // quando si esce dalla pagina
    disconnect() {
        console.log("Disconnected to the room");
    }

    resetScroll() {
        messages.scrollTop = messages.scrollHeight - messages.clientHeight
    }
}