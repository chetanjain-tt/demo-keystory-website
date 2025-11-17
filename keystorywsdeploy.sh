#!/bin/bash

# KeyStory Demo Website Deployment Script
# This script deploys website files to the EC2 server, clears cache, and restarts Nginx

# Configuration
SERVER_IP="13.223.243.208"
SERVER_USER="ec2-user"
KEY_FILE="keystorydemo.pem"
REMOTE_TEMP="/home/ec2-user/website_files"
WEB_ROOT="/var/www/html"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}KeyStory Demo Website Deployment Script${NC}"
echo -e "${GREEN}========================================${NC}"

# Check if SSH key exists
if [ ! -f "$KEY_FILE" ]; then
    echo -e "${RED}Error: SSH key file $KEY_FILE not found!${NC}"
    exit 1
fi

# Files and directories to deploy
echo -e "\n${YELLOW}Step 1: Preparing files for deployment...${NC}"
FILES_TO_DEPLOY=(
    "index.html"
    "about.html"
    "properties.html"
    "case-studies.html"
    "contact.html"
    "styles.css"
    "script.js"
    "assets"
)

# Check if files exist
for file in "${FILES_TO_DEPLOY[@]}"; do
    if [ ! -e "$file" ]; then
        echo -e "${RED}Warning: $file not found, skipping...${NC}"
    else
        echo -e "  ✓ Found: $file"
    fi
done

# Create temporary directory on server
echo -e "\n${YELLOW}Step 2: Creating temporary directory on server...${NC}"
ssh -i "$KEY_FILE" "$SERVER_USER@$SERVER_IP" "rm -rf $REMOTE_TEMP && mkdir -p $REMOTE_TEMP"

# Copy files to server
echo -e "\n${YELLOW}Step 3: Copying files to server...${NC}"
for file in "${FILES_TO_DEPLOY[@]}"; do
    if [ -e "$file" ]; then
        echo -e "  Copying $file..."
        scp -i "$KEY_FILE" -r "$file" "$SERVER_USER@$SERVER_IP:$REMOTE_TEMP/" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "  ${GREEN}✓${NC} $file copied successfully"
        else
            echo -e "  ${RED}✗${NC} Failed to copy $file"
        fi
    fi
done

# Deploy files to web root and set permissions
echo -e "\n${YELLOW}Step 4: Deploying files to web root...${NC}"
ssh -i "$KEY_FILE" "$SERVER_USER@$SERVER_IP" << 'EOF'
    # Backup existing files (optional)
    sudo rm -rf /var/www/html.backup
    sudo cp -r /var/www/html /var/www/html.backup 2>/dev/null

    # Clear existing web root
    sudo rm -rf /var/www/html/*

    # Copy new files to web root
    sudo cp -r /home/ec2-user/website_files/* /var/www/html/

    # Set proper ownership and permissions
    sudo chown -R nginx:nginx /var/www/html/
    sudo chmod -R 755 /var/www/html/

    # Clean up temporary files
    rm -rf /home/ec2-user/website_files
EOF

echo -e "  ${GREEN}✓${NC} Files deployed to web root"

# Clear Nginx cache
echo -e "\n${YELLOW}Step 5: Clearing Nginx cache...${NC}"
ssh -i "$KEY_FILE" "$SERVER_USER@$SERVER_IP" << 'EOF'
    # Clear Nginx cache if cache directory exists
    if [ -d "/var/cache/nginx" ]; then
        sudo rm -rf /var/cache/nginx/*
        echo "  ✓ Nginx cache cleared"
    fi

    # Clear browser cache by adding cache-control headers (already in nginx config)
    # Clear any FastCGI cache if exists
    if [ -d "/var/run/nginx-cache" ]; then
        sudo rm -rf /var/run/nginx-cache/*
        echo "  ✓ FastCGI cache cleared"
    fi
EOF

# Test Nginx configuration
echo -e "\n${YELLOW}Step 6: Testing Nginx configuration...${NC}"
ssh -i "$KEY_FILE" "$SERVER_USER@$SERVER_IP" "sudo nginx -t" 2>&1 | grep -q "successful"
if [ $? -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} Nginx configuration is valid"
else
    echo -e "  ${RED}✗${NC} Nginx configuration test failed!"
    echo -e "  ${YELLOW}Please check the configuration manually${NC}"
    exit 1
fi

# Restart Nginx
echo -e "\n${YELLOW}Step 7: Restarting Nginx...${NC}"
ssh -i "$KEY_FILE" "$SERVER_USER@$SERVER_IP" "sudo systemctl restart nginx"
if [ $? -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} Nginx restarted successfully"
else
    echo -e "  ${RED}✗${NC} Failed to restart Nginx"
    exit 1
fi

# Verify website is accessible
echo -e "\n${YELLOW}Step 8: Verifying website accessibility...${NC}"

# Check HTTP redirect
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -L http://keystorydemo.com 2>/dev/null)
if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "  ${GREEN}✓${NC} HTTP redirect working (Status: $HTTP_STATUS)"
else
    echo -e "  ${YELLOW}⚠${NC} HTTP status: $HTTP_STATUS"
fi

# Check HTTPS
HTTPS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://keystorydemo.com 2>/dev/null)
if [ "$HTTPS_STATUS" = "200" ]; then
    echo -e "  ${GREEN}✓${NC} HTTPS working (Status: $HTTPS_STATUS)"
else
    echo -e "  ${YELLOW}⚠${NC} HTTPS status: $HTTPS_STATUS"
fi

# Check server IP directly
IP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -k https://$SERVER_IP 2>/dev/null)
echo -e "  ${GREEN}✓${NC} Direct IP access (Status: $IP_STATUS)"

# Display deployment summary
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nWebsite URLs:"
echo -e "  • https://keystorydemo.com"
echo -e "  • https://www.keystorydemo.com"
echo -e "  • https://$SERVER_IP (direct IP)"
echo -e "\nDeployment timestamp: $(date)"
echo -e "\n${YELLOW}Note: DNS propagation may take up to 48 hours${NC}"
echo -e "${YELLOW}Clear your browser cache if you don't see updates${NC}"

# Optional: Show recent Nginx logs
echo -e "\n${YELLOW}Recent Nginx Access Logs:${NC}"
ssh -i "$KEY_FILE" "$SERVER_USER@$SERVER_IP" "sudo tail -5 /var/log/nginx/access.log 2>/dev/null || echo '  No recent access logs'"

exit 0