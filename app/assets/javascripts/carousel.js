// Rotates [data-carousel] tracks one slide at a time in an endless loop: the slides are followed by hidden
// copies, and once the track has moved onto a copy it jumps back to the matching original without animation.
// Pauses on hover, keyboard focus, hidden tab and the pause button; no autoplay with reduced motion.
// Without JS the track is still a swipeable, scroll-snapping row.
document.addEventListener("DOMContentLoaded", () => {
  const reduceMotion = matchMedia("(prefers-reduced-motion: reduce)").matches

  document.querySelectorAll("[data-carousel]").forEach((carousel) => {
    const track = carousel.querySelector("[data-carousel-track]")
    const slides = [...track.children]
    const toggle = carousel.querySelector("[data-carousel-toggle]")
    const interval = Number(carousel.dataset.interval)
    let playing = !reduceMotion
    let held = false
    let timer

    const count = slides.length
    slides.forEach((slide) => {
      const copy = slide.cloneNode(true)
      copy.setAttribute("aria-hidden", "true")
      copy.inert = true
      track.append(copy)
    })
    const all = [...track.children]

    const offset = (slide) => slide.offsetLeft - all[0].offsetLeft
    const current = () => all.findIndex((slide) => offset(slide) >= track.scrollLeft - 2)
    const jumpTo = (index) => track.scrollTo({ left: offset(all[index]), behavior: "instant" })
    const goTo = (index) => track.scrollTo({ left: offset(all[index]), behavior: reduceMotion ? "instant" : "smooth" })
    const next = () => {
      let index = current()
      if (index >= count) jumpTo(index -= count)
      goTo(index + 1)
    }
    const prev = () => {
      let index = current()
      if (index === 0) jumpTo(index = count)
      goTo(index - 1)
    }

    const schedule = () => {
      clearInterval(timer)
      if (playing && !held && !document.hidden) timer = setInterval(next, interval)
    }
    const setPlaying = (value) => {
      playing = value
      carousel.toggleAttribute("data-playing", playing)
      toggle.setAttribute("aria-label", playing ? "Pozastavit otáčení" : "Spustit otáčení")
      schedule()
    }
    const hold = (value) => () => { held = value; schedule() }

    carousel.querySelector("[data-carousel-next]").addEventListener("click", () => { next(); schedule() })
    carousel.querySelector("[data-carousel-prev]").addEventListener("click", () => { prev(); schedule() })
    toggle.addEventListener("click", () => setPlaying(!playing))
    carousel.addEventListener("mouseenter", hold(true))
    carousel.addEventListener("mouseleave", hold(false))
    carousel.addEventListener("focusin", hold(true))
    carousel.addEventListener("focusout", hold(false))
    track.addEventListener("pointerdown", schedule)
    document.addEventListener("visibilitychange", schedule)

    carousel.querySelector("[data-carousel-controls]").hidden = false
    setPlaying(playing)
  })
})
