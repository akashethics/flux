@echo off
REM AWS EC2 Deployment Script for Shopify Timber Theme (Windows)
REM Usage: deploy.bat [ec2-ip] [key-file] [domain]

setlocal enabledelayedexpansion

REM Configuration
set EC2_IP=%1
set KEY_FILE=%2
set DOMAIN=%3

if "%EC2_IP%"=="" set EC2_IP=your-ec2-ip
if "%KEY_FILE%"=="" set KEY_FILE=your-key.pem
if "%DOMAIN%"=="" set DOMAIN=your-domain.com

echo 🚀 Starting deployment to AWS EC2...
echo EC2 IP: %EC2_IP%
echo Key File: %KEY_FILE%
echo Domain: %DOMAIN%

REM Check if key file exists
if not exist "%KEY_FILE%" (
    echo ❌ Key file not found: %KEY_FILE%
    pause
    exit /b 1
)

REM Create deployment package (using PowerShell for compression)
echo 📦 Creating deployment package...
powershell -Command "Compress-Archive -Path 'assets','config','layout','locales','snippets','templates','index.html','bower.json','Gemfile','Gemfile.lock','LICENSE','README.md' -DestinationPath 'timber-theme.zip' -Force"

REM Upload to EC2
echo 📤 Uploading to EC2...
scp -i "%KEY_FILE%" timber-theme.zip ubuntu@%EC2_IP%:/tmp/

REM Deploy on EC2
echo 🔧 Deploying on EC2...
ssh -i "%KEY_FILE%" ubuntu@%EC2_IP% << 'EOF'
    # Create web directory
    sudo mkdir -p /var/www/timber-theme
    
    # Remove old files
    sudo rm -rf /var/www/timber-theme/*
    
    # Extract files
    sudo unzip -q /tmp/timber-theme.zip -d /var/www/timber-theme
    
    # Set permissions
    sudo chown -R www-data:www-data /var/www/timber-theme
    sudo chmod -R 755 /var/www/timber-theme
    
    # Create Nginx configuration
    sudo tee /etc/nginx/sites-available/timber-theme > /dev/null << 'NGINX_EOF'
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    root /var/www/timber-theme;
    index index.html index.liquid;

    location / {
        try_files $uri $uri/ =404;
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
    rm -f /tmp/timber-theme.zip
    
    echo ✅ Deployment completed successfully!
    echo 🌐 Your site should be available at: http://your-ec2-ip
EOF

REM Clean up local files
del timber-theme.zip

echo 🎉 Deployment completed!
echo 🌐 Visit: http://%EC2_IP%
echo 📝 For SSL: sudo certbot --nginx -d %DOMAIN%
pause
