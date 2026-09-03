import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        ink: {
          950: "#14110d",
          900: "#1f1a14",
          700: "#443a2c",
          500: "#6b5d49",
          300: "#a8998200",
        },
        sand: {
          50: "#faf8f4",
          100: "#f4efe6",
          200: "#e9e0d1",
          300: "#dbceb6",
        },
        brand: {
          50: "#fdf2f2",
          100: "#fbe1e1",
          300: "#e78a8f",
          500: "#c0392b",
          600: "#a6192e",
          700: "#84142a",
          900: "#4a0d18",
        },
        fit: {
          great: "#2f7d4f",
          good: "#c78a1e",
          low: "#b3492f",
        },
      },
      fontFamily: {
        sans: [
          "-apple-system",
          "BlinkMacSystemFont",
          "Inter",
          "Segoe UI",
          "sans-serif",
        ],
      },
      borderRadius: {
        xl2: "1.25rem",
        xl3: "1.75rem",
      },
      boxShadow: {
        card: "0 1px 2px rgba(20,17,13,0.04), 0 8px 24px -12px rgba(20,17,13,0.18)",
        pop: "0 12px 32px -8px rgba(20,17,13,0.28)",
      },
    },
  },
  plugins: [],
};

export default config;
