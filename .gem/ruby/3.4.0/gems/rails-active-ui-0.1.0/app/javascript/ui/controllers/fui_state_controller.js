import { Controller } from "@hotwired/stimulus"

// Fomantic-UI State — UI state management for elements.
// Bridges: $.fn.state
//
// Usage:
//   <button data-controller="fui-state"
//           data-fui-state-active-text-value="Following"
//           data-fui-state-inactive-text-value="Follow"
//           data-action="click->fui-state#toggle">
//     Follow
//   </button>
//
export default class extends Controller {
  static values = {
    activeText:     { type: String, default: "" },
    inactiveText:   { type: String, default: "" },
    activateText:   { type: String, default: "" },
    deactivateText: { type: String, default: "" },
    flashText:      { type: String, default: "" },
    flashDuration:  { type: Number, default: 1000 },
  }

  connect() {
    $(this.element).state(this._options())
  }

  disconnect() {
    $(this.element).state("destroy")
  }

  toggle()     { $(this.element).state("toggle") }
  activate()   { $(this.element).state("activate") }
  deactivate() { $(this.element).state("deactivate") }
  enable()     { $(this.element).state("enable") }
  disable()    { $(this.element).state("disable") }

  flash(text) {
    $(this.element).state("flash text", text || this.flashTextValue)
  }

  // -- Private --

  _options() {
    const opts = {}

    const text = {}
    if (this.activeTextValue)     text.active = this.activeTextValue
    if (this.inactiveTextValue)   text.inactive = this.inactiveTextValue
    if (this.activateTextValue)   text.activate = this.activateTextValue
    if (this.deactivateTextValue) text.deactivate = this.deactivateTextValue
    if (this.flashTextValue)      text.flash = this.flashTextValue
    if (Object.keys(text).length > 0) opts.text = text

    if (this.flashDurationValue !== 1000) opts.flashDuration = this.flashDurationValue

    opts.onChange = () => { this.dispatch("change") }
    opts.onActivate = () => { this.dispatch("activate") }
    opts.onDeactivate = () => { this.dispatch("deactivate") }

    return opts
  }
}
