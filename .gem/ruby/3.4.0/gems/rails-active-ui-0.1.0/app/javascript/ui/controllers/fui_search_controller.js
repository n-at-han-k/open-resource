import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Search — search with local or remote data sources.
// Bridges: $.fn.search
//
// Usage:
//   <div class="ui search" data-controller="fui-search">
//     <div class="ui icon input">
//       <input class="prompt" type="text">
//       <i class="search icon"></i>
//     </div>
//     <div class="results"></div>
//   </div>
//
export default class extends Controller {
  static values = {
    minCharacters:    { type: Number, default: 1 },
    searchDelay:      { type: Number, default: 200 },
    maxResults:       { type: Number, default: 7 },
    showNoResults:    { type: Boolean, default: true },
    url:              { type: String, default: "" },
    searchFields:     { type: Array, default: ["title", "description"] },
    source:           { type: Array, default: [] },
    noResultsMessage: { type: String, default: "No results found." },
    apiSettings:      { type: String, default: "" },
  }

  connect() {
    $(this.element).search(this._options())
  }

  disconnect() {
    $(this.element).search("destroy")
  }

  query()       { $(this.element).search("query") }
  showResults() { $(this.element).search("show results") }
  hideResults() { $(this.element).search("hide results") }
  getValue()    { return $(this.element).search("get value") }

  // -- Private --

  _options() {
    const opts = {
      minCharacters: this.minCharactersValue,
      searchDelay:   this.searchDelayValue,
      maxResults:    this.maxResultsValue,
      showNoResults: this.showNoResultsValue,
      searchFields:  this.searchFieldsValue,
      error: {
        noResults: this.noResultsMessageValue,
      },
      onSelect: (result, response) => {
        this.dispatch("select", { detail: { result, response } })
      },
      onResults: (response) => {
        this.dispatch("results", { detail: { response } })
      },
      onResultsOpen: () => { this.dispatch("resultsOpen") },
      onResultsClose: () => { this.dispatch("resultsClose") },
    }

    if (this.urlValue) {
      opts.apiSettings = { url: this.urlValue }
    } else if (this.apiSettingsValue) {
      try { opts.apiSettings = JSON.parse(this.apiSettingsValue) }
      catch (e) { /* invalid JSON */ }
    }

    if (this.sourceValue.length > 0) {
      opts.source = this.sourceValue
    }

    return opts
  }
}
