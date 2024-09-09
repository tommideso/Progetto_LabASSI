import Notification from "stimulus-notification";

// Connects to data-controller="notifications"
export default class extends Notification {
    connect() {
        super.connect();
        console.log("Do what you want here.");
    }
}
