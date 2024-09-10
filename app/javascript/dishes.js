document.addEventListener('turbo:load', () => {
  const dishesContainer = document.getElementById('dishes');
  const addDishButton = document.getElementById('add-dish');
  const dishTemplate = document.getElementById('dish-template');

  if (!dishTemplate) {
    console.error('Template dish-template non trovato');
    return;
  }

  const dishTemplateContent = dishTemplate.content;

  // Funzione per aggiungere un nuovo modulo vuoto
  const addNewDishForm = () => {
    // Crea una copia del contenuto del template del piatto
    const newDish = document.importNode(dishTemplateContent, true);
    const newIndex = new Date().getTime();
    newDish.querySelectorAll('input, select, textarea').forEach((input) => {
      input.name = input.name.replace('new_dish', newIndex);
      input.id = input.id.replace('new_dish', newIndex);
    });
    // voglio stampare AAAAA nella console
    dishesContainer.appendChild(newDish);
  };

    // Aggiungi il primo modulo vuoto all'inizio
  if (dishesContainer.children.length === 0) {
    addNewDishForm();
  }
   

  addDishButton.addEventListener('click', (e) => {
    e.preventDefault();
    // Aggiungi un nuovo modulo vuoto per un altro piatto
    addNewDishForm();
  });

  dishesContainer.addEventListener('click', (e) => {
    if (e.target.classList.contains('remove-dish')) {
      e.preventDefault();
      const dishFields = e.target.closest('.dish-fields');
      dishFields.querySelector('input[name*="_destroy"]').value = '1';
      dishFields.style.display = 'none';
    }
  });
});