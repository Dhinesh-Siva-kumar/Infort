# Deploying the backend on infortsolutions.in

Target environment: Ubuntu 22.04 VPS, Nginx already serving the
`infortsolutions.in` frontend (SSL already managed by Certbot for
`infortsolutions.in` and `www.infortsolutions.in`). The backend is served
**same-origin**, on the same domain, under `/api/*` — no new subdomain, no
new DNS record, no second SSL certificate needed.

## 1. Install Node.js, PostgreSQL, PM2

```bash
# Node.js 20 LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# PostgreSQL
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# PM2 — keeps the API running and restarts it on crash/reboot
sudo npm install -g pm2
```

## 2. Create the database

```bash
sudo -u postgres psql
```
```sql
CREATE DATABASE infort_db;
CREATE USER infort_app WITH ENCRYPTED PASSWORD 'pick-a-strong-password-here';
GRANT ALL PRIVILEGES ON DATABASE infort_db TO infort_app;
\q
```

## 3. Get the code onto the server

Nothing in this repo is committed to git yet — commit and push to a private
GitHub/GitLab repo first, then:

```bash
git clone <your-repo-url> /var/www/infort
cd /var/www/infort/backend
npm ci
npm run build
```

(Alternative without git: `scp -r backend/ user@your-vps:/var/www/infort/backend`,
then run `npm ci && npm run build` on the server.)

## 4. Production `.env`

**Generate fresh secrets on the server — do not reuse local dev secrets:**

```bash
node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"   # run twice
```

`/var/www/infort/backend/.env`:

```
PORT=3000
NODE_ENV=production

DB_HOST=localhost
DB_PORT=5432
DB_NAME=infort_db
DB_USER=infort_app
DB_PASSWORD=<the password from step 2>

# Same-origin in production (Nginx proxies /api on this same domain), but
# kept here for local dev / any other client that calls cross-origin.
FRONTEND_ORIGIN=https://infortsolutions.in,https://www.infortsolutions.in

JWT_ACCESS_SECRET=<freshly generated>
JWT_REFRESH_SECRET=<freshly generated>
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=30d
```

## 5. Migrate and create the Founder account

```bash
npm run migrate
npm run create-founder -- --name "Your Name" --email founder@infortsolutions.in --password "a-strong-password"
```

## 6. Start the API under PM2

```bash
pm2 start dist/src/server.js --name infort-api
pm2 save
pm2 startup   # follow the printed instructions to enable on boot
```

## 7. Nginx — add the /api proxy to the existing site

Replace the content of your existing Nginx site file (the one serving
`infortsolutions.in`) with `backend/deploy/nginx-infortsolutions.in.conf`
from this repo — it's your current config with one addition: a
`location /api/` block proxying to the PM2-managed backend on
`127.0.0.1:3000`. Everything else (root, SSL, `try_files`) is unchanged.

```bash
sudo cp deploy/nginx-infortsolutions.in.conf /etc/nginx/sites-available/infortsolutions.in
sudo nginx -t
sudo systemctl reload nginx
```

No Certbot step needed — the existing certificate already covers this
domain.

## 8. Verify

```bash
curl https://infortsolutions.in/api/health
```
Wait — `/health` is mounted at the app root, not under `/api`, so it's not
reachable through this proxy (the `location /api/` block only forwards
`/api/*`). To check the backend directly on the server:

```bash
curl http://127.0.0.1:3000/health
```
Expected: `{"success":true,"data":{"status":"ok"},"message":"Healthy"}`

To verify the public-facing path end to end, hit a real `/api` route, e.g.:
```bash
curl -X POST https://infortsolutions.in/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"founder@infortsolutions.in","password":"wrong-password-on-purpose"}'
```
A `401 AUTHENTICATION_ERROR` JSON response (not a connection error or Nginx
502/504) confirms the proxy is wired up correctly.

## 9. Rebuild both clients for production

**Frontend** (`frontend/src/environments/environment.ts` already points at
the same-origin `/api`):

```bash
cd frontend && npx ng build --configuration=production
```
Deploy `frontend/dist/infort/browser` to wherever Nginx currently serves
`infortsolutions.in` from.

**Mobile app:**

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://infortsolutions.in/api --dart-define=ENV=production
```

## Notes

- Only ports 80/443 need to be open in the VPS firewall (`ufw`) — port 3000
  stays internal; only Nginx talks to it directly.
- To deploy an update later: `git pull`, `npm ci`, `npm run build`,
  `npm run migrate` (if there are new migrations), `pm2 restart infort-api`.
