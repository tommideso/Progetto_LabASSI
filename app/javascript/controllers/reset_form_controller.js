import { Controller } from "@hotwired/stimulus";

// usiamo stimulus per iniettare codice js allo scopo di resettare il form di invio del messaggio nella chat
export default class extends Controller {
    reset() {
        this.element.reset();
        const chatText = this.element.querySelector('#chat-text');
        if (chatText) {
            chatText.style.height = "auto";
        }
    }
}