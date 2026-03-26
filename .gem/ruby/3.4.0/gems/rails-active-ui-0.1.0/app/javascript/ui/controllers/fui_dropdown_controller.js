import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Dropdown — selection dropdowns with search support.
// Bridges: $.fn.dropdown
//
// Usage:
//   <div class="ui selection dropdown" data-controller="fui-dropdown">
//     <input type="hidden" name="field">
//     <div class="default text">Select...</div>
//     <i class="dropdown icon"></i>
//     <div class="menu">
//       <div class="item" data-value="1">Option 1</div>
//       <div class="item" data-value="2">Option 2</div>
//     </div>
//   </div>
//
export default class extends Controller {
  static values = {
    clearable:      { type: Boolean, default: false },
    placeholder:    { type: String, default: "" },
    forceSelection: { type: Boolean, default: false },
    fullTextSearch:  { type: Boolean, default: false },
    duration:       { type: Number, default: 200 },
    allowAdditions: { type: Boolean, default: false },
  }

  connect() {
    $(this.element).dropdown(this._options())
  }

  disconnect() {
    $(this.element).dropdown("destroy")
  }

  show()   { $(this.element).dropdown("show") }
  hide()   { $(this.element).dropdown("hide") }
  toggle() { $(this.element).dropdown("toggle") }
  clear()  { $(this.element).dropdown("clear") }
  refresh(){ $(this.element).dropdown("refresh") }

  getValue()    { return $(this.element).dropdown("get value") }
  getText()     { return $(this.element).dropdown("get text") }
  setValue(val) { $(this.element).dropdown("set selected", val) }

  // -- Private --

  _options() {
    return {
      clearable:      this.clearableValue,
      placeholder:    this.placeholderValue || false,
      forceSelection: this.forceSelectionValue,
      fullTextSearch:  this.fullTextSearchValue,
      duration:       this.durationValue,
      allowAdditions: this.allowAdditionsValue,
      onChange: (value, text, $choice) => {
        this.dispatch("change", { detail: { value, text } })
      },
      onShow:   () => { this.dispatch("show") },
      onHide:   () => { this.dispatch("hide") },
      onAdd:    (addedValue, addedText, $addedChoice) => {
        this.dispatch("add", { detail: { value: addedValue, text: addedText } })
      },
      onRemove: (removedValue, removedText, $removedChoice) => {
        this.dispatch("remove", { detail: { value: removedValue, text: removedText } })
      },
    }
  }
}
