// changing container properties depending on screen size (cart single tracks display)
window.addEventListener('DOMContentLoaded', () => {
  const cartContainer = document.getElementById('cart-container');
  if (window.innerWidth < 992) {
    cartContainer.classList.remove('container');
    cartContainer.classList.add('container-fluid');
  }

  const desktopScreenSize = document.getElementById('cart-paginate-desktop');
  const mobileScreenSize = document.getElementById('cart-paginate-mobile');

  if (window.innerWidth < 600) {
    desktopScreenSize.classList.toggle('screen-display');
    mobileScreenSize.classList.toggle('screen-display');
  }
});

// Loading different shared file depending on screen size (Single Tracks index page)
window.addEventListener('DOMContentLoaded', () => {
  const desktopScreenSize = document.getElementById('paginate-desktop');
  const mobileScreenSize = document.getElementById('paginate-mobile');

  if (window.innerWidth < 600) {
    desktopScreenSize.classList.toggle('screen-display');
    mobileScreenSize.classList.toggle('screen-display');
  }
});