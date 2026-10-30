// Mobile menu (<details data-mobile-nav>): closes on Esc, on a click outside it and after choosing a link.
document.addEventListener("DOMContentLoaded", () => {
  const menu = document.querySelector("[data-mobile-nav]")
  if (!menu) return

  const close = () => { menu.open = false }

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && menu.open) {
      close()
      menu.querySelector("summary").focus()
    }
  })
  document.addEventListener("click", (event) => {
    if (menu.open && !menu.contains(event.target)) close()
  })
  menu.querySelectorAll("a").forEach((link) => link.addEventListener("click", close))
})
