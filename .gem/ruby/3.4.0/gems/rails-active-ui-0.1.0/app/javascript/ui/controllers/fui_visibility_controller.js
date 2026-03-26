import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Visibility — scroll-based visibility detection.
// Bridges: $.fn.visibility
//
// Usage:
//   <div data-controller="fui-visibility"
//        data-fui-visibility-once-value="true"
//        data-fui-visibility-type-value="image">
//     <img data-src="/images/photo.jpg">
//   </div>
//
export default class extends Controller {
  static values = {
    once:       { type: Boolean, default: true },
    continuous: { type: Boolean, default: false },
    offset:     { type: Number, default: 0 },
    type:       { type: String, default: "" },
    throttle:   { type: Number, default: 0 },
  }

  connect() {
    $(this.element).visibility(this._options())
  }

  disconnect() {
    $(this.element).visibility("destroy")
  }

  disable() { $(this.element).visibility("disable callbacks") }
  enable()  { $(this.element).visibility("enable callbacks") }
  refresh() { $(this.element).visibility("refresh") }

  // -- Private --

  _options() {
    const opts = {
      once:       this.onceValue,
      continuous: this.continuousValue,
      offset:     this.offsetValue,
      throttle:   this.throttleValue,
      onOnScreen:      () => { this.dispatch("onScreen") },
      onOffScreen:     () => { this.dispatch("offScreen") },
      onTopVisible:    () => { this.dispatch("topVisible") },
      onBottomVisible: () => { this.dispatch("bottomVisible") },
      onPassing:       () => { this.dispatch("passing") },
      onTopPassed:     () => { this.dispatch("topPassed") },
      onBottomPassed:  () => { this.dispatch("bottomPassed") },
    }

    if (this.typeValue) opts.type = this.typeValue

    return opts
  }
}
