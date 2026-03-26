import { Controller } from "@hotwired/stimulus"

// Fomantic-UI API — AJAX request management with state toggling.
// Bridges: $.fn.api
//
// Usage:
//   <button data-controller="fui-api"
//           data-fui-api-url-value="/api/items"
//           data-fui-api-method-value="get"
//           data-action="click->fui-api#query">
//     Load Items
//   </button>
//
export default class extends Controller {
  static values = {
    url:             { type: String, default: "" },
    method:          { type: String, default: "get" },
    dataType:        { type: String, default: "json" },
    serializeForm:   { type: Boolean, default: false },
    cache:           { type: Boolean, default: false },
    loadingDuration: { type: Number, default: 0 },
    errorDuration:   { type: Number, default: 2000 },
    throttle:        { type: Number, default: 0 },
    on:              { type: String, default: "" },
  }

  connect() {
    // Only auto-initialize if 'on' is set (e.g., "click", "now").
    // Otherwise, API is triggered via the query() action.
    if (this.onValue) {
      $(this.element).api(this._options())
    }
  }

  disconnect() {
    $(this.element).api("destroy")
  }

  query() {
    $(this.element).api(this._options()).api("query")
  }

  abort() {
    $(this.element).api("abort")
  }

  // -- Private --

  _options() {
    const opts = {
      url:             this.urlValue,
      method:          this.methodValue,
      dataType:        this.dataTypeValue,
      serializeForm:   this.serializeFormValue,
      cache:           this.cacheValue,
      loadingDuration: this.loadingDurationValue,
      errorDuration:   this.errorDurationValue,
      throttle:        this.throttleValue,
      onSuccess: (response) => {
        this.dispatch("success", { detail: { response } })
      },
      onFailure: (response) => {
        this.dispatch("failure", { detail: { response } })
      },
      onComplete: (response) => {
        this.dispatch("complete", { detail: { response } })
      },
      onAbort: () => {
        this.dispatch("abort")
      },
      onError: (errorMessage) => {
        this.dispatch("error", { detail: { error: errorMessage } })
      },
    }

    if (this.onValue) opts.on = this.onValue

    return opts
  }
}
