#!/bin/sh

ln -s /etc/nginx/sites-available/*.local /etc/nginx/sites-enabled/

/etc/init.d/php8.1-fpm start

crontab /etc/cron.d/web-schedule
/etc/init.d/cron start

cd /var/www/html/web && php artisan migrate
#cd /var/www/html/web && php artisan queue:listen --tries=3 >/dev/null 2>&1 &

# PM2 start
# cd /var/www/html/admin && pm2 start run_bo.sh --watch --log=/var/www/html/web/storage/logs/web_bo.log
cd /var/www/html/frontend && pm2 start run_fo.sh --watch --log=/var/www/html/web/storage/logs/web_fo.log

# Start nginx foreground
nginx -g 'daemon off;'
