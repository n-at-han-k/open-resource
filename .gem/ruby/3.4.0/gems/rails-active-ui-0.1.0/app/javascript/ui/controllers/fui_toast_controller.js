import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Toast — toast notifications.
// Bridges: $.fn.toast
//
// Usage:
//   <div data-controller="fui-toast"
//        data-fui-toast-title-value="Success"
//        data-fui-toast-message-value="Item saved."
//        data-fui-toast-class-value="success">
//   </div>
//
export default class extends Controller {
  static values = {
    position:       { type: String, default: "top right" },
    displayTime:    { type: Number, default: 3000 },
    closeOnClick:   { type: Boolean, default: true },
    closeIcon:      { type: Boolean, default: false },
    class:          { type: String, default: "neutral" },
    title:          { type: String, default: "" },
    message:        { type: String, default: "" },
    showProgress:   { type: Boolean, default: false },
    progressUp:     { type: Boolean, default: false },
    pauseOnHover:   { type: Boolean, default: true },
    newestOnTop:    { type: Boolean, default: false },
    compact:        { type: Boolean, default: true },
  }

  connect() {
    // Toast is typically triggered imperatively, not on connect.
    // The element serves as a configuration holder.
  }

  disconnect() {}

  show() {
    $("body").toast(this._options())
  }

  // -- Private --

  _options() {
    return {
      position:     this.positionValue,
      displayTime:  this.displayTimeValue,
      closeOnClick: this.closeOnClickValue,
      closeIcon:    this.closeIconValue,
      class:        this.classValue,
      title:        this.titleValue,
      message:      this.messageValue,
      showProgress: this.showProgressValue ? (this.progressUpValue ? "top" : "bottom") : false,
      pauseOnHover: this.pauseOnHoverValue,
      newestOnTop:  this.newestOnTopValue,
      compact:      this.compactValue,
      onShow:   () => { this.dispatch("show") },
      onHide:   () => { this.dispatch("hide") },
      onRemove: () => { this.dispatch("remove") },
    }
  }
}
