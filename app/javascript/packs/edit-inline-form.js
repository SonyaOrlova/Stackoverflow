function onItemsListClick(itemsListClassName, itemClassName) {
  const itemsListEl = document.querySelector(`.${itemsListClassName}`);

  if (itemsListEl) {
    itemsListEl.addEventListener('click', (e) => {
      const clickElement = e.target;


      if (clickElement.classList.contains(`${itemClassName}__edit-link`)) {
        e.preventDefault();

        const answerElement = clickElement.closest(`.${itemClassName}`);

        if (clickElement.textContent === 'Cancel') {
          clickElement.textContent = 'Edit';

          answerElement.querySelector('.form_type_inline').classList.add('hidden');

          return;
        }

        clickElement.textContent = 'Cancel';

        answerElement.querySelector('.form_type_inline').classList.remove('hidden');
      }
    });
  }
}

document.addEventListener('turbolinks:load', () => {
  onItemsListClick('questions', 'question');
  onItemsListClick('answers', 'answer');
});
