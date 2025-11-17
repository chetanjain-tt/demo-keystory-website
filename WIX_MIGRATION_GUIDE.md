# Wix Migration Guide for KeyStory Realty Site

## Prerequisites
- Wix account (harrison.cannon@testimonialtree.com)
- Wix site created (either blank or from template)
- Wix Editor or Wix Studio access

## Migration Steps

### Step 1: Create Your Wix Site Structure

1. Log in to Wix.com
2. Create a new site or use existing one
3. Create 5 pages:
   - Home
   - About Us
   - Properties
   - Case Studies
   - Contact

### Step 2: Upload Assets to Wix Media Manager

1. In Wix Editor, go to **Media** → **Image** → **Upload Media**
2. Upload all images from `assets/images/`:
   - logo-main.png
   - sarah-johnson-photo.png
   - michael-chen-photo.png
   - emily-rodriguez-photo.png
   - colonial-home-photo.png
   - victorian-home-photo.png
   - ranch-home-photo.png
   - luxury-condo-photo.png

### Step 3: Add Content Using Wix Editor

#### For Each Page:
1. **Navigation Menu**
   - Add a horizontal menu
   - Link all 5 pages
   - Add logo image to header

2. **Home Page**
   - Add hero section with text
   - Create property gallery using Wix Gallery widget
   - Add service boxes using Wix Box elements
   - Copy text content from index.html

3. **About Page**
   - Add team member sections using Wix Repeater
   - Upload team photos
   - Add text sections for values and awards

4. **Properties Page**
   - Use Wix Repeater or Database for property listings
   - Add filter dropdown menus
   - Create property cards with images

5. **Contact Page**
   - Use Wix Forms for contact form
   - Add Google Maps widget for location
   - Add contact info text blocks

### Step 4: Add KeyStory Widget to Case Studies Page

#### Method A: Using HTML Embed (Easiest)

1. In Wix Editor, go to Case Studies page
2. Click **Add** → **Embed** → **HTML iframe**
3. Click "Enter Code" and paste:

```html
<script async defer
  src="https://apistage.keystory.ai/api/v1/widgets/widget.js"
  data-widget="jp1">
</script>
<noscript>
  <a href="https://apistage.keystory.ai/embed/jp1">View case studies</a>
</noscript>
```

4. Resize the iframe container to fit your layout
5. Set height to at least 600px

#### Method B: Using Velo (More Control)

1. Enable Dev Mode in Wix
2. Add an HTML Component to the page
3. In the page code, add:

```javascript
$w.onReady(function () {
    $w("#html1").postMessage({
        type: 'loadKeystory',
        widgetId: 'jp1'
    });
});
```

4. In the HTML component, add:

```html
<!DOCTYPE html>
<html>
<head>
    <script async defer
      src="https://apistage.keystory.ai/api/v1/widgets/widget.js"
      data-widget="jp1">
    </script>
</head>
<body>
    <div id="keystory-widget"></div>
    <noscript>
        <a href="https://apistage.keystory.ai/embed/jp1">View case studies</a>
    </noscript>
</body>
</html>
```

### Step 5: Apply Styling

1. **Colors**:
   - Primary: #667eea to #764ba2 (purple gradient)
   - Accent: #e74c3c (red)
   - Text: #2c3e50 (dark blue)

2. **Fonts**:
   - Use Wix's font picker to select similar fonts
   - Headers: Bold, sans-serif
   - Body: Regular, sans-serif

3. **Layout**:
   - Use Wix Strips for full-width sections
   - Apply consistent padding/margins

### Step 6: Configure Site Settings

1. **SEO Settings**:
   - Add page titles and descriptions
   - Set up URL slugs for each page

2. **Mobile Optimization**:
   - Use Wix Mobile Editor to adjust layouts
   - Test responsive design

3. **Forms**:
   - Connect contact form to email notifications
   - Set up form confirmations

### Step 7: Publish Your Site

1. Click **Publish** in top right
2. Choose domain (can use Wix subdomain or custom)
3. Test all functionality

## Using Wix CLI (If Git Integration Enabled)

If your Wix site has Git integration:

```bash
# Clone your Wix site repo
git clone [your-wix-repo-url]

# Copy assets
cp -r assets/* [wix-repo]/assets/

# Commit and push
git add .
git commit -m "Add KeyStory Realty assets"
git push

# Open local editor
wix dev
```

## Alternative: Using Wix Blocks

For reusable components across pages:

1. Create custom blocks for:
   - Property cards
   - Team member cards
   - Contact forms

2. Save as Master components
3. Reuse across pages

## Important Notes

- **KeyStory Widget**: The widget should work in HTML embed
- **Images**: Wix will optimize images automatically
- **Forms**: Wix forms have built-in validation and email integration
- **SEO**: Use Wix SEO Wiz for optimization
- **Analytics**: Wix provides built-in analytics

## Testing Checklist

- [ ] All pages load correctly
- [ ] Navigation works on all pages
- [ ] Images display properly
- [ ] KeyStory widget loads on Case Studies page
- [ ] Contact form submits successfully
- [ ] Mobile responsive design works
- [ ] All links are functional

## Support Resources

- [Wix Help Center](https://support.wix.com)
- [Wix Velo Documentation](https://www.wix.com/velo)
- [Wix HTML Component](https://support.wix.com/en/article/embedding-custom-code)