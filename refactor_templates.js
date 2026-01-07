
const fs = require('fs');
const path = require('path');

const templatesDir = 'app/views/templates';
const files = fs.readdirSync(templatesDir).filter(f => f.endsWith('.html.erb'));

// Known images from TEMPLATES_DATA.md or generic safe ones
const SAFE_IMAGES = {
  'academy': 'https://images.unsplash.com/photo-1544377193-33dcf4d68fb5?q=80&w=1200',
  'beauty': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1200',
  'dining': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=1200',
  'gym': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1200',
  'study': 'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=1200',
  'ecommerce': 'https://images.unsplash.com/photo-1445205170230-053b83016050?q=80&w=1200',
  'corporate': 'https://images.unsplash.com/photo-1551434678-e076c2236034?q=80&w=1200',
  'cafe': 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?q=80&w=1200',
  'portfolio': 'https://images.unsplash.com/photo-1600607686527-6fb886090705?q=80&w=1200',
  'medical': 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=1200',
  'law': 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?q=80&w=1200',
  'wedding': 'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=1200',
  'cleaning': 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=1200',
  'default': 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=1200'
};

files.forEach(file => {
  const filePath = path.join(templatesDir, file);
  let content = fs.readFileSync(filePath, 'utf8');
  const templateName = path.basename(file, '.html.erb');

  console.log(`Processing ${templateName}...`);

  // 1. Analyze for primary color (heuristics: bg-[color] or text-[color] in nav/hero)
  const colorMatch = content.match(/text-\[([#a-fA-F0-9]+)\]/) || content.match(/bg-\[([#a-fA-F0-9]+)\]/);
  const primaryColor = colorMatch ? colorMatch[1] : '#333';

  // 2. Parse Links from Desktop Nav
  // Looking for <a href="..." ...>Text</a> inside a nav or div with 'hidden md:flex' or similar
  // This regex is brittle but works for the observed structure in academy/beauty
  const linksRegex = /<a\s+href="([^"]+)"[^>]*>([^<]+)<\/a>/g;
  let match;
  const links = [];

  // We only want links inside the 'hidden md:flex' block usually
  const navBlockRegex = /<div class="[^"]*hidden md:flex[^"]*">([\s\S]*?)<\/div>/;
  const navBlock = content.match(navBlockRegex);

  if (navBlock) {
    const navContent = navBlock[1];
    while ((match = linksRegex.exec(navContent)) !== null) {
      links.push({ href: match[1], text: match[2].trim() });
    }
  }

  // 3. Inject Mobile Hamburger Button
  // Look for the "hidden md:flex" container and insert button before it or in the mobile-visible section
  // Usually there is a "flex items-center gap-X" at the end for buttons.
  // We want to insert the hamburger button in the main flex container, usually visible on mobile.

  // Strategy: Find the Logo div, then insert button next to it?
  // No, usually hamburger is on right.
  // Find the LAST div inside nav container?

  // Check if already injected
  if (content.includes('mobile-menu-trigger')) {
    console.log(`  Skipping mobile menu injection for ${templateName} (already present)`);
  } else {
    // Attempt to find the place to insert the hamburger button.
    // Usually right before the closing </div> of the container mx-auto flex justify-between
    // We look for the "hidden md:flex" and add a button sibling to it that is "md:hidden"

    // We can insert it inside the last "flex gap-X items-center" div if it exists (action buttons)
    // Or create a new one.

    // In academy.html.erb: <div class="flex gap-6 items-center"> ... buttons ... </div>
    // We can prepend the hamburger button there.

    const actionButtonsRegex = /(<div class="flex gap-[0-9]+ items-center">)/;
    if (actionButtonsRegex.test(content)) {
       const hamburgerBtn = `
         <button class="mobile-menu-trigger md:hidden text-2xl mr-4 focus:outline-none" style="color: ${primaryColor};">
           <i class="fas fa-bars"></i>
         </button>
       `;
       // Inject before the action buttons div content starts? No, inside it?
       // If we put it inside, it will be alongside "Student LMS".
       // Let's put it BEFORE the action buttons container if possible, or inside.
       // "flex gap-6 items-center" usually is on the right.
       // If we prepend to the matched string:
       // content = content.replace(actionButtonsRegex, `$1${hamburgerBtn}`);
       // But wait, $1 is the opening tag.

       // Better: Append to the "flex items-center gap-X" containing the LOGO? No.

       // Let's add it right before the action buttons div (which is usually the last child)
       // OR simply append it to the desktop hidden nav? No.

       // Let's try to find the action button container and PREPEND the hamburger button to it (so it appears left of buttons? or right?)
       // If flex-row, order matters.

       content = content.replace(actionButtonsRegex, `$1${hamburgerBtn}`);
       console.log(`  Injected hamburger button into ${templateName}`);
    } else {
       console.log(`  Could not find action buttons container in ${templateName}. Trying fallback.`);
    }

    // 4. Inject Mobile Menu Partial Render (or Code) at the end of Nav
    // We will append the partial render code before </nav>

    const linksRuby = links.map(l => `{text: '${l.text}', href: '${l.href}'}`).join(', ');
    const partialRender = `
      <%= render partial: 'templates/shared/mobile_menu', locals: {
          links: [${linksRuby}],
          primary_color: '${primaryColor}',
          bg_color: '#ffffff'
      } %>
    `;

    content = content.replace('</nav>', `${partialRender}</nav>`);
  }

  // 5. Image Fixes (Basic)
  // If we have a known better image for the category, maybe replace the hero image?
  // Only if it looks like a placeholder or is missing.
  // Current templates seem to have images.
  // We will just verify if any src="" exists and fill it.

  if (content.includes('src=""') || content.includes('src="#"')) {
     const safeImg = SAFE_IMAGES[templateName] || SAFE_IMAGES['default'];
     content = content.replace(/src=""/g, `src="${safeImg}"`);
     content = content.replace(/src="#"/g, `src="${safeImg}"`);
     console.log(`  Fixed empty image sources in ${templateName}`);
  }

  // Write back
  fs.writeFileSync(filePath, content);
});

console.log('Refactoring complete.');
