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
    themes: ["light", "dark"],
  },
};
