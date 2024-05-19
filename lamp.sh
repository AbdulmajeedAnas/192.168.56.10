#!/bin/bash

# Define variables
GITHUB_REPO_URL="https://github.com/laravel/laravel"
DB_NAME="mydb"
DB_USER="user1"
DB_PASSWORD="password"
APP_DIR="/var/www/html/myblog"

# Function to update package lists
update_packages() {
    echo "Updating package lists..."
    apt update
}

# Function to install Apache
install_apache() {
    echo "Installing Apache..."
    apt install -y apache2
    echo "Enabling Apache to start on boot..."
    systemctl enable apache2
    echo "Starting Apache..."
    systemctl start apache2
}

# Function to install MySQL
install_mysql() {
    echo "Installing MySQL..."
    DEBIAN_FRONTEND=noninteractive apt install -y mysql-server
    echo "Securing MySQL installation..."
    mysql_secure_installation <<EOF

y
$DB_PASSWORD
$DB_PASSWORD
y
y
y
y
EOF
}


# Function to configure MySQL
configure_mysql() {
    echo "Creating MySQL database and user..."
    mysql -u root -p$DB_PASSWORD -e "CREATE DATABASE $DB_NAME;"
    mysql -u root -p$DB_PASSWORD -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    mysql -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
    mysql -u root -p$DB_PASSWORD -e "FLUSH PRIVILEGES;"
}

# Function to install PHP
install_php() {
    echo "Installing PHP..."
    apt install -y php libapache2-mod-php php-mysql
}

# Function to clone the PHP application from GitHub
clone_php_app() {
    echo "Cloning PHP application from GitHub..."
    apt install -y git
    git clone $GITHUB_REPO_URL $APP_DIR
}

# Function to set permissions for the web root
set_permissions() {
    echo "Setting permissions for $APP_DIR..."
    chown -R www-data:www-data $APP_DIR
}

# Function to configure Apache
configure_apache() {
    echo "Configuring Apache..."
    cat <<EOT > /etc/apache2/sites-available/yourapp.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $APP_DIR
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    <Directory $APP_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOT

    echo "Enabling site configuration..."
    a2dissite 000-default.conf
    a2ensite yourapp.conf
    a2enmod rewrite
    echo "Restarting Apache..."
    systemctl restart apache2
}

# Function to test the setup
test_setup() {
    echo "Testing Apache..."
    if systemctl is-active --quiet apache2; then
        echo "Apache is running."
    else
        echo "Apache is not running. Exiting."
        exit 1
    fi

    echo "Testing MySQL..."
    if systemctl is-active --quiet mysql; then
        echo "MySQL is running."
    else
        echo "MySQL is not running. Exiting."
        exit 1
    fi

    echo "Testing PHP..."
    PHP_TEST_FILE="/var/www/html/info.php"
    echo "<?php phpinfo(); ?>" > $PHP_TEST_FILE
    HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/info.php)
    if [ "$HTTP_RESPONSE" -eq 200 ]; then
        echo "PHP is working."
    else
        echo "PHP is not working. Exiting."
        exit 1
    fi
    rm $PHP_TEST_FILE

    echo "Testing MySQL database and user..."
    mysql -u $DB_USER -p$DB_PASSWORD -e "USE $DB_NAME;" &>/dev/null
    if [ $? -eq 0 ]; then
        echo "MySQL database and user are configured correctly."
    else
        echo "MySQL database or user is not configured correctly. Exiting."
        exit 1
    fi

    echo "Testing application cloning..."
    if [ -d "$APP_DIR" ]; then
        echo "Application cloned successfully."
    else
        echo "Application cloning failed. Exiting."
        exit 1
    fi

    echo "All tests passed successfully."
}

# Main function to execute all steps
main() {
    update_packages
    install_apache
    install_mysql
    configure_mysql
    install_php
    clone_php_app
    set_permissions
    configure_apache
    test_setup
    echo "LAMP stack installation and PHP application deployment completed."
    echo "You can access your application at http://your_server_ip/"
}

# Execute the main function
main

