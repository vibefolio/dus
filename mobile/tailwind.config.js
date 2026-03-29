/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,jsx,ts,tsx}", "./components/**/*.{js,jsx,ts,tsx}"],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
        primary: { DEFAULT: "#00a859", dark: "#008a48" },
      },
      borderRadius: {
        'card': '24px',
        'button': '9999px',
        'modal': '32px',
      },
      fontSize: {
        'heading-1': ['28px', { lineHeight: '36px', fontWeight: '700', letterSpacing: '-0.02em' }],
        'heading-2': ['22px', { lineHeight: '30px', fontWeight: '700', letterSpacing: '-0.02em' }],
        'heading-3': ['18px', { lineHeight: '26px', fontWeight: '600' }],
        'body': ['15px', { lineHeight: '22px', fontWeight: '400' }],
        'caption': ['12px', { lineHeight: '16px', fontWeight: '500' }],
        'eyebrow': ['11px', { lineHeight: '14px', fontWeight: '500', letterSpacing: '0.15em' }],
      },
    },
  },
  plugins: [],
};
