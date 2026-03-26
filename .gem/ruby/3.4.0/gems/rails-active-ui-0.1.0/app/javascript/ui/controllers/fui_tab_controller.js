import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Tab — tab navigation with content panels.
// Bridges: $.fn.tab
//
// Usage:
//   <div data-controller="fui-tab">
//     <div class="ui tabular menu">
//       <a class="item active" data-tab="first">First</a>
//       <a class="item" data-tab="second">Second</a>
//     </div>
//     <div class="ui tab segment active" data-tab="first">
//       First tab content
//     </div>
//     <div class="ui tab segment" data-tab="second">
//       Second tab content
//     </div>
//   </div>
//
export default class extends Controller {
  static values = {
    history:     { type: Boolean, default: false },
    historyType: { type: String, default: "hash" },
  }

  connect() {
    // Fomantic tab needs to be initialized on the menu items, not the container.
    // Find tabular menu items within this controller's element.
    const $items = $(this.element).find(".item[data-tab]")
    if ($items.length > 0) {
      $items.tab(this._options())
    }
  }

  disconnect() {
    const $items = $(this.element).find(".item[data-tab]")
    if ($items.length > 0) {
      $items.tab("destroy")
    }
  }

  changeTab(tabPath) {
    $(this.element).find(".item[data-tab]").tab("change tab", tabPath)
  }

  // -- Private --

  _options() {
    return {
      history:     this.historyValue,
      historyType: this.historyTypeValue,
      onVisible: (tabPath) => {
        this.dispatch("change", { detail: { tab: tabPath } })
      },
    }
  }
}
