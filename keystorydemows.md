# KeyStory Demo Website Infrastructure Documentation

## Project Overview
**Domain:** keystorydemo.com
**Purpose:** Demo real estate website for KeyStory Realty in Dedham, MA
**Created:** September 26, 2025

---

## 🌐 Domain Registration

### Domain Details
- **Domain Name:** keystorydemo.com
- **Registrar:** AWS Route53
- **Registration Date:** September 26, 2025
- **Duration:** 1 year with auto-renewal enabled
- **Privacy Protection:** Enabled for all contacts
- **Operation ID:** 6d92c92b-05fa-4bf9-a627-9827a19942a2
- **Status:** REGISTERED (pending DNS setup)

### Contact Information
- **Organization:** Testimonialtree
- **Email:** harrison.cannon@testimonialtree.com
- **Address:** 450 Washington St, Dedham, MA 02026

---

## 🖥️ EC2 Server Configuration

### Instance Details
- **Instance ID:** i-031dfd468e6116de1
- **Instance Type:** t3.micro
- **AMI:** ami-0b9755dd9758b73ce (Amazon Linux 2023)
- **Region:** us-east-1
- **Availability Zone:** us-east-1a
- **Instance Name:** keystorydemo-server
- **Launch Time:** September 26, 2025, 2:17 PM ET

### Network Configuration
- **VPC ID:** vpc-042e4d4a241dfcb40
- **Subnet ID:** subnet-08c3175b2cba7b7a9
- **Private IP:** 172.16.1.109
- **Public IP:** (Pending - will be assigned when instance is running)
- **Private DNS:** ip-172-16-1-109.ec2.internal

### Security Group
- **Group ID:** sg-0281376d0301a4e73
- **Group Name:** keystorydemo-sg
- **Description:** Security group for KeyStory Demo website

#### Inbound Rules:
| Port | Protocol | Source    | Purpose |
|------|----------|-----------|---------|
| 22   | TCP      | 0.0.0.0/0 | SSH Access |
| 80   | TCP      | 0.0.0.0/0 | HTTP Web Traffic |
| 443  | TCP      | 0.0.0.0/0 | HTTPS Secure Traffic |

### SSH Access
- **Key Pair Name:** keystorydemo
- **Key File:** `keystorydemo.pem` (located in WIX_EXAMPLE_WS directory)
- **Permissions:** 400 (read-only for owner)

#### SSH Connection Command:
```bash
ssh -i keystorydemo.pem ec2-user@<PUBLIC_IP>
```

---

## 📁 Website Files

### Directory Structure
```
WIX_EXAMPLE_WS/
├── index.html           # Homepage with Dedham localization
├── about.html           # 5 team members (expanded team)
├── properties.html      # Property listings
├── case-studies.html    # KeyStory widget integration
├── contact.html         # Contact form and location
├── styles.css          # Professional real estate styling
├── script.js           # Mobile navigation & interactions
├── keystorydemo.pem    # SSH key for EC2 access
├── assets/
│   └── images/
│       ├── logo-main.png
│       ├── sarah-johnson-photo.png
│       ├── michael-chen-photo.png
│       ├── emily-rodriguez-photo.png
│       ├── david-obrien-photo.png
│       ├── jennifer-walsh-photo.png
│       ├── colonial-home-photo.png
│       ├── victorian-home-photo.png
│       ├── ranch-home-photo.png
│       ├── luxury-condo-photo.png
│       ├── fairbanks-house-photo.png
│       ├── dedham-square-photo.png
│       └── legacy-place-photo.png
└── Documentation/
    ├── WIX_MIGRATION_GUIDE.md
    ├── punchlist.md
    ├── punchlist-completed.md
    └── keystorydemows.md (this file)
```

### Website Features
1. **Professional Design**
   - Navy/Gold/Green color scheme
   - Montserrat & Playfair Display fonts
   - Mobile-responsive with hamburger menu
   - Smooth animations and hover effects

2. **Dedham MA Localization**
   - Local landmarks (Fairbanks House, Dedham Square, Legacy Place)
   - Market statistics ($725K median, 14 days on market)
   - "Founded 1635" historical messaging
   - Community-focused content

3. **Team of 5 Agents**
   - Sarah Johnson - Principal Broker
   - Michael Chen - Senior Agent
   - Emily Rodriguez - Buyer's Agent
   - David O'Brien - Luxury Property Specialist
   - Jennifer Walsh - Relocation Expert

