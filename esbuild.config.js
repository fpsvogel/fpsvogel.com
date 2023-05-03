const build = require("./config/esbuild.defaults.js")
const { plugins } = require("./config/esbuild-plugins.js")
// TODO: You will manually need to move any plugins below you wish to share with
// Lit SSR into the `config/esbuild-plugins.js` file.
// Then add `...plugins` as an item in your plugins array.
//
// You might also want to include the following in your esbuild config to opt into
// `.global.css` & `.lit.css` nomenclature.
// Read https://www.bridgetownrb.com/docs/components/lit#sidecar-css-files for documentation.
/*
postCssPluginConfig: {
  filter: /(?:index|\.global)\.css$/,
},
*/



// Update this if you need to configure a destination folder other than `output`
const outputFolder = "output"

// You can customize this as you wish, perhaps to add new esbuild plugins.
//
// Eg:
//
//  ```
//  const path = require("path")
//  const esbuildCopy = require('esbuild-plugin-copy').default
//  const esbuildOptions = {
//    plugins: [
//      esbuildCopy({
//        assets: {
//          from: [path.resolve(__dirname, 'node_modules/somepackage/files/*')],
//          to: [path.resolve(__dirname, 'output/_bridgetown/somepackage/files')],
//        },
//        verbose: false
//      }),
//    ]
//  }
//  ```

const ruby2js = require("@ruby2js/esbuild-plugin")

const esbuildOptions = {
  plugins: [
    ruby2js(),
  ]
}

build(outputFolder, esbuildOptions)
