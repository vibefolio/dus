
const fs = require('fs');
const path = require('path');

const templatesDir = 'app/views/templates';
const files = fs.readdirSync(templatesDir).filter(f => f.endsWith('.html.erb'));

const themes = {};

files.forEach(file => {
  const content = fs.readFileSync(path.join(templatesDir, file), 'utf8');
  const name = path.basename(file, '.html.erb');

  // Extract Primary Color
  // Look for text-[#...] or bg-[#...] that appears most frequently or in the hero section
  const hexColors = content.match(/#[0-9a-fA-F]{6}/g) || [];

  // Count frequency
  const colorCounts = {};
  hexColors.forEach(color => {
    colorCounts[color] = (colorCounts[color] || 0) + 1;
  });

  // Sort by frequency
  const sortedColors = Object.keys(colorCounts).sort((a, b) => colorCounts[b] - colorCounts[a]);
  const primaryColor = sortedColors[0] || '#333333';
  const secondaryColor = sortedColors[1] || '#666666';

  // Extract Font Family
  // Look for font-serif or font-sans usage
  // Or look for font-family definition in <style>
  let fontFamily = 'sans-serif';
  if (content.includes('font-serif')) fontFamily = 'serif';
  if (content.includes('font-cinzel')) fontFamily = 'Cinzel, serif';

  themes[name] = {
    primary_color: primaryColor,
    secondary_color: secondaryColor,
    font_family: fontFamily
  };
});

console.log(JSON.stringify(themes, null, 2));
