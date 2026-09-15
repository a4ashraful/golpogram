/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        ink: '#2A1620',
        paper: '#FBF3EC',
        'paper-alt': '#F3E9E4',
        cream: '#FFFDF9',
        rose: {
          light: '#F3DFE3',
          DEFAULT: '#9C3450',
          deep: '#7A2740',
        },
        gold: {
          light: '#F3E7CE',
          DEFAULT: '#B8863A',
          deep: '#8F6829',
        },
        olive: {
          light: '#E8EBDD',
          DEFAULT: '#6E7B4F',
          deep: '#565F3C',
        },
        taupe: '#8A7368',
      },
      fontFamily: {
        serif: ['Georgia', 'Cambria', '"Times New Roman"', 'Times', 'serif'],
        sans: ['"Segoe UI"', 'system-ui', '-apple-system', 'Roboto', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
