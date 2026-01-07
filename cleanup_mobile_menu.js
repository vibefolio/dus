
const fs = require('fs');
const path = require('path');

const templatesDir = 'app/views/templates';
const files = fs.readdirSync(templatesDir).filter(f => f.endsWith('.html.erb'));

files.forEach(file => {
  const filePath = path.join(templatesDir, file);
  let content = fs.readFileSync(filePath, 'utf8');

  // 1. Remove Hamburger Button
  // Pattern: <button class="mobile-menu-trigger ... </button>
  // We use a regex that matches the button specifically created
  const buttonRegex = /<button class="mobile-menu-trigger[\s\S]*?<\/button>\s*/g;

  if (buttonRegex.test(content)) {
    content = content.replace(buttonRegex, '');
    console.log(`Removed hamburger button from ${file}`);
  }

  // 2. Remove Partial Render
  // Pattern: <%= render partial: 'templates/shared/mobile_menu' ... %>
  const renderRegex = /<%= render partial: 'templates\/shared\/mobile_menu'[\s\S]*?%>\s*/g;

  if (renderRegex.test(content)) {
    content = content.replace(renderRegex, '');
    console.log(`Removed mobile menu render from ${file}`);
  }

  fs.writeFileSync(filePath, content);
});

console.log('Cleanup complete.');
