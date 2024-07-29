document.addEventListener('DOMContentLoaded', () => {
  const contentField = document.getElementById('note-content');
  const previewContent = document.getElementById('preview-content');

  contentField.addEventListener('input', () => {
    const content = contentField.value;

    fetch('/notes/preview', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ content: content })
    })
    .then(response => response.json())
    .then(data => {
      previewContent.innerHTML = data.preview;
    });
  });
});
