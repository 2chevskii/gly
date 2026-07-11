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
      { text: "Architecture", link: "/architecture/" },
      { text: "Limitations", link: "/limitations/" },
    ],
    sidebar: [
      {
        text: "Guide",
        items: [
          { text: "Overview", link: "/guide/" },
          { text: "Installation", link: "/guide/installation" },
          { text: "Quick Start", link: "/guide/quick-start" },
          { text: "Configuration", link: "/guide/configuration" },
          { text: "Selectors", link: "/guide/selectors" },
          { text: "Themes", link: "/guide/themes" },
          { text: "Glyph Sets", link: "/guide/glyph-sets" },
          { text: "Capture Gallery", link: "/guide/captures" },
          { text: "Renderer Commands", link: "/guide/renderers" },
        ],
      },
      {
        text: "Reference",
        items: [
          { text: "API Reference", link: "/api/" },
          { text: "Architecture", link: "/architecture/" },
          { text: "Troubleshooting", link: "/troubleshooting/" },
          { text: "Limitations", link: "/limitations/" },
          { text: "Development", link: "/development/" },
        ],
      },
    ],
    socialLinks: [{ icon: "github", link: "https://github.com/2CHEVSKII/gly" }],
    search: {
      provider: "local",
    },
    footer: {
      message: "PowerShell-native visual formatting for file system objects.",
      copyright: "Copyright (c) 2026 2CHEVSKII",
    },
  },
});
