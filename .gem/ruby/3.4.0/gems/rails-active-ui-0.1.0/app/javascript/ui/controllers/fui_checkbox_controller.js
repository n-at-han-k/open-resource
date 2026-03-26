import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Checkbox — checkboxes, radios, toggles, sliders.
// Bridges: $.fn.checkbox
//
// Usage:
//   <div class="ui checkbox" data-controller="fui-checkbox">
//     <input type="checkbox">
//     <label>Accept terms</label>
//   </div>
//
export default class extends Controller {
  static values = {
    uncheckable:    { type: Boolean, default: true },
    fireOnInit:     { type: Boolean, default: false },
    enableEnterKey: { type: Boolean, default: true },
  }

  connect() {
    $(this.element).checkbox(this._options())
  }

  disconnect() {
    $(this.element).checkbox("destroy")
  }

  toggle()    { $(this.element).checkbox("toggle") }
  check()     { $(this.element).checkbox("check") }
  uncheck()   { $(this.element).checkbox("uncheck") }
  enable()    { $(this.element).checkbox("enable") }
  disable()   { $(this.element).checkbox("disable") }
  isChecked() { return $(this.element).checkbox("is checked") }

  // -- Private --

  _options() {
    return {
      uncheckable:    this.uncheckableValue,
      fireOnInit:     this.fireOnInitValue,
      enableEnterKey: this.enableEnterKeyValue,
      onChecked:   () => { this.dispatch("checked") },
      onUnchecked: () => { this.dispatch("unchecked") },
      onChange:     () => { this.dispatch("change") },
      onEnable:    () => { this.dispatch("enable") },
      onDisable:   () => { this.dispatch("disable") },
    }
  }
}