4. **KeyStory Integration**
   - Widget embedded in case-studies.html
   - Widget ID: jp1
   - API: https://apistage.keystory.ai/api/v1/widgets/widget.js

---

## 🚀 Deployment Steps

### 1. Connect to EC2 Instance
```bash
chmod 400 keystorydemo.pem
ssh -i keystorydemo.pem ec2-user@<PUBLIC_IP>
```

### 2. Install Web Server (on EC2)
```bash
# Update system
sudo yum update -y

# Install Apache
sudo yum install httpd -y

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Install Git
sudo yum install git -y
```

### 3. Deploy Website Files
```bash
# Copy files to server (from local machine)
scp -i keystorydemo.pem -r * ec2-user@<PUBLIC_IP>:/home/ec2-user/

# On server, move to web root
sudo cp -r /home/ec2-user/*.html /var/www/html/
sudo cp -r /home/ec2-user/*.css /var/www/html/
sudo cp -r /home/ec2-user/*.js /var/www/html/
sudo cp -r /home/ec2-user/assets /var/www/html/

# Set permissions
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/
```

---

## 🔗 DNS Configuration (Pending)

### Route53 Hosted Zone Setup
1. Create hosted zone for keystorydemo.com
2. Add A record pointing to EC2 public IP
3. Optional: Add www CNAME record

### DNS Records Needed:
```
Type  Name                 Value
A     keystorydemo.com     <EC2_PUBLIC_IP>
CNAME www.keystorydemo.com keystorydemo.com
```

---

## 📊 AWS Resources Summary

| Resource | ID/Name | Status | Cost |
|----------|---------|--------|------|
| Domain | keystorydemo.com | Registered | ~$13/year |
| EC2 Instance | i-031dfd468e6116de1 | Running | ~$8.50/month |
| Key Pair | keystorydemo | Created | Free |
| Security Group | sg-0281376d0301a4e73 | Active | Free |
| Route53 Zone | (pending) | - | $0.50/month |

**Estimated Monthly Cost:** ~$9.00/month

---

## 🔐 Security Considerations

1. **SSH Key Security**
   - Keep keystorydemo.pem file secure
   - Never commit to version control
   - Backup in secure location

2. **Security Group**
   - Currently allows SSH from anywhere (0.0.0.0/0)
   - Consider restricting SSH to specific IPs for production

3. **HTTPS Setup (Recommended)**
   - Install SSL certificate (Let's Encrypt)
   - Redirect HTTP to HTTPS
   - Update security headers

---

## 📝 Next Steps

1. ✅ Domain registered (keystorydemo.com)
2. ✅ EC2 instance launched
3. ✅ Security group configured
4. ⏳ Wait for instance to fully initialize
5. ⏳ Get public IP address
6. ⏳ Configure Route53 DNS
7. ⏳ Deploy website files to server
8. ⏳ Test website access
9. ⏳ Set up SSL certificate
10. ⏳ Configure monitoring and backups

---

## 🆘 Troubleshooting

### Cannot SSH to instance
- Check security group allows port 22
- Verify key file permissions: `chmod 400 keystorydemo.pem`
- Ensure using correct public IP
- Username is `ec2-user` for Amazon Linux

### Website not accessible
- Verify Apache is running: `sudo systemctl status httpd`
- Check security group allows ports 80/443
- Ensure files are in `/var/www/html/`
- Check file permissions

### Domain not resolving
- DNS propagation can take up to 48 hours
- Verify Route53 records are correct
- Use `nslookup keystorydemo.com` to test

---

## 📞 Support Contacts

- **AWS Support:** AWS Console > Support Center
- **Domain Issues:** Route53 Dashboard
- **Billing:** AWS Billing Dashboard
- **Technical Contact:** harrison.cannon@testimonialtree.com

---

## 📅 Important Dates

- **Domain Renewal:** September 2026
- **SSL Certificate Renewal:** (After setup - every 90 days with Let's Encrypt)
- **Instance Created:** September 26, 2025

---

## 🔄 Maintenance Commands

### Update Website Content
```bash
# From local machine
scp -i keystorydemo.pem updated-file.html ec2-user@<PUBLIC_IP>:/home/ec2-user/
# On server
sudo cp /home/ec2-user/updated-file.html /var/www/html/
```

### Restart Web Server
```bash
sudo systemctl restart httpd
```

### View Logs
```bash
sudo tail -f /var/log/httpd/access_log
sudo tail -f /var/log/httpd/error_log
```

---

*Last Updated: September 26, 2025, 2:20 PM ET*