import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Flyout — slide-out panel from screen edge.
// Bridges: $.fn.flyout
//
// Usage:
//   <div class="ui right flyout" data-controller="fui-flyout">
//     <i class="close icon"></i>
//     <div class="header">Title</div>
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
    dimPage:           { type: Boolean, default: true },
    keyboardShortcuts: { type: Boolean, default: true },
  }

  connect() {
    $(this.element).flyout(this._options())
  }

  disconnect() {
    $(this.element).flyout("destroy")
  }

  show()   { $(this.element).flyout("show") }
  hide()   { $(this.element).flyout("hide") }
  toggle() { $(this.element).flyout("toggle") }

  // -- Private --

  _options() {
    return {
      closable:          this.closableValue,
      dimPage:           this.dimPageValue,
      keyboardShortcuts: this.keyboardShortcutsValue,
      onShow:    () => { this.dispatch("show") },
      onHide:    () => { this.dispatch("hide") },
      onApprove: () => { this.dispatch("approve") },
      onDeny:    () => { this.dispatch("deny") },
    }
  }
}
