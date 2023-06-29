// LEAR MORE MODAL

window.addEventListener('DOMContentLoaded', () => {
  // Get the modal
  const modal = document.getElementById("learnMore");
  
  // Get the button that opens the modal
  const btns = document.querySelectorAll(".learnMoreBtn");
  
  // Get the <span> element that closes the modal
  const span = document.getElementsByClassName("learn-more-close")[0];
  
  // When the user clicks the button, open the modal
  btns.forEach(btn => {
    btn.onclick = function() {
      modal.style.display = "block";
    }
  })
  
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


// TRACK INFO MODAL

window.addEventListener('DOMContentLoaded', () => {
// document.addEventListener('turbolinks:load', () => {
  
  // Get the modal
  const modals = document.querySelectorAll("#trackInfo");
  // Get the content of the modal
  const modalsContent = document.querySelectorAll("#trackContentInfo")
  // Get the button that opens the modal
  const btn = document.querySelectorAll("#trackInfoBtn");
  
  // Get the <span> element that closes the modal
  const span = document.getElementsByClassName("track-info-close")[0];
  
  // When the user hovers over the info icon, open the modal
  btn.forEach(icon => {
    icon.onclick = function(event) {
      const modal = document.querySelector(`[data-modalTrackId="${icon.dataset.trackid}"]`)
      modal.style.display = "block";
      // var y = event.clientY;
      const modalContent = document.querySelector(`[data-modalTrackContentId="${icon.dataset.trackid}"]`)
      // margin = (y - 220)
      // modalContent.style.margin = `auto`;
      const close = document.querySelector(`[data-modalTrackCloseId="${icon.dataset.trackid}"]`)
      close.onclick = function() {
        modal.style.display = "none";
      }
      window.onclick = function(event) {
        if (event.target == modal) {
          modal.style.display = "none";
        }
      }
    }
  })

  // When the user moves the mouse out
  // btn.forEach(icon => {
  //   icon.onmouseout = function() {
  //     const modal = document.querySelector(`[data-modalTrackId="${icon.dataset.trackid}"]`)
  //     modal.style.display = "none";
  //   }
  // })
});


// COMING SOON MODAL --> Which became "Point value for collection"

// window.addEventListener('DOMContentLoaded', () => {
//   // document.addEventListener('turbolinks:load', () => {
    
//     // Get the modal
//     const modals = document.querySelectorAll("#comingSoon");
//     // Get the content of the modal
//     const modalsContent = document.querySelectorAll("#comingSoonContent")
//     // Get the button that opens the modal
//     const btn = document.querySelectorAll("#comingSoonBtn");
    
//     // Get the <span> element that closes the modal
//     const span = document.getElementsByClassName("track-info-close")[0];
    
//     // When the user hovers over the info icon, open the modal
//     btn.forEach(icon => {
//       icon.onmouseover = function(event) {
//         const modal = document.querySelector('#comingSoon')
//         modal.style.display = "block";
//         let y = event.clientY;
//         console.log(event.clientX)
//         const modalContent = document.querySelector('#comingSoonContent')
//         margin = (y - 220)
//         modalContent.style.marginTop = `${margin}px`;
//       }
//     })
  
//     // When the user moves the mouse out
//     btn.forEach(icon => {
//       icon.onmouseout = function() {
//         const modal = document.querySelector('#comingSoon')
//         modal.style.display = "none";
//       }
//     })
//   });