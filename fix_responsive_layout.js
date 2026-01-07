
const fs = require('fs');
const path = require('path');

const templatesDir = 'app/views/templates';
const files = fs.readdirSync(templatesDir).filter(f => f.endsWith('.html.erb'));

files.forEach(file => {
  const filePath = path.join(templatesDir, file);
  let content = fs.readFileSync(filePath, 'utf8');
  let originalContent = content;

  // 1. Fix Large Text (text-5xl, 6xl, 7xl, 8xl, 9xl)
  // Logic: Replace `text-[size]` with `text-3xl md:text-[size]` or `text-4xl md:text-[size]`
  // We want to avoid double replacement, so we check if it already has md: prefix.
  // Actually, we can use regex lookbehind/lookahead or just match carefully.

  // Matches text-5xl ... text-9xl that are NOT preceded by md: or lg: or xl:
  // But JS regex lookbehind is not fully supported in all node versions? It is in modern node.
  // Let's use a simpler approach: Match `class="..."` content and replace inside it.

  // However, parsing HTML classes via regex is tricky.
  // Let's do global replacements on common patterns, assuming standard Tailwind usage.

  // text-5xl -> text-3xl md:text-5xl
  content = content.replace(/(?<!md:|lg:|xl:)text-5xl/g, 'text-3xl md:text-5xl');
  content = content.replace(/(?<!md:|lg:|xl:)text-6xl/g, 'text-4xl md:text-6xl');
  content = content.replace(/(?<!md:|lg:|xl:)text-7xl/g, 'text-4xl md:text-7xl');
  content = content.replace(/(?<!md:|lg:|xl:)text-8xl/g, 'text-5xl md:text-8xl');
  content = content.replace(/(?<!md:|lg:|xl:)text-9xl/g, 'text-5xl md:text-9xl');
  content = content.replace(/(?<!md:|lg:|xl:)text-\[([5-9]rem)\]/g, 'text-4xl md:text-[$1]');
  content = content.replace(/(?<!md:|lg:|xl:)text-\[([1-9][0-9]rem)\]/g, 'text-5xl md:text-[$1]');

  // 2. Fix Grid Columns (grid-cols-2, 3, 4)
  // Ensure they start as grid-cols-1 on mobile
  content = content.replace(/(?<!md:|lg:|xl:)grid-cols-2/g, 'grid-cols-1 md:grid-cols-2');
  content = content.replace(/(?<!md:|lg:|xl:)grid-cols-3/g, 'grid-cols-1 md:grid-cols-3');
  content = content.replace(/(?<!md:|lg:|xl:)grid-cols-4/g, 'grid-cols-1 md:grid-cols-4');

  // 3. Fix Large Padding/Margin
  // p-20 -> p-6 md:p-20
  // py-20 -> py-10 md:py-20
  // px-20 -> px-6 md:px-20
  content = content.replace(/(?<!md:|lg:|xl:)p-16/g, 'p-6 md:p-16');
  content = content.replace(/(?<!md:|lg:|xl:)p-20/g, 'p-8 md:p-20');
  content = content.replace(/(?<!md:|lg:|xl:)p-24/g, 'p-8 md:p-24');

  content = content.replace(/(?<!md:|lg:|xl:)py-16/g, 'py-10 md:py-16');
  content = content.replace(/(?<!md:|lg:|xl:)py-20/g, 'py-12 md:py-20');
  content = content.replace(/(?<!md:|lg:|xl:)py-24/g, 'py-12 md:py-24');
  content = content.replace(/(?<!md:|lg:|xl:)py-32/g, 'py-16 md:py-32');

  content = content.replace(/(?<!md:|lg:|xl:)px-16/g, 'px-6 md:px-16');
  content = content.replace(/(?<!md:|lg:|xl:)px-20/g, 'px-6 md:px-20');

  // 4. Fix specific hardcoded pixel values if common
  // rounded-[220px...] -> rounded-[3rem...] on mobile? Maybe too complex.

  if (content !== originalContent) {
    fs.writeFileSync(filePath, content);
    console.log(`Updated layout for ${file}`);
  }
});

console.log('Responsive layout fixes complete.');
