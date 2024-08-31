document.addEventListener("DOMContentLoaded", function () {
  const contentTextArea = document.getElementById('note-content');
  const wordCountLabel = document.getElementById('word-count-label');

  // Initialize the word count to 0
  wordCountLabel.textContent = "(Number of words: 0)";

  contentTextArea.addEventListener('input', function () {
    const content = contentTextArea.value.trim();
    const wordCount = content.length > 0 ? content.split(/\s+/).length : 0;

    // Update the word count display
    wordCountLabel.textContent = `(Number of words: ${wordCount})`;

    // Change color to red if word count exceeds 50
    if (wordCount > 100) {
      wordCountLabel.style.color = 'red';
    } else {
      wordCountLabel.style.color = 'gray';
    }
  });
});
