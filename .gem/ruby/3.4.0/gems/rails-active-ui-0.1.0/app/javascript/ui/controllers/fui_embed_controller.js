import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Embed — embedded video/iframe with placeholder.
// Bridges: $.fn.embed
//
// Usage:
//   <div class="ui embed" data-controller="fui-embed"
//        data-source="youtube" data-id="dQw4w9WgXcQ">
//   </div>
//
export default class extends Controller {
  static values = {
    source:   { type: String, default: "" },
    id:       { type: String, default: "" },
    url:      { type: String, default: "" },
    autoplay: { type: Boolean, default: true },
    color:    { type: String, default: "#444" },
    hd:       { type: Boolean, default: true },
  }

  connect() {
    $(this.element).embed(this._options())
  }

  disconnect() {
    $(this.element).embed("destroy")
  }

  show()  { $(this.element).embed("show") }
  reset() { $(this.element).embed("reset") }

  // -- Private --

  _options() {
    const opts = {
      autoplay: this.autoplayValue,
      color:    this.colorValue,
      hd:       this.hdValue,
      onCreate: (url) => { this.dispatch("create", { detail: { url } }) },
      onDisplay: ()   => { this.dispatch("display") },
    }

    if (this.sourceValue) opts.source = this.sourceValue
    if (this.idValue)     opts.id = this.idValue
    if (this.urlValue)    opts.url = this.urlValue

    return opts
  }
}
