// Theme definitions for uDESK v1.7
export type ThemeName = 'polaroid' | 'c64' | 'macintosh' | 'mode7';

export interface Theme {
  name: ThemeName;
  displayName: string;
  description: string;
  fontFamily: string;
  fontSize: string;
  colors: {
    primary: string;
    secondary: string;
    background: string;
    text: string;
    accent: string;
    success: string;
    warning: string;
    error: string;
    info: string;
  };
  specialFeatures?: {
    teletext?: boolean;
    bitmapPatterns?: boolean;
    petscii?: boolean;
    doubleHeight?: boolean;
  };
}

export const themes: Record<ThemeName, Theme> = {
  polaroid: {
    name: 'polaroid',
    displayName: 'Polaroid (uDOS Default)',
    description: 'High-contrast professional development theme',
    fontFamily: "'Fira Code', 'JetBrains Mono', 'Consolas', monospace",
    fontSize: '14px',
    colors: {
      primary: '#00E5FF',
      secondary: '#FF1744',
      background: '#000000',
      text: '#FFFFFF',
      accent: '#E91E63',
      success: '#00E676',
      warning: '#FFEB3B',
      error: '#FF1744',
      info: '#2196F3',
    },
  },
  c64: {
    name: 'c64',
    displayName: 'Commodore 64',
    description: 'Authentic 8-bit computing experience',
    fontFamily: "'C64 Pro Mono', 'PetMe64', monospace",
    fontSize: '16px',
    colors: {
      primary: '#9F9FFF',
      secondary: '#8CC8D8',
      background: '#6F6FDB',
      text: '#FFFFFF',
      accent: '#6DFC07',
      success: '#6DFC07',
      warning: '#DDDD6C',
      error: '#CB7E75',
      info: '#9F9FFF',
    },
    specialFeatures: {
      petscii: true,
    },
  },
  macintosh: {
    name: 'macintosh',
    displayName: 'Classic Macintosh',
    description: 'Retro desktop computing aesthetics',
    fontFamily: "'Chicago', 'Geneva', 'Monaco', monospace",
    fontSize: '12px',
    colors: {
      primary: '#000000',
      secondary: '#666666',
      background: '#FFFFFF',
      text: '#000000',
      accent: '#999999',
      success: '#000000',
      warning: '#666666',
      error: '#000000',
      info: '#333333',
    },
    specialFeatures: {
      bitmapPatterns: true,
    },
  },
  mode7: {
    name: 'mode7',
    displayName: 'BBC Mode 7',
    description: 'Teletext graphics and educational computing',
    fontFamily: "'Teletext', 'BBC Micro', monospace",
    fontSize: '20px',
    colors: {
      primary: '#FFFF00',
      secondary: '#00FFFF',
      background: '#000000',
      text: '#FFFFFF',
      accent: '#FF00FF',
      success: '#00FF00',
      warning: '#FFFF00',
      error: '#FF0000',
      info: '#0000FF',
    },
    specialFeatures: {
      teletext: true,
      doubleHeight: true,
    },
  },
};

export const getTheme = (themeName: ThemeName): Theme => {
  return themes[themeName] || themes.polaroid;
};

export const applyThemeToDocument = (theme: Theme): void => {
  const root = document.documentElement;
  
  // Apply CSS custom properties
  Object.entries(theme.colors).forEach(([key, value]) => {
    root.style.setProperty(`--theme-${key}`, value);
  });
  
  root.style.setProperty('--theme-font-family', theme.fontFamily);
  root.style.setProperty('--theme-font-size', theme.fontSize);
  
  // Apply theme class to body
  document.body.className = document.body.className
    .replace(/theme-\w+/g, '')
    .concat(` theme-${theme.name}`)
    .trim();
};

// Theme-specific ASCII art and graphics
export const themeAssets = {
  logos: {
    polaroid: `
██╗   ██╗██████╗ ███████╗███████╗██╗  ██╗
██║   ██║██╔══██╗██╔════╝██╔════╝██║ ██╔╝
██║   ██║██║  ██║█████╗  ███████╗█████╔╝ 
██║   ██║██║  ██║██╔══╝  ╚════██║██╔═██╗ 
╚██████╔╝██████╔╝███████╗███████║██║  ██╗
 ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝`,
    c64: `
 █   █ ██████ ███████ ███████ █   █
 █   █ █   █  █       █       █  █ 
 █   █ █   █  █████   █████   ███  
 █   █ █   █  █       █       █  █ 
 █████ ██████ ███████ ███████ █   █`,
    macintosh: `
 oooo  oooo oooooooo  ooooooooo  oooooooo oooo  oooo
 oooo  oooo oooo  oo  oooo       oooo     oooo oooo 
 oooo  oooo oooo  oo  ooooooo    oooooooo  oooooo  
 oooo  oooo oooo  oo  oooo            oo  oooo oooo
 oooooooooo oooooooo  ooooooooo  oooooooo oooo  oooo`,
    mode7: `
████ ████ █████ ████ █   █
█  █ █  █ █     █    █  █ 
████ █  █ ████  ████ ███  
█  █ █  █ █        █ █  █ 
█  █ ████ █████ ████ █   █`,
  },
  
  loadingAnimations: {
    polaroid: ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'],
    c64: ['▁', '▃', '▄', '▅', '▆', '▇', '█', '▇', '▆', '▅', '▄', '▃'],
    macintosh: ['◐', '◓', '◑', '◒'],
    mode7: ['⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'],
  },
  
  prompts: {
    polaroid: 'uDOS ▶',
    c64: 'READY.',
    macintosh: 'uDOS %',
    mode7: '*** uDOS ***',
  },
};
