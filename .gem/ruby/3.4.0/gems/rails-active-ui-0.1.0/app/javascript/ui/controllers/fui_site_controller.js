import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Site — base utility module.
// Bridges: $.site
//
// Usage:
//   <body data-controller="fui-site">
//
export default class extends Controller {
  static values = {
    debug: { type: Boolean, default: false },
  }

  connect() {
    $(this.element).site(this._options())
  }

  disconnect() {
    // $.site has no destroy method
  }

  // -- Private --

  _options() {
    return {
      debug: this.debugValue,
    }
  }
}
