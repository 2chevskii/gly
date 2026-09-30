import { resolve } from "node:path";
import { defineConfig } from "vitepress";

const base = process.env.VITEPRESS_BASE ?? "/";

export default defineConfig({
  lang: "en-US",
  title: "gly",
  description: "Custom visual formatting for PowerShell file system objects.",
  base,
  vite: {
    publicDir: resolve(import.meta.dirname, "../../assets"),
  },
  cleanUrls: true,
  lastUpdated: true,
  head: [["link", { rel: "icon", href: `${base}branding/gly-logo-64.png` }]],
  themeConfig: {
    logo: "/branding/gly-logo-64.png",
    siteTitle: "gly",
    nav: [
      { text: "Guide", link: "/guide/" },
      { text: "API", link: "/api/" },
      { text: "Troubleshooting", link: "/troubleshooting/" },
      { text: "Contributors", link: "/development/" },
    ],
    sidebar: [
      {
        text: "Guide",
        items: [
          { text: "Overview", link: "/guide/" },
          { text: "Installation", link: "/guide/installation" },
          { text: "Quick Start", link: "/guide/quick-start" },
          { text: "Configuration", link: "/guide/configuration" },
          { text: "Themes", link: "/guide/themes" },
          { text: "Glyph Sets", link: "/guide/glyph-sets" },
          { text: "Renderer Commands", link: "/guide/renderers" },
          { text: "Custom Rules", link: "/guide/selectors" },
        ],
      },
      {
        text: "Reference",
        items: [
          { text: "API Reference", link: "/api/" },
          { text: "Troubleshooting", link: "/troubleshooting/" },
          { text: "Limitations", link: "/limitations/" },
        ],
      },
      {
        text: "Contributors",
        items: [
          { text: "Development", link: "/development/" },
          { text: "Architecture", link: "/architecture/" },
          { text: "Theme Palette Sources", link: "/development/theme-sources" },
        ],
      },
    ],
    socialLinks: [
      { icon: "github", link: "https://github.com/2CHEVSKII/gly" },
      {
        icon: {
          svg: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><path d="M5 4h17l-3 16H2L5 4Z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/><path d="m9 8 4 4-6 4m6 0h4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>',
        },
        link: "https://www.powershellgallery.com/packages/gly",
        ariaLabel: "gly on PowerShell Gallery",
      },
    ],
    search: {
      provider: "local",
    },
    footer: {
      message: "PowerShell-native visual formatting for file system objects.",
      copyright: "Copyright (c) 2026 2CHEVSKII",
    },
  },
});
