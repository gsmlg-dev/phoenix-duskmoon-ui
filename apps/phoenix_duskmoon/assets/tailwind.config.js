// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
var hasOwn = require('object.hasown');

if (!Object.hasOwn) {
  hasOwn.shim();
}

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/phoenix_duskmoon/*.ex',
    '../lib/phoenix_duskmoon/**/*.ex',
  ],
  plugins: [
    require("@tailwindcss/typography"),
    require("daisyui"),
  ],
  daisyui: {
    themes: false, // false: only light + dark | true: all themes | array: specific themes like this ["light", "dark", "cupcake"]
    darkTheme: "dark", // name of one of the included themes for dark mode
    // base: true, // applies background color and foreground color for root element by default
    styled: true, // include daisyUI colors and design decisions for all components
    utils: true, // adds responsive and modifier utility classes
    // prefix: "dm-", // prefix for daisyUI classnames (components, modifiers and responsive class names. Not colors)
    logs: true, // Shows info about daisyUI version and used config in the console when building your CSS
  },
};
