# Infort

Monorepo for the Infort marketing site and the Founder's mobile app.

```
frontend/   Angular 19 + Tailwind marketing site
backend/    Express + TypeScript API (Knex/PostgreSQL) backing the contact form and the mobile app
infortapp/  "Infort Founder" — Flutter mobile app for the Founder/Owner to manage contact requests
```

## Frontend

```bash
cd frontend
npm install
npm start          # http://localhost:4200
```

See `frontend/README.md` for build/test commands.

## Backend

```bash
cd backend
cp .env.example .env   # fill in DB_* credentials, JWT secrets, etc.
npm install
npm run migrate
npm run create-founder -- --name "Your Name" --email founder@infort.in --password "..."
npm run dev             # http://localhost:3000
```

See `backend/README.md` for the API contract and available scripts.

## Mobile (Infort Founder)

```bash
cd infortapp
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

See `infortapp/README.md` for architecture, environment configuration, and
Android/iOS build instructions.

## Development

Run the backend and whichever client you're working on side by side. The
frontend's `environment.development.ts` and the mobile app's default
`API_BASE_URL` both point at `http://localhost:3000` by default.
