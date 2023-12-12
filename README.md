# Docker Setup

## Backup

This backup script uses Cloudflare R2 for backups.

1. Add `backup.sh` to `/root/backup.sh`:
   ```
   wget -O /root/backup.sh https://raw.githubusercontent.com/xthezealot/docker-setup/main/backup.sh && chmod +x /root/backup.sh
   ```
2. Update `R2_BUCKET`, `R2_ACCESS_KEY`, `R2_SECRET_ACCESS_KEY` and `R2_ACCOUNT_ID`
3. Add cron through `crontab -e`:
   ```cron
   0 3 */2 * * /root/backup.sh
   ```
4. Check cron with `crontab -l`
