   document.addEventListener('DOMContentLoaded', function() {
    var quickViewBtns = document.getElementsByClassName('quick-view-btn');
    var closeBtns = document.getElementsByClassName('close-btn');
    var popups = document.getElementsByClassName('recipe-preview-popup');
  
    for (var i = 0; i < quickViewBtns.length; i++) {
      (function(i) {
        quickViewBtns[i].addEventListener('click', function() {
          popups[i].style.display = 'block';
        });
  
        closeBtns[i].addEventListener('click', function() {
          closePopup(popups[i]);
        });
  
        window.addEventListener('click', function(event) {
          if (event.target === popups[i]) {
            closePopup(popups[i]);
          }
        });
      })(i);
    }
  
    function closePopup(popup) {
      popup.classList.add('hide-popup');
      setTimeout(function() {
        popup.style.display = 'none';
        popup.classList.remove('hide-popup');
      }, 300);
    }
  });
  