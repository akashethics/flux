# 🚀 AWS EC2 Setup Guide for Shopify Timber Theme

## Quick Start (5 minutes)

### Step 1: Launch EC2 Instance
1. Go to [AWS Console](https://console.aws.amazon.com/ec2/)
2. Click "Launch Instance"
3. Choose **Ubuntu Server 22.04 LTS**
4. Select **t2.micro** (free tier) or **t3.small**
5. Create new key pair or use existing
6. Configure Security Group:
   ```
   Type: SSH, Port: 22, Source: My IP
   Type: HTTP, Port: 80, Source: Anywhere (0.0.0.0/0)
   Type: HTTPS, Port: 443, Source: Anywhere (0.0.0.0/0)
   ```
7. Launch Instance

### Step 2: Connect to EC2
```bash
ssh -i "your-key.pem" ubuntu@YOUR_EC2_PUBLIC_IP
```

### Step 3: Install Web Server
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Step 4: Deploy Your Theme
**Option A: Using the deployment script (Windows)**
```cmd
deploy.bat YOUR_EC2_IP your-key.pem your-domain.com
```

**Option B: Manual deployment**
```bash
# On your local machine
scp -i "your-key.pem" -r . ubuntu@YOUR_EC2_IP:/tmp/timber-theme/

# On EC2 instance
sudo mkdir -p /var/www/timber-theme
sudo mv /tmp/timber-theme/* /var/www/timber-theme/
sudo chown -R www-data:www-data /var/www/timber-theme
sudo chmod -R 755 /var/www/timber-theme
```

### Step 5: Configure Nginx
```bash
sudo nano /etc/nginx/sites-available/timber-theme
```

Add this configuration:
```nginx
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
```

### Step 6: Enable Site
```bash
sudo ln -s /etc/nginx/sites-available/timber-theme /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

### Step 7: SSL Certificate (Optional)
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your-domain.com
```

## 🎯 Your Theme is Now Live!

- **HTTP**: http://YOUR_EC2_PUBLIC_IP
- **HTTPS**: https://your-domain.com (if SSL configured)

## 📁 What's Included

- ✅ Enhanced Timber theme with cart selector
- ✅ Collection banner features
- ✅ Responsive design showcase
- ✅ Static asset optimization
- ✅ Gzip compression
- ✅ Browser caching

## 🔧 Troubleshooting

### Nginx won't start
```bash
sudo nginx -t  # Check configuration
sudo systemctl status nginx  # Check status
sudo journalctl -u nginx  # Check logs
```

### Permission issues
```bash
sudo chown -R www-data:www-data /var/www/timber-theme
sudo chmod -R 755 /var/www/timber-theme
```

### Firewall issues
```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw enable
```

## 💡 Pro Tips

1. **Use CloudFront** for global CDN
2. **Set up automated backups** with AWS Backup
3. **Monitor with CloudWatch**
4. **Use Route 53** for DNS management
5. **Enable auto-scaling** for high traffic

## 🆘 Need Help?

- AWS EC2 Documentation: https://docs.aws.amazon.com/ec2/
- Nginx Configuration: https://nginx.org/en/docs/
- Let's Encrypt: https://letsencrypt.org/

## 📊 Estimated Costs

- **t2.micro**: Free (12 months)
- **t3.small**: ~$15/month
- **Data transfer**: ~$0.09/GB
- **Storage**: ~$0.10/GB/month

**Total for small site**: $5-20/month
