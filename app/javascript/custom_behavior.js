// app/assets/javascripts/custom_behavior.js

document.addEventListener('DOMContentLoaded', function() {
  const circles = document.querySelectorAll('.circle');

  circles.forEach(circle => {
    circle.addEventListener('mouseover', () => {
      circle.classList.add('wiggle');
    });

    circle.addEventListener('mouseout', () => {
      circle.classList.remove('wiggle');
    });
  });
});
