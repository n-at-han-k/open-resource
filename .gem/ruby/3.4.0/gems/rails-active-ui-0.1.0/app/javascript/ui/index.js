// Fomantic-UI Stimulus Controllers (jQuery Bridge)
//
// Each controller is a thin lifecycle bridge that initializes the corresponding
// Fomantic-UI jQuery plugin in connect() and destroys it in disconnect().
// Stimulus handles the DOM lifecycle (Turbo-compatible), jQuery/Fomantic handles
// the actual widget behavior.
//
// Prerequisites: jQuery and the Fomantic-UI component JS files must be loaded
// globally (via <script> tags) before these controllers are used.
//
// Usage (in your app's JavaScript entry point):
//
//   import { Application } from "@hotwired/stimulus"
//   import { registerFuiControllers } from "ui"
//
//   const application = Application.start()
//   registerFuiControllers(application)
//

// Globals
import FuiSiteController from "ui/controllers/fui_site_controller"

// Collections
import FuiFormController from "ui/controllers/fui_form_controller"

// Modules
import FuiAccordionController from "ui/controllers/fui_accordion_controller"
import FuiCalendarController from "ui/controllers/fui_calendar_controller"
import FuiCheckboxController from "ui/controllers/fui_checkbox_controller"
import FuiDimmerController from "ui/controllers/fui_dimmer_controller"
import FuiDropdownController from "ui/controllers/fui_dropdown_controller"
import FuiEmbedController from "ui/controllers/fui_embed_controller"
import FuiFlyoutController from "ui/controllers/fui_flyout_controller"
import FuiModalController from "ui/controllers/fui_modal_controller"
import FuiNagController from "ui/controllers/fui_nag_controller"
import FuiPopupController from "ui/controllers/fui_popup_controller"
import FuiProgressController from "ui/controllers/fui_progress_controller"
import FuiSliderController from "ui/controllers/fui_slider_controller"
import FuiRatingController from "ui/controllers/fui_rating_controller"
import FuiSearchController from "ui/controllers/fui_search_controller"
import FuiShapeController from "ui/controllers/fui_shape_controller"
import FuiSidebarController from "ui/controllers/fui_sidebar_controller"
import FuiStickyController from "ui/controllers/fui_sticky_controller"
import FuiTabController from "ui/controllers/fui_tab_controller"
import FuiToastController from "ui/controllers/fui_toast_controller"
import FuiTransitionController from "ui/controllers/fui_transition_controller"

// Behaviors
import FuiApiController from "ui/controllers/fui_api_controller"
import FuiStateController from "ui/controllers/fui_state_controller"
import FuiVisibilityController from "ui/controllers/fui_visibility_controller"

const controllers = {
  "fui-site":       FuiSiteController,
  "fui-form":       FuiFormController,
  "fui-accordion":  FuiAccordionController,
  "fui-calendar":   FuiCalendarController,
  "fui-checkbox":   FuiCheckboxController,
  "fui-dimmer":     FuiDimmerController,
  "fui-dropdown":   FuiDropdownController,
  "fui-embed":      FuiEmbedController,
  "fui-flyout":     FuiFlyoutController,
  "fui-modal":      FuiModalController,
  "fui-nag":        FuiNagController,
  "fui-popup":      FuiPopupController,
  "fui-progress":   FuiProgressController,
  "fui-slider":     FuiSliderController,
  "fui-rating":     FuiRatingController,
  "fui-search":     FuiSearchController,
  "fui-shape":      FuiShapeController,
  "fui-sidebar":    FuiSidebarController,
  "fui-sticky":     FuiStickyController,
  "fui-tab":        FuiTabController,
  "fui-toast":      FuiToastController,
  "fui-transition": FuiTransitionController,
  "fui-api":        FuiApiController,
  "fui-state":      FuiStateController,
  "fui-visibility": FuiVisibilityController,
}

export function registerFuiControllers(application) {
  for (const [identifier, controllerClass] of Object.entries(controllers)) {
    application.register(identifier, controllerClass)
  }
}

// Also export individual controllers for selective registration
export {
  FuiSiteController,
  FuiFormController,
  FuiAccordionController,
  FuiCalendarController,
  FuiCheckboxController,
  FuiDimmerController,
  FuiDropdownController,
  FuiEmbedController,
  FuiFlyoutController,
  FuiModalController,
  FuiNagController,
  FuiPopupController,
  FuiProgressController,
  FuiSliderController,
  FuiRatingController,
  FuiSearchController,
  FuiShapeController,
  FuiSidebarController,
  FuiStickyController,
  FuiTabController,
  FuiToastController,
  FuiTransitionController,
  FuiApiController,
  FuiStateController,
  FuiVisibilityController,
}
