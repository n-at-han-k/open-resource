import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Progress — progress bars with labels.
// Bridges: $.fn.progress
//
// Usage:
//   <div class="ui progress" data-controller="fui-progress"
//        data-percent="45">
//     <div class="bar">
//       <div class="progress"></div>
//     </div>
//   </div>
//
export default class extends Controller {
  static values = {
    percent:     { type: Number, default: 0 },
    total:       { type: Number, default: 0 },
    value:       { type: Number, default: 0 },
    autoSuccess: { type: Boolean, default: true },
    showActivity: { type: Boolean, default: true },
    label:       { type: String, default: "percent" },
    precision:   { type: Number, default: 0 },
  }

  connect() {
    $(this.element).progress(this._options())
  }

  disconnect() {
    $(this.element).progress("destroy")
  }

  setPercent(pct)  { $(this.element).progress("set percent", pct) }
  setValue(val)     { $(this.element).progress("set progress", val) }
  increment(amt)   { $(this.element).progress("increment", amt) }
  decrement(amt)   { $(this.element).progress("decrement", amt) }
  complete()       { $(this.element).progress("complete") }
  reset()          { $(this.element).progress("reset") }

  // -- Private --

  _options() {
    const opts = {
      autoSuccess:  this.autoSuccessValue,
      showActivity: this.showActivityValue,
      label:        this.labelValue,
      precision:    this.precisionValue,
      onChange: (percent, value, total) => {
        this.dispatch("change", { detail: { percent, value, total } })
      },
      onSuccess: (total) => { this.dispatch("success", { detail: { total } }) },
    }

    if (this.totalValue > 0) opts.total = this.totalValue
    if (this.valueValue > 0) opts.value = this.valueValue
    if (this.percentValue > 0) opts.percent = this.percentValue

    return opts
  }
}
