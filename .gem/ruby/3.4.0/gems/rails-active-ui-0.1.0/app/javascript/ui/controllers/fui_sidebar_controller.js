import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Sidebar — slide-out navigation panel.
// Bridges: $.fn.sidebar
//
// Usage:
//   <div class="ui sidebar" data-controller="fui-sidebar">
//     <a class="item">Menu Item 1</a>
//     <a class="item">Menu Item 2</a>
//   </div>
//   <div class="pusher">Main content</div>
//
export default class extends Controller {
  static values = {
    transition: { type: String, default: "overlay" },
    closable:   { type: Boolean, default: true },
    dimPage:    { type: Boolean, default: true },
    scrollLock: { type: Boolean, default: false },
  }

  connect() {
    $(this.element).sidebar(this._options())
  }

  disconnect() {
    $(this.element).sidebar("destroy")
  }

  show()   { $(this.element).sidebar("show") }
  hide()   { $(this.element).sidebar("hide") }
  toggle() { $(this.element).sidebar("toggle") }

  // -- Private --

  _options() {
    return {
      transition: this.transitionValue,
      closable:   this.closableValue,
      dimPage:    this.dimPageValue,
      scrollLock: this.scrollLockValue,
      onShow:    () => { this.dispatch("show") },
      onVisible: () => { this.dispatch("visible") },
      onHide:    () => { this.dispatch("hide") },
      onHidden:  () => { this.dispatch("hidden") },
      onChange:   () => { this.dispatch("change") },
    }
  }
}
