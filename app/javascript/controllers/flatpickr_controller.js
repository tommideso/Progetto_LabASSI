import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Imposto la localizzazione in italiano
flatpickr.localize({
    weekdays: {
        shorthand: ["Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"],
        longhand: ["Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato"],
    },

    months: {
        shorthand: ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic"],
        longhand: [
            "Gennaio",
            "Febbraio",
            "Marzo",
            "Aprile",
            "Maggio",
            "Giugno",
            "Luglio",
            "Agosto",
            "Settembre",
            "Ottobre",
            "Novembre",
            "Dicembre",
        ],
    },
    firstDayOfWeek: 1,
    ordinal: () => "°",
    rangeSeparator: " al ",
    weekAbbreviation: "Se",
    scrollTitle: "Scrolla per aumentare",
    toggleTitle: "Clicca per cambiare",
    time_24hr: true,
});

export default class extends Controller {
    static values = { disabledDates: Array };
    connect() {
        console.log("Hello, Stimulus!", this.element);
        console.log(this.disabledDatesValue);
        flatpickr(".datepicker", {
            // locale: Italian,
            altInput: true,
            altFormat: "j F, Y",
            dateFormat: "Y-m-d",
            minDate: "today",
            disable: this.disabledDatesValue,
        });
    }
}
