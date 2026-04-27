(function () {
  const body = document.body;
  const buttons = document.querySelectorAll(".style-btn");
  const storageKey = "premium-style";

  function applyStyle(styleName) {
    body.classList.remove("premium-a", "premium-b");
    body.classList.add(styleName);

    buttons.forEach(function (button) {
      button.classList.toggle("is-active", button.dataset.style === styleName);
    });
  }

  const savedStyle = localStorage.getItem(storageKey);
  const initialStyle = savedStyle === "premium-b" ? "premium-b" : "premium-a";
  applyStyle(initialStyle);

  buttons.forEach(function (button) {
    button.addEventListener("click", function () {
      const nextStyle = button.dataset.style;
      applyStyle(nextStyle);
      localStorage.setItem(storageKey, nextStyle);
    });
  });
})();
