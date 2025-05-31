import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';
import { godotDark, godotLight } from "./src/prism/gdscript"
import { default as directiveParser } from "./src/remark/directive-parser"

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'Godot InSim',
  tagline: 'Live For Speed InSim library for Godot',
  favicon: 'img/logo.png',

  // Set the production url of your site here
  url: 'https://cykyrios.gitlab.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/godot_insim/',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          beforeDefaultRemarkPlugins: [directiveParser],
        },
        theme: {
          customCss: [
            './src/css/custom.css',
            './src/css/codeblocks.css',
          ],
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/social-card.jpg',
    navbar: {
      title: 'Godot InSim',
      logo: {
        alt: 'Godot InSim Logo',
        src: 'img/logo.png',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'classrefSidebar',
          position: 'left',
          label: 'Class Reference',
        },
        {
          type: 'docSidebar',
          sidebarId: 'guidesSidebar',
          position: 'left',
          label: 'Guides',
        },
        {
          href: 'https://gitlab.com/Cykyrios/godot_insim',
          label: 'GitLab',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Documentation',
          items: [
            {
              label: 'Class Reference',
              to: '/docs/class_ref',
            },
            {
              label: 'Guides',
              to: '/docs/guides',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitLab',
              href: 'https://gitlab.com/Cykyrios/godot_insim',
            },
            {
              label: 'Live For Speed',
              href: 'https://lfs.net',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Cyril Bissey. Built with Docusaurus.`,
    },
    colorMode: {
      defaultMode: 'dark',
      respectPrefersColorScheme: true,
    },
    prism: {
      theme: godotLight,
      darkTheme: godotDark,
      defaultLanguage: "gdscript",
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
