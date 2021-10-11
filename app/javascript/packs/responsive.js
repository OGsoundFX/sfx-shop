window.addEventListener('DOMContentLoaded', () => {
  const cartContainer = document.getElementById('cart-container');
  if (window.innerWidth < 992) {
    cartContainer.classList.remove('container');
    cartContainer.classList.add('container-fluid');
  }
});
