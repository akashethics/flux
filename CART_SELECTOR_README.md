# Cart Selector with Trending Products

This feature adds an intelligent cart selector that automatically displays trending products before checkout, helping to increase average order value and improve customer experience.

## Features

- **Automated Product Display**: Shows trending products from a specified collection
- **Smart Cart Integration**: Automatically updates when products are added to cart
- **Responsive Design**: Works seamlessly on both desktop and mobile devices
- **Customizable Settings**: Easy configuration through theme settings
- **Auto-refresh**: Automatically refreshes trending products at configurable intervals
- **Variant Support**: Optional display of product variants for better product selection

## Installation

The cart selector is automatically included when you enable it in your theme settings. No additional installation steps are required.

## Configuration

### Theme Settings

Navigate to **Online Store > Themes > Customize > Cart page** to configure the cart selector:

1. **Enable trending products in cart**: Toggle the feature on/off
2. **Maximum trending products to show**: Set how many products to display (2-8)
3. **Collection for trending products**: Specify which collection to pull products from
4. **Show product variants**: Enable/disable variant selection dropdowns
5. **Auto-refresh trending products**: Enable automatic refresh
6. **Auto-refresh interval**: Set refresh frequency in minutes

### Collection Setup

Create a collection (e.g., "best-sellers" or "trending") and populate it with products you want to showcase. The cart selector will automatically pull products from this collection.

## How It Works

### Cart Page Integration
- The cart selector appears below the cart contents when enabled
- Shows trending products in a responsive grid layout
- Each product displays image, title, price, and add-to-cart button

### Ajax Cart Integration
- Works seamlessly with the existing ajax cart functionality
- Trending products appear in the cart drawer
- Maintains consistent styling and behavior

### Smart Product Management
- Automatically detects products already in cart
- Updates product availability in real-time
- Handles variant selection and inventory status

## Customization

### Styling
The cart selector uses BEM methodology for CSS classes, making it easy to customize:

```scss
.cart-selector {
  // Main container styles
}

.trending-product-card {
  // Individual product card styles
}
```

### JavaScript Events
The cart selector triggers several events you can listen to:

```javascript
// Product added to cart
$(document.body).on('afterAddItem.ajaxCart', function(event, lineItem, form) {
  // Your custom logic here
});

// Trending products loaded
$(document.body).on('trendingProductsLoaded.cartSelector', function(event, products) {
  // Your custom logic here
});
```

## File Structure

```
assets/
├── cart-selector.js.liquid      # Main JavaScript functionality
├── cart-selector.scss.liquid    # Styling for cart selector
└── timber.js.liquid            # Existing theme JavaScript

snippets/
├── cart-selector.liquid         # Main cart selector template
└── trending-product-card.liquid # Individual product card template

templates/
└── cart.liquid                 # Updated cart page template

config/
├── settings_schema.json         # Theme settings configuration
└── settings_data.json          # Default settings values

locales/
└── en.default.json             # Language strings
```

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Internet Explorer 11+

## Performance Considerations

- Trending products are loaded asynchronously
- Images use lazy loading for better performance
- Auto-refresh can be disabled to reduce server requests
- Product data is cached locally to minimize API calls

## Troubleshooting

### Products Not Loading
1. Check that the specified collection exists and has products
2. Verify the collection handle is correct in theme settings
3. Check browser console for JavaScript errors

### Styling Issues
1. Ensure the cart-selector.scss.css file is properly loaded
2. Check for CSS conflicts with existing theme styles
3. Verify responsive breakpoints are working correctly

### JavaScript Errors
1. Check that jQuery is loaded before cart-selector.js
2. Verify all required dependencies are present
3. Check browser console for specific error messages

## Support

For issues or questions about the cart selector feature, please refer to:
- Theme documentation
- Shopify support resources
- Theme developer documentation

## Changelog

### Version 1.0.0
- Initial release
- Basic trending products functionality
- Responsive design
- Theme settings integration
- Ajax cart compatibility

