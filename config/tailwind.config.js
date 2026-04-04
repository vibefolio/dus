module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: "#00a859",
          dark: "#008a47",
        },
        accent: "#00d670",
      },
      fontFamily: {
        sans: ['Paperlogy', 'system-ui', '-apple-system', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
