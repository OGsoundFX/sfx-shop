window.addEventListener('DOMContentLoaded', () => {
  // Get the modal
  const modal = document.getElementById("learnMore");
  
  // Get the button that opens the modal
  const btn = document.getElementById("learnMoreBtn");
  
  // Get the <span> element that closes the modal
  const span = document.getElementsByClassName("learn-more-close")[0];
  
  // When the user clicks the button, open the modal 
  btn.onclick = function() {
    modal.style.display = "block";
  }
  
  // When the user clicks on <span> (x), close the modal
  span.onclick = function() {
    modal.style.display = "none";
  }
  
  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
});
