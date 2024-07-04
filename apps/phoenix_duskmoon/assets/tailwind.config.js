// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/phoenix_duskmoon/*.ex',
    '../lib/phoenix_duskmoon/**/*.ex'
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("daisyui"),
  ]
}
