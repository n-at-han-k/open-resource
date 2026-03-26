import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Form — client-side validation with inline error display.
// Bridges: $.fn.form
//
// Usage:
//   <form class="ui form" data-controller="fui-form"
//         data-fui-form-inline-value="true">
//     <div class="field">
//       <label>Email</label>
//       <input type="email" name="email">
//     </div>
//     <div class="ui error message"></div>
//   </form>
//
export default class extends Controller {
  static values = {
    inline:            { type: Boolean, default: false },
    on:                { type: String, default: "submit" },
    keyboardShortcuts: { type: Boolean, default: true },
    revalidate:        { type: Boolean, default: true },
    rules:             { type: String, default: "" },
  }

  connect() {
    const opts = this._options()

    if (this.rulesValue) {
      try { opts.fields = JSON.parse(this.rulesValue) }
      catch (e) { /* invalid JSON, skip */ }
    }

    $(this.element).form(opts)
  }

  disconnect() {
    $(this.element).form("destroy")
  }

  validate()  { return $(this.element).form("validate form") }
  reset()     { $(this.element).form("reset") }
  clear()     { $(this.element).form("clear") }
  isValid()   { return $(this.element).form("is valid") }
  getValues() { return $(this.element).form("get values") }

  // -- Private --

  _options() {
    return {
      inline:            this.inlineValue,
      on:                this.onValue,
      keyboardShortcuts: this.keyboardShortcutsValue,
      revalidate:        this.revalidateValue,
      onSuccess: () => {
        this.dispatch("success")
      },
      onFailure: (formErrors, fields) => {
        this.dispatch("failure", { detail: { errors: formErrors, fields } })
      },
    }
  }
}
