import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Dimmer — page/element overlay.
// Bridges: $.fn.dimmer
//
// Usage:
//   <div class="dimmable" data-controller="fui-dimmer">
//     <div class="ui dimmer">
//       <div class="content">Dimmed content</div>
//     </div>
//     <p>Page content</p>
//   </div>
//
export default class extends Controller {
  static values = {
    closable:   { type: Boolean, default: true },
    on:         { type: String, default: "" },
    transition: { type: String, default: "fade" },
  }

  connect() {
    $(this.element).dimmer(this._options())
  }

  disconnect() {
    $(this.element).dimmer("destroy")
  }

  show()   { $(this.element).dimmer("show") }
  hide()   { $(this.element).dimmer("hide") }
  toggle() { $(this.element).dimmer("toggle") }

  // -- Private --

  _options() {
    return {
      closable:   this.closableValue,
      on:         this.onValue || false,
      transition: this.transitionValue,
      onShow:   () => { this.dispatch("show") },
      onHide:   () => { this.dispatch("hide") },
      onChange: () => { this.dispatch("change") },
    }
  }
}
