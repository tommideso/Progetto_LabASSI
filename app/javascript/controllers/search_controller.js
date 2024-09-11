import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ["modal", "form", "selectAllAllergeni", "allergeneCheckbox", "selectAllPreferenze", "preferenzaCheckbox"]

    toggleAll(event) {
        const target = event.target
        if (target.dataset.searchTarget === "selectAllAllergeni") {
          this.allergeneCheckboxTargets.forEach(checkbox => {
            checkbox.checked = target.checked
          })
        } else if (target.dataset.searchTarget === "selectAllPreferenze") {
          this.preferenzaCheckboxTargets.forEach(checkbox => {
            checkbox.checked = target.checked
          })
        }
      }

    connect() {
        this.clearForm();
        this.initializeDatepickers();
    }

    openModal(event) {
        event.preventDefault();
        if (this.hasModalTarget) {
            this.modalTarget.style.display = 'flex';
        } else {
            console.warn("Modal target is missing");
        }
    }

    closeModal(event) {
        event.preventDefault();
        console.log("Closing modal");
        this.resetModal();
        if (this.hasModalTarget) {
            this.modalTarget.style.display = 'none';
        } else {
            console.warn("Modal target is missing");
        }
    }

    submitForm(event) {
        console.log("Submitting form");
        this.resetModal();
        // Allow the form to submit normally
    }

    resetModal() {
        if (this.hasFormTarget) {
            console.log("Form target found:", this.formTarget);
            if (typeof this.formTarget.reset === 'function') {
                this.formTarget.reset();
                this.clearDatepickers();
            } else {
                console.warn("Form target reset is not a function");
            }
        } else {
            console.warn("Form target is missing");
        }
    }

    clearForm() {
        console.log("Clearing form on page load");
        if (this.hasFormTarget) {
            this.formTarget.reset();
            this.clearDatepickers();
        }
    }

    initializeDatepickers() {
        console.log("Initializing datepickers");

        // Si assicurara che l'inizializzazione avvenga solo una volta
        if (!this._initialized) {
            document.querySelectorAll(".datepicker").forEach((element) => {
                if (!element._flatpickr) {
                    flatpickr(element, {
                        onClose: () => {
                            console.log("Date picker closed");
                        }
                    });
                }
            });
            this._initialized = true; // Imposta il flag per prevenire la reinizializzazione
        }
    }

    clearDatepickers() {
        console.log("Clearing and destroying datepickers");
        document.querySelectorAll(".datepicker").forEach((element) => {
            if (element._flatpickr) {
                element._flatpickr.clear();
                element._flatpickr.destroy(); // Assicura che l'istanza di Flatpickr venga distrutta
                delete element._flatpickr; // Elimina il riferimento all'istanza
            }
        });
        this._initialized = false; // Resetta il flag per consentire una nuova inizializzazione se necessario
    }

    disconnect() {
        console.log("Search controller disconnected");
        this.cleanup();
    }

    cleanup() {
        console.log("Cleaning up event listeners and DOM elements");
        if (this.hasModalTarget) {
            this.modalTarget.style.display = 'none';
        }
        if (this.hasFormTarget) {
            this.formTarget.reset();
            this.clearDatepickers();
        }
    }
}
