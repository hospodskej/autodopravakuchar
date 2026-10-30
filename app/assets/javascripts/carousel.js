// Rotates [data-carousel] tracks one slide at a time, looping back to the start.
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

    const offset = (slide) => slide.offsetLeft - slides[0].offsetLeft
    const current = () => slides.findIndex((slide) => offset(slide) >= track.scrollLeft - 2)
    const atEnd = () => track.scrollLeft + track.clientWidth >= track.scrollWidth - 2
    const goTo = (index) => track.scrollTo({ left: offset(slides[index]), behavior: reduceMotion ? "auto" : "smooth" })
    const next = () => goTo(atEnd() ? 0 : current() + 1)
    const prev = () => goTo(current() === 0 ? slides.length - 1 : current() - 1)

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
