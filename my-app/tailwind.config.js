// Follow this guide to add more fonts: https://stackoverflow.com/a/60857229

/** @type {import('tailwindcss').Config} */
const colors = require("tailwindcss/colors");
module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: colors.lime,
      },
      fontFamily: {
        sans: ['Sanchez', 'sans-serif']
      },
    },
  },
  plugins: [require("@tailwindcss/aspect-ratio")],
};
