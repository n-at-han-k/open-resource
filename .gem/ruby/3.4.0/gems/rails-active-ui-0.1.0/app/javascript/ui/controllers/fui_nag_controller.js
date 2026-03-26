import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Nag — persistent dismissible notification bar.
// Bridges: $.fn.nag
//
// Usage:
//   <div class="ui nag" data-controller="fui-nag"
//        data-fui-nag-key-value="cookie-notice">
//     <span class="title">We use cookies.</span>
//     <i class="close icon"></i>
//   </div>
//
export default class extends Controller {
  static values = {
    key:           { type: String, default: "nag" },
    value:         { type: String, default: "dismiss" },
    storageMethod: { type: String, default: "localstorage" },
    expires:       { type: Number, default: 30 },
    displayTime:   { type: Number, default: 0 },
    persist:       { type: Boolean, default: false },
  }

  connect() {
    $(this.element).nag(this._options())
  }

  disconnect() {
    $(this.element).nag("destroy")
  }

  show()    { $(this.element).nag("show") }
  hide()    { $(this.element).nag("hide") }
  dismiss() { $(this.element).nag("dismiss") }
  clear()   { $(this.element).nag("clear") }

  // -- Private --

  _options() {
    return {
      key:           this.keyValue,
      value:         this.valueValue,
      storageMethod: this.storageMethodValue,
      expires:       this.expiresValue,
      displayTime:   this.displayTimeValue,
      persist:       this.persistValue,
      onShow:    () => { this.dispatch("show") },
      onVisible: () => { this.dispatch("visible") },
      onHide:    () => { this.dispatch("hide") },
      onHidden:  () => { this.dispatch("hidden") },
    }
  }
}
