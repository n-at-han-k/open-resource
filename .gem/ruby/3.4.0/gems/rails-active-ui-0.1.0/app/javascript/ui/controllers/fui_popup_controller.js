import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Popup — tooltips and popup content.
// Bridges: $.fn.popup
//
// Usage:
//   <span data-controller="fui-popup"
//         data-fui-popup-content-value="Tooltip text"
//         data-fui-popup-position-value="top center">
//     Hover me
//   </span>
//
export default class extends Controller {
  static values = {
    content:   { type: String, default: "" },
    title:     { type: String, default: "" },
    html:      { type: String, default: "" },
    position:  { type: String, default: "top center" },
    on:        { type: String, default: "hover" },
    hoverable: { type: Boolean, default: false },
    closable:  { type: Boolean, default: true },
    variation: { type: String, default: "" },
  }

  connect() {
    $(this.element).popup(this._options())
  }

  disconnect() {
    $(this.element).popup("destroy")
  }

  show()   { $(this.element).popup("show") }
  hide()   { $(this.element).popup("hide") }
  toggle() { $(this.element).popup("toggle") }

  // -- Private --

  _options() {
    const opts = {
      position:  this.positionValue,
      on:        this.onValue,
      hoverable: this.hoverableValue,
      closable:  this.closableValue,
      variation: this.variationValue || false,
      onShow:    () => { this.dispatch("show") },
      onVisible: () => { this.dispatch("visible") },
      onHide:    () => { this.dispatch("hide") },
      onHidden:  () => { this.dispatch("hidden") },
    }

    if (this.contentValue) opts.content = this.contentValue
    if (this.titleValue)   opts.title = this.titleValue
    if (this.htmlValue)    opts.html = this.htmlValue

    return opts
  }
}
