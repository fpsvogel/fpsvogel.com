import "index.css"

// Import all JavaScript & CSS files from src/_components
import components from "bridgetownComponents/**/*.{js,jsx,js.rb,css}"

console.info("Bridgetown is loaded!")

const application = Application.start()
const context = require.context("./controllers", true, /.js$/)
application.load(definitionsFromContext(context))
