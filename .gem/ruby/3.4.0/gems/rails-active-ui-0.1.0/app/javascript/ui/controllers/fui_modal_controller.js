import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Modal — dialog windows with dimmer.
// Bridges: $.fn.modal
//
// Usage:
//   <div class="ui modal" data-controller="fui-modal">
//     <i class="close icon"></i>
//     <div class="header">Modal Title</div>
//     <div class="content">Content here</div>
//     <div class="actions">
//       <button class="ui approve button">OK</button>
//       <button class="ui deny button">Cancel</button>
//     </div>
//   </div>
//
export default class extends Controller {
  static values = {
    closable:          { type: Boolean, default: true },
    dimmerSettings:    { type: Boolean, default: true },
    blurring:          { type: Boolean, default: false },
    keyboardShortcuts: { type: Boolean, default: true },
    duration:          { type: Number, default: 500 },
    transition:        { type: String, default: "scale" },
    autofocus:         { type: Boolean, default: true },
    allowMultiple:     { type: Boolean, default: false },
  }

  connect() {
    $(this.element).modal(this._options())
  }

  disconnect() {
    $(this.element).modal("destroy")
  }

  show()   { $(this.element).modal("show") }
  hide()   { $(this.element).modal("hide") }
  toggle() { $(this.element).modal("toggle") }
  refresh(){ $(this.element).modal("refresh") }

  // -- Private --

  _options() {
    return {
      closable:          this.closableValue,
      blurring:          this.blurringValue,
      keyboardShortcuts: this.keyboardShortcutsValue,
      duration:          this.durationValue,
      transition:        this.transitionValue,
      autofocus:         this.autofocusValue,
      allowMultiple:     this.allowMultipleValue,
      onShow:    () => { this.dispatch("show") },
      onVisible: () => { this.dispatch("visible") },
      onHide:    () => { this.dispatch("hide") },
      onHidden:  () => { this.dispatch("hidden") },
      onApprove: () => { this.dispatch("approve") },
      onDeny:    () => { this.dispatch("deny") },
    }
  }
}
