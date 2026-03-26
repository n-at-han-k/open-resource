import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Shape — 3D CSS shape transformations.
// Bridges: $.fn.shape
//
// Usage:
//   <div class="ui shape" data-controller="fui-shape">
//     <div class="sides">
//       <div class="side active">Side 1</div>
//       <div class="side">Side 2</div>
//     </div>
//   </div>
//
export default class extends Controller {
  static values = {
    duration:     { type: Number, default: 700 },
    allowRepeats: { type: Boolean, default: false },
  }

  connect() {
    $(this.element).shape(this._options())
  }

  disconnect() {
    $(this.element).shape("destroy")
  }

  flipUp()    { $(this.element).shape("flip up") }
  flipDown()  { $(this.element).shape("flip down") }
  flipLeft()  { $(this.element).shape("flip left") }
  flipRight() { $(this.element).shape("flip right") }
  flipOver()  { $(this.element).shape("flip over") }
  flipBack()  { $(this.element).shape("flip back") }

  // -- Private --

  _options() {
    return {
      duration:     this.durationValue,
      allowRepeats: this.allowRepeatsValue,
      onBeforeChange: () => { this.dispatch("beforeChange") },
      onChange:        () => { this.dispatch("change") },
    }
  }
}
