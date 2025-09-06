import { useState, useEffect } from 'react';
import { MainInterface } from './components/MainInterface';
import { ThemeName, getTheme, applyThemeToDocument } from './lib/themes';
import './App.css';

function App() {
  const [currentTheme, setCurrentTheme] = useState<ThemeName>('tinycore');

  useEffect(() => {
    // Apply initial theme
    const theme = getTheme(currentTheme);
    applyThemeToDocument(theme);
  }, [currentTheme]);

  const handleThemeChange = (newTheme: ThemeName) => {
    setCurrentTheme(newTheme);
    const theme = getTheme(newTheme);
    applyThemeToDocument(theme);
  };

  return (
    <div className="app">
      <MainInterface 
        theme={currentTheme}
        onThemeChange={handleThemeChange}
      />
    </div>
  );
}

export default App;
