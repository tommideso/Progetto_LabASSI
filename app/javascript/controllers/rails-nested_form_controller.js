import NestedForm from '@stimulus-components/rails-nested-form'

export default class extends NestedForm {
  connect() {
    super.connect()
    this.toggleRemoveButtons()
  }

  add(event) {
    super.add(event)
    this.toggleRemoveButtons()
  }

  remove(event) {
    super.remove(event)
    console.log('remove')
    this.toggleRemoveButtons()
  }

  toggleRemoveButtons() {
    // Cerco i form annidati visibili per contare quanti ce ne sono
    const dishes = this.element.querySelectorAll('.nested-form-wrapper:not([style*="display: none"])')
    const removeButtons = this.element.querySelectorAll('[data-action="nested-form#remove"]')
    console.log('dishes', dishes.length,"Remove", removeButtons.length)

    // Se ho un solo form annidato, nascondo il pulsante per rimuovere
    if (dishes.length === 1) {
      removeButtons.forEach(button => button.classList.add('hidden'))
    } else {
      removeButtons.forEach(button => button.classList.remove('hidden'))
    }
  }
}
