
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".cart-form").forEach(form => {
      form.addEventListener("submit", function (e) {
        e.preventDefault();
        
        let formData = new FormData(this);
        
        fetch(this.action, {
          method: "POST",
          body: formData,
          headers: {
            "X-Requested-With": "XMLHttpRequest"
          }
        })
        .then(response => response.text())
        .then(data => {
          alert("Item added to cart!");
        })
        .catch(error => console.log("Error:", error));
      });
    });
  });


  document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".featured__card").forEach(card => {
      card.addEventListener("mouseenter", () => {
        card.querySelector(".event-description").style.opacity = "1";
      });
  
      card.addEventListener("mouseleave", () => {
        card.querySelector(".event-description").style.opacity = "0";
      });
    });
  });
  
  
  document.addEventListener("DOMContentLoaded", function () {
    var modal = document.getElementById("userModal");
    var btn = document.getElementById("profileBtn");
    var closeBtn = document.querySelector(".close");
  
    // Open modal when clicking profile icon
    btn.onclick = function () {
      modal.style.display = "flex";
    };
  
    // Close modal when clicking 'X'
    closeBtn.onclick = function () {
      modal.style.display = "none";
    };
  
    // Close modal when clicking outside of modal content
    window.onclick = function (event) {
      if (event.target === modal) {
        modal.style.display = "none";
      }
    };
  });
  