import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Accordion — collapsible content panels.
// Bridges: $.fn.accordion
//
// Usage:
//   <div class="ui accordion" data-controller="fui-accordion">
//     <div class="title"><i class="dropdown icon"></i> Section</div>
//     <div class="content"><p>Panel content</p></div>
//   </div>
//
export default class extends Controller {
  static values = {
    exclusive:   { type: Boolean, default: true },
    collapsible: { type: Boolean, default: true },
    duration:    { type: Number, default: 350 },
  }

  connect() {
    $(this.element).accordion(this._options())
  }

  disconnect() {
    $(this.element).accordion("destroy")
  }

  open(index)  { $(this.element).accordion("open", index) }
  close(index) { $(this.element).accordion("close", index) }
  toggle(index){ $(this.element).accordion("toggle", index) }

  // -- Private --

  _options() {
    return {
      exclusive:   this.exclusiveValue,
      collapsible: this.collapsibleValue,
      duration:    this.durationValue,
      onOpening: () => { this.dispatch("opening") },
      onOpen:    () => { this.dispatch("open") },
      onClosing: () => { this.dispatch("closing") },
      onClose:   () => { this.dispatch("close") },
      onChange:   () => { this.dispatch("change") },
    }
  }
}
