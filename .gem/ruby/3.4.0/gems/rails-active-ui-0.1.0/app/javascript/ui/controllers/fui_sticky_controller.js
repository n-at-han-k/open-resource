import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Sticky — stick elements to viewport on scroll.
// Bridges: $.fn.sticky
//
// Usage:
//   <div data-controller="fui-sticky"
//        data-fui-sticky-offset-value="14">
//     This content becomes sticky on scroll
//   </div>
//
export default class extends Controller {
  static values = {
    offset:       { type: Number, default: 0 },
    bottomOffset: { type: Number, default: 0 },
    pushing:      { type: Boolean, default: false },
    jitter:       { type: Number, default: 5 },
    context:      { type: String, default: "" },
  }

  connect() {
    $(this.element).sticky(this._options())
  }

  disconnect() {
    $(this.element).sticky("destroy")
  }

  refresh() { $(this.element).sticky("refresh") }
  reset()   { $(this.element).sticky("reset") }

  // -- Private --

  _options() {
    const opts = {
      offset:       this.offsetValue,
      bottomOffset: this.bottomOffsetValue,
      pushing:      this.pushingValue,
      jitter:       this.jitterValue,
      onStick:   () => { this.dispatch("stick") },
      onUnstick: () => { this.dispatch("unstick") },
      onTop:     () => { this.dispatch("top") },
      onBottom:  () => { this.dispatch("bottom") },
    }

    if (this.contextValue) opts.context = this.contextValue

    return opts
  }
}
