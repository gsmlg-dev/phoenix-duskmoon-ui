const plugin = require('tailwindcss/plugin');

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/**/*.exs',
    '../lib/**/*.*ex',
    '../../phoenix_duskmoon/assets/**/*.css',
    '../../phoenix_duskmoon/lib/**/*.*ex'
  ],
  theme: {
    extend: {},
  },
  plugins: [
    plugin(function ({ matchUtilities, theme }) {
      matchUtilities(
        {
          'grid-cols-auto-fill': (value) => ({
            gridTemplateColumns: `repeat(auto-fill, minmax(min(${value}, 100%), 1fr))`,
          }),
          'grid-cols-auto-fit': (value) => ({
            gridTemplateColumns: `repeat(auto-fit, minmax(min(${value}, 100%), 1fr))`,
          }),
        },
        {
          values: theme('width', {}),
        }
      )
    }),
  ]
}
