# Collection Banner Feature

A customizable banner system that displays at the top of every collection page in your Shopify Timber theme.

## Features

- **Automatic Display**: Shows on all collection pages automatically
- **Customizable Content**: Set default title, subtitle, and image
- **Smart Fallbacks**: Uses collection data when custom content isn't set
- **Responsive Design**: Optimized for all device sizes
- **Theme Integration**: Seamlessly integrated with existing Timber theme
- **Accessibility**: Built with accessibility best practices
- **Performance**: Optimized images with lazy loading

## What Gets Added

### 1. Collection Banner Snippet
- **File**: `snippets/collection-banner.liquid`
- **Purpose**: Renders the banner HTML structure
- **Features**: Dynamic content, overlay, responsive layout

### 2. Theme Settings
- **Section**: "Collection Pages" in theme customizer
- **Options**: Enable/disable, image, title, subtitle, height, colors, etc.

### 3. Styling
- **File**: `assets/collection-banner.scss.liquid`
- **Features**: Responsive design, animations, hover effects

### 4. Template Integration
- **Files Modified**: 
  - `templates/collection.liquid`
  - `templates/collection.list.liquid`
- **Position**: Above breadcrumbs, below pagination

### 5. Language Support
- **File**: `locales/en.default.json`
- **Strings**: Product count, popular tags labels

## Installation

The collection banner is automatically installed when you add the files to your theme. No additional setup required.

## Configuration

### Theme Settings

Navigate to **Online Store → Themes → Customize → Collection Pages** to configure:

#### Basic Settings
- **Enable collection banner**: Turn the feature on/off
- **Default banner image**: Set a fallback image for collections without images
- **Default banner title**: Set a fallback title
- **Default banner subtitle**: Set a fallback subtitle

#### Appearance
- **Banner height**: Choose between Small, Medium, or Large
- **Overlay opacity**: Control darkness of image overlay (0.0 - 1.0)
- **Text color**: Set the color for banner text

#### Content Options
- **Show product count**: Display number of products in collection
- **Show popular tags**: Display clickable collection tags

### Collection-Specific Customization

Individual collections can override the default settings by:

1. **Collection Image**: Upload an image in the collection admin
2. **Collection Title**: Edit the collection title
3. **Collection Description**: Add a description that will appear as subtitle

## How It Works

### 1. Banner Display Logic
```liquid
{% if settings.collection_banner_enable %}
  <!-- Banner content -->
{% endif %}
```

### 2. Content Priority
1. **Custom settings** (if configured in theme customizer)
2. **Collection data** (collection image, title, description)
3. **Fallback values** (default theme settings)

### 3. Responsive Behavior
- **Mobile**: Optimized spacing and typography
- **Tablet**: Medium-sized elements
- **Desktop**: Full-size banner with enhanced typography

## Customization

### Styling

The banner uses BEM methodology for CSS classes:

```scss
.collection-banner {
  &__title { /* Banner title styles */ }
  &__subtitle { /* Banner subtitle styles */ }
  &__image { /* Image container styles */ }
  &__overlay { /* Overlay styles */ }
  &__tags { /* Tags container styles */ }
  &__tag { /* Individual tag styles */ }
}
```

### Height Variations

Three height options available:

```scss
.collection-banner--small { /* 200px mobile, 250px desktop */ }
.collection-banner--medium { /* 300px mobile, 400px desktop */ }
.collection-banner--large { /* 400px mobile, 500px desktop */ }
```

### CSS Custom Properties

The banner uses CSS custom properties for dynamic styling:

```scss
--banner-overlay-opacity: 0.4;
--banner-text-color: #ffffff;
```

## Browser Support

- **Modern Browsers**: Full support with all features
- **IE11+**: Basic functionality (fallback gradient background)
- **Mobile Browsers**: Full responsive support

## Performance Considerations

### Image Optimization
- Uses Shopify's `img_url` filter for automatic optimization
- Lazy loading for better page load performance
- Responsive image sizing

### CSS Optimization
- Minimal CSS footprint
- Efficient selectors
- Hardware-accelerated animations

## Accessibility Features

- **Semantic HTML**: Proper heading hierarchy
- **Keyboard Navigation**: Focusable tag links
- **Screen Reader Support**: Alt text for images
- **High Contrast Mode**: Enhanced visibility options
- **Reduced Motion**: Respects user preferences

## Troubleshooting

### Banner Not Showing
1. Check if `collection_banner_enable` is set to `true`
2. Verify the snippet is included in collection templates
3. Check browser console for CSS errors

### Styling Issues
1. Ensure `collection-banner.scss.css` is properly linked
2. Check for CSS conflicts with existing theme styles
3. Verify CSS custom properties are supported

### Content Not Displaying
1. Check collection has image, title, or description
2. Verify theme settings are configured
3. Check locale strings are properly set

## File Structure

```
snippets/
├── collection-banner.liquid          # Banner HTML template
templates/
├── collection.liquid                 # Main collection template (modified)
├── collection.list.liquid            # List view template (modified)
assets/
├── collection-banner.scss.liquid     # Banner styles
config/
├── settings_schema.json              # Theme settings (modified)
├── settings_data.json                # Default values (modified)
locales/
├── en.default.json                   # English strings (modified)
```

## Future Enhancements

Potential improvements for future versions:

- **Collection-specific banners**: Individual banner settings per collection
- **Banner templates**: Multiple banner style options
- **Dynamic content**: Integration with product recommendations
- **Analytics**: Track banner engagement and conversions
- **A/B Testing**: Test different banner configurations

## Support

For issues or questions:

1. Check the troubleshooting section above
2. Verify all files are properly uploaded
3. Check theme customizer settings
4. Review browser console for errors

## Changelog

### Version 1.0.0
- Initial release
- Basic banner functionality
- Theme settings integration
- Responsive design
- Accessibility features

