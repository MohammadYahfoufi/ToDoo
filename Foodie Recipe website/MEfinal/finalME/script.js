const toggleButton = document.getElementsByClassName('toggle-button')[0]
const navbarLinks = document.getElementsByClassName('navbar-links')[0]

toggleButton.addEventListener('click', () => {
    navbarLinks.classList.toggle('active')
})





// const bg = document.getElementById('clipped')
// document.addEventListener('mousemove',(e)=>{
//     bg.style.width = '$(e.clientX)px'
// })



// const shrinkTl = gsap.timeline({
//     scrollTrigger: {
//       trigger: "#shrink",
//       scrub: 1.5,
//       start: "top center",
//       end: "+=400",
//       ease: "power1.in"
//     }
//   });
  
//   shrinkTl.to("#shrink", {
//     duration: 2,
//     scale: 0.8,
//     filter: "blur(0px)"
//   });
//   shrinkTl.to("#shrink-quote", {
//     duration: 0.4,
//     delay: -0.7,
//     opacity: 1,
//     y: 0,
//     ease: "power2.out"
//   });
  
var loader = document.getElementsByClassName("preloader")
window.addEventListener("load", function(){
    loader.style.display="none";
})
document.onreadystatechange = function() {
if (document.readyState !== "complete") {
document.querySelector("body").style.visibility = "hidden";
document.querySelector(".preloader").style.visibility = "visible";
} else {
document.querySelector(".preloader").style.display = "none";
document.querySelector("body").style.visibility = "visible";
}
};

  function openLoginPopup() {
    document.getElementById("loginPopup").style.display = "block";
}

function closeLoginPopup() {
    document.getElementById("loginPopup").style.display = "none";
}

function openSignupPopup() {
    document.getElementById("signupPopup").style.display = "block";
}

function closeSignupPopup() {
    document.getElementById("signupPopup").style.display = "none";
}


var slideIndex = 1;
showSlides();

function showSlides() {
  var i;
  var slides = document.getElementsByClassName("fade-in");

  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";
  }

  if (slideIndex > slides.length) {
    slideIndex = 1;
  }

  if (slideIndex < 1) {
    slideIndex = slides.length;
  }

  slides[slideIndex - 1].style.display = "block";
}

function changeSlide(n) {
  slideIndex += n;
  showSlides();
}

setInterval(function() {
  changeSlide(1);
}, 4000);