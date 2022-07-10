
const plugin = require('tailwindcss/plugin')
const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')
module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'pink-100': colors.pink[100],
      'yellow-100': colors.yellow[100],
      },
    },
  },
  plugins: [
   [require('@tailwindcss/forms'), require('@tailwindcss/line-clamp'), require('@tailwindcss/defaultTheme'), require('@tailwindcss/colors')],
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
