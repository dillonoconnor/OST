window.addEventListener("turbo:load", () => {
  const hamburger = document.querySelector(".navbar-burger");
  const menu = document.querySelector(".navbar-menu");

  const expandMenu = () => {
    hamburger.classList.toggle("is-active")
    menu.classList.toggle("is-active");
  }
  hamburger.addEventListener("click", expandMenu);
});

