import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Slider — range slider control.
// Bridges: $.fn.slider
//
// Usage:
//   <div class="ui slider" data-controller="fui-slider"
//        data-fui-slider-min-value="0"
//        data-fui-slider-max-value="100"
//        data-fui-slider-step-value="1"
//        data-fui-slider-start-value="50">
//   </div>
//
export default class extends Controller {
  static values = {
    min:      { type: Number, default: 0 },
    max:      { type: Number, default: 100 },
    step:     { type: Number, default: 1 },
    start:    { type: Number, default: 0 },
    smooth:   { type: Boolean, default: false },
    vertical: { type: Boolean, default: false },
  }

  connect() {
    $(this.element).slider(this._options())
  }

  disconnect() {
    $(this.element).slider("destroy")
  }

  getValue()     { return $(this.element).slider("get value") }
  setValue(val)   { $(this.element).slider("set value", val) }

  // -- Private --

  _options() {
    return {
      min:      this.minValue,
      max:      this.maxValue,
      step:     this.stepValue,
      start:    this.startValue,
      smooth:   this.smoothValue,
      vertical: this.verticalValue,
      onChange: (value) => {
        this.dispatch("change", { detail: { value } })
      },
      onMove: (value) => {
        this.dispatch("move", { detail: { value } })
      },
    }
  }
}
