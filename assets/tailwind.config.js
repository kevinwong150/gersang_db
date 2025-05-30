// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require('tailwindcss/plugin')

module.exports = {
  content: [
    "./assets/js/**/*.js",
    "./lib/*_web.ex",
    "./lib/*_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        'theme-primary': '#4A4A6A',
        'theme-primary-light': '#788AA4',
        'theme-secondary': '#B4C8C8',
        'theme-secondary-light': '#F0F0F0',
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    plugin(({addVariant}) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
    plugin(({addVariant}) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
    plugin(({addVariant}) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
    plugin(({addVariant}) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &']))
  ]
}
