document.addEventListener('DOMContentLoaded', () => {
  const deleteButton = document.querySelector('#delete-button');

  if (deleteButton) {
    deleteButton.addEventListener('click', (e) => {
      e.preventDefault();
      if (window.confirm('削除しますか？')) {
        // OKがクリックされた場合、手動で遷移
        window.location.href = deleteButton.getAttribute('href');
      }
    });
  };
});
