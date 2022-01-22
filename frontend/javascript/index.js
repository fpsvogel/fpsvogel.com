import "index.css"
import { Application } from "@hotwired/stimulus"
import * as Turbo from "@hotwired/turbo"

// Uncomment the line below to add transition animations when Turbo navigates.
// We recommend adding <meta name="turbo-cache-control" content="no-preview" />
// to your HTML head if you turn on transitions. Use data-turbo-transition="false"
// on your <main> element for pages where you don't want any transition animation.
//
// import "./turbo_transitions.js"

// Import all JavaScript & CSS files from src/_components
import components from "bridgetownComponents/**/*.{js,jsx,js.rb,css}"

console.info("Bridgetown is loaded!")

window.Stimulus = Application.start()

import controllers from "./controllers/**/*.{js,js.rb}"
Object.entries(controllers).forEach(([filename, controller]) => {
  if (filename.includes("_controller.")) {
    const identifier = filename.replace("./controllers/", "")
      .replace(/_controller..*$/, "")
      .replace("_", "-") // THIS IS THE LINE I ADDED
      .replace("/", "--")

    Stimulus.register(identifier, controller.default)
  }
})
