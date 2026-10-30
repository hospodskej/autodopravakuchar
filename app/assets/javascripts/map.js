// Loads the Google Maps iframe only after the visitor asks for it, so no Google cookies are set before consent.
document.addEventListener("click", (event) => {
  const button = event.target.closest("[data-map-load]")
  if (!button) return

  const map = button.closest(".map")
  const iframe = document.createElement("iframe")
  iframe.src = map.dataset.src
  iframe.title = map.dataset.title
  iframe.referrerPolicy = "no-referrer-when-downgrade"
  map.append(iframe)
  map.classList.add("is-loaded")
})
