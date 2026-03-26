import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Transition — CSS animation framework.
// Bridges: $.fn.transition
//
// Usage:
//   <div data-controller="fui-transition"
//        data-fui-transition-animation-value="fade"
//        data-fui-transition-duration-value="500">
//     Content to animate
//   </div>
//
export default class extends Controller {
  static values = {
    animation: { type: String, default: "fade" },
    duration:  { type: Number, default: 500 },
    queue:     { type: Boolean, default: true },
  }

  connect() {}
  disconnect() {}

  animate() {
    $(this.element).transition({
      animation: this.animationValue,
      duration:  this.durationValue,
      queue:     this.queueValue,
      onStart:    () => { this.dispatch("start") },
      onComplete: () => { this.dispatch("complete") },
    })
  }

  show() {
    $(this.element).transition({
      animation: this.animationValue + " in",
      duration:  this.durationValue,
      onComplete: () => { this.dispatch("show") },
    })
  }

  hide() {
    $(this.element).transition({
      animation: this.animationValue + " out",
      duration:  this.durationValue,
      onComplete: () => { this.dispatch("hide") },
    })
  }

  toggle() {
    $(this.element).transition({
      animation: this.animationValue,
      duration:  this.durationValue,
      onComplete: () => { this.dispatch("toggle") },
    })
  }

  stop() {
    $(this.element).transition("stop all")
  }
}
