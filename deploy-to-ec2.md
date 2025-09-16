# AWS EC2 Deployment Guide for Shopify Timber Theme

## Prerequisites
1. AWS Account
2. EC2 Instance running Ubuntu/Amazon Linux
3. Domain name (optional)

## Step 1: Launch EC2 Instance
1. Go to AWS Console → EC2 → Launch Instance
2. Choose Ubuntu Server 22.04 LTS
3. Select t2.micro (free tier) or larger
4. Configure security group to allow:
   - SSH (22)
   - HTTP (80)
   - HTTPS (443)
5. Launch and download key pair

## Step 2: Connect to EC2
```bash
ssh -i "your-key.pem" ubuntu@your-ec2-public-ip
```

## Step 3: Install Web Server
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

## Step 4: Deploy Your Theme
```bash
# Create web directory
sudo mkdir -p /var/www/timber-theme

# Set permissions
sudo chown -R $USER:$USER /var/www/timber-theme
sudo chmod -R 755 /var/www/timber-theme
```

## Step 5: Configure Nginx
```bash
# Create Nginx configuration
sudo nano /etc/nginx/sites-available/timber-theme
```

## Step 6: SSL Certificate (Optional)
```bash
# Install Certbot for Let's Encrypt
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your-domain.com
```

## Step 7: Upload Files
Use SCP to upload your theme files:
```bash
scp -i "your-key.pem" -r . ubuntu@your-ec2-ip:/var/www/timber-theme/
```

## Step 8: Configure Nginx Virtual Host
```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    root /var/www/timber-theme;
    index index.html index.liquid;

    location / {
        try_files $uri $uri/ =404;
    }

    # Serve static assets
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## Step 9: Enable Site and Restart
```bash
sudo ln -s /etc/nginx/sites-available/timber-theme /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## Deployment Script
Use the provided deploy.sh script for automated deployment.
