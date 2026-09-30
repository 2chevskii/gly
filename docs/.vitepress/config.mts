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
      { icon: "github", link: "https://github.com/2CHEVSKII/gly", ariaLabel: 'Gly on GitHub' },
      {
        icon: {
          // Simple Icons v5.0.0 (CC0): https://github.com/simple-icons/simple-icons/blob/5.0.0/icons/powershell.svg
          svg: '<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="currentColor"><title>PowerShell</title><path d="M23.181 2.974c.568 0 .923.463.792 1.035l-3.659 15.982c-.13.572-.697 1.035-1.265 1.035H.819c-.568 0-.923-.463-.792-1.035L3.686 4.009c.13-.572.697-1.035 1.265-1.035zm-8.375 9.346c.251-.394.227-.905-.09-1.243L9.122 5.125c-.38-.404-1.037-.407-1.466-.003-.429.402-.468 1.056-.088 1.46l4.662 4.96v.11l-7.42 5.374c-.45.327-.533.977-.187 1.453.346.476.991.597 1.44.27l8.229-5.91c.28-.196.438-.365.514-.52zm-2.796 4.399a.928.928 0 00-.934.923c0 .51.418.923.934.923h4.433a.928.928 0 00.934-.923.928.928 0 00-.934-.923z"/></svg>',
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
