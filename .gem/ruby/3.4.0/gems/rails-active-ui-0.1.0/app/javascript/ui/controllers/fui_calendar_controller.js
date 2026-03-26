import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Calendar — date/time picker popup.
// Bridges: $.fn.calendar
//
// Usage:
//   <div class="ui calendar" data-controller="fui-calendar"
//        data-fui-calendar-type-value="date">
//     <div class="ui input left icon">
//       <i class="calendar icon"></i>
//       <input type="text" placeholder="Date">
//     </div>
//   </div>
//
export default class extends Controller {
  static values = {
    type:         { type: String, default: "date" },
    closable:     { type: Boolean, default: true },
    monthFirst:   { type: Boolean, default: true },
    firstDayOfWeek: { type: Number, default: 0 },
    today:        { type: Boolean, default: false },
    formatInput:  { type: Boolean, default: true },
    minDate:      { type: String, default: "" },
    maxDate:      { type: String, default: "" },
  }

  connect() {
    $(this.element).calendar(this._options())
  }

  disconnect() {
    $(this.element).calendar("destroy")
  }

  show()   { $(this.element).calendar("popup", "show") }
  hide()   { $(this.element).calendar("popup", "hide") }
  toggle() { $(this.element).calendar("popup", "toggle") }
  clear()  { $(this.element).calendar("clear") }
  focus()  { $(this.element).calendar("focus") }

  getDate()    { return $(this.element).calendar("get date") }
  setDate(d)   { $(this.element).calendar("set date", d) }

  // -- Private --

  _options() {
    const opts = {
      type:           this.typeValue,
      closable:       this.closableValue,
      monthFirst:     this.monthFirstValue,
      firstDayOfWeek: this.firstDayOfWeekValue,
      today:          this.todayValue,
      formatInput:    this.formatInputValue,
      onChange: (date, text) => {
        this.dispatch("change", { detail: { date, text } })
      },
      onShow: () => { this.dispatch("show") },
      onHide: () => { this.dispatch("hide") },
    }

    if (this.minDateValue) opts.minDate = new Date(this.minDateValue)
    if (this.maxDateValue) opts.maxDate = new Date(this.maxDateValue)

    return opts
  }
}
