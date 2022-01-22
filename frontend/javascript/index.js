import "index.css"
import { Application } from "@hotwired/stimulus"

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
