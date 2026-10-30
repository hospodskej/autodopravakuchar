// Opens [data-lightbox] links in the #lightbox <dialog>. Close: button, Esc or backdrop click.
// Browse: arrow buttons, ←/→ keys or swipe. Without JS the links simply open the full-size photo.
document.addEventListener("DOMContentLoaded", () => {
  const dialog = document.getElementById("lightbox")
  if (!dialog) return

  const links = [...document.querySelectorAll("[data-lightbox]")]
  const image = dialog.querySelector(".lightbox__image")
  const caption = dialog.querySelector(".lightbox__caption")
  const counter = dialog.querySelector(".lightbox__counter")
  let index = 0
  let touchStartX = null

  const show = (i) => {
    index = (i + links.length) % links.length
    const link = links[index]
    image.src = link.href
    image.alt = caption.textContent = link.querySelector("img").alt
    counter.textContent = `${index + 1} / ${links.length}`
  }

  links.forEach((link, i) => link.addEventListener("click", (event) => {
    event.preventDefault()
    show(i)
    dialog.showModal()
  }))

  dialog.addEventListener("click", (event) => {
    const action = event.target.closest("[data-action]")?.dataset.action
    if (action === "prev") show(index - 1)
    else if (action === "next") show(index + 1)
    else if (action === "close" || event.target === dialog || event.target.classList.contains("lightbox__stage")) dialog.close()
  })

  dialog.addEventListener("keydown", (event) => {
    if (event.key === "ArrowLeft") show(index - 1)
    if (event.key === "ArrowRight") show(index + 1)
  })

  dialog.addEventListener("touchstart", (event) => { touchStartX = event.touches[0].clientX }, { passive: true })
  dialog.addEventListener("touchend", (event) => {
    const distance = event.changedTouches[0].clientX - touchStartX
    if (Math.abs(distance) > 50) show(index + (distance < 0 ? 1 : -1))
    touchStartX = null
  })

  dialog.addEventListener("close", () => links[index].focus())
})
