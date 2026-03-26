import { Controller } from "@hotwired/stimulus"

// Fomantic-UI Rating — star/heart rating widget.
// Bridges: $.fn.rating
//
// Usage:
//   <div class="ui star rating" data-controller="fui-rating"
//        data-fui-rating-max-rating-value="5"
//        data-fui-rating-initial-rating-value="3">
//   </div>
//
export default class extends Controller {
  static values = {
    maxRating:     { type: Number, default: 5 },
    initialRating: { type: Number, default: 0 },
    interactive:   { type: Boolean, default: true },
    clearable:     { type: Boolean, default: false },
    fireOnInit:    { type: Boolean, default: false },
  }

  connect() {
    $(this.element).rating(this._options())
  }

  disconnect() {
    $(this.element).rating("destroy")
  }

  getRating()       { return $(this.element).rating("get rating") }
  setRating(rating) { $(this.element).rating("set rating", rating) }
  clearRating()     { $(this.element).rating("clear rating") }
  enable()          { $(this.element).rating("enable") }
  disable()         { $(this.element).rating("disable") }

  // -- Private --

  _options() {
    return {
      maxRating:     this.maxRatingValue,
      initialRating: this.initialRatingValue,
      interactive:   this.interactiveValue,
      clearable:     this.clearableValue,
      fireOnInit:    this.fireOnInitValue,
      onRate: (rating) => {
        this.dispatch("rate", { detail: { rating } })
      },
    }
  }
}
