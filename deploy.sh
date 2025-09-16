#!/bin/bash

# AWS EC2 Deployment Script for Shopify Timber Theme
# Usage: ./deploy.sh [ec2-ip] [key-file] [domain]

set -e

# Configuration
EC2_IP=${1:-"your-ec2-ip"}
KEY_FILE=${2:-"your-key.pem"}
DOMAIN=${3:-"your-domain.com"}
WEB_DIR="/var/www/timber-theme"

echo "🚀 Starting deployment to AWS EC2..."
echo "EC2 IP: $EC2_IP"
echo "Key File: $KEY_FILE"
echo "Domain: $DOMAIN"

# Check if key file exists
if [ ! -f "$KEY_FILE" ]; then
    echo "❌ Key file not found: $KEY_FILE"
    exit 1
fi

# Create deployment package
echo "📦 Creating deployment package..."
tar -czf timber-theme.tar.gz \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='*.log' \
    --exclude='deploy.sh' \
    --exclude='deploy-to-ec2.md' \
    .

# Upload to EC2
echo "📤 Uploading to EC2..."
scp -i "$KEY_FILE" timber-theme.tar.gz ubuntu@$EC2_IP:/tmp/

# Deploy on EC2
echo "🔧 Deploying on EC2..."
ssh -i "$KEY_FILE" ubuntu@$EC2_IP << EOF
    # Create web directory
    sudo mkdir -p $WEB_DIR
    
    # Extract files
    sudo tar -xzf /tmp/timber-theme.tar.gz -C $WEB_DIR
    
    # Set permissions
    sudo chown -R www-data:www-data $WEB_DIR
    sudo chmod -R 755 $WEB_DIR
    
    # Create Nginx configuration
    sudo tee /etc/nginx/sites-available/timber-theme > /dev/null << NGINX_EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    root $WEB_DIR;
    index index.html index.liquid;

    location / {
        try_files \$uri \$uri/ =404;
    }

    # Serve static assets with caching
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
}
NGINX_EOF

    # Enable site
    sudo ln -sf /etc/nginx/sites-available/timber-theme /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Test and reload Nginx
    sudo nginx -t && sudo systemctl reload nginx
    
    # Clean up
    rm -f /tmp/timber-theme.tar.gz
    
    echo "✅ Deployment completed successfully!"
    echo "🌐 Your site should be available at: http://$EC2_IP"
EOF

# Clean up local files
rm -f timber-theme.tar.gz

echo "🎉 Deployment completed!"
echo "🌐 Visit: http://$EC2_IP"
echo "📝 For SSL: sudo certbot --nginx -d $DOMAIN"
