import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    options: { type: Object, default: {} }
  }

  connect() {
    this.dt = new DataTable(this.element.querySelector("table"), {
      pageLength: 25,
      order: [[0, "desc"]],
      language: { search: "Filter:" },
      ...this.optionsValue
    })
  }

  disconnect() {
    if (this.dt) {
      this.dt.destroy()
      this.dt = null
    }
  }
}
