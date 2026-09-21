# Infort

Monorepo for the Infort marketing site.

```
frontend/   Angular 19 + Tailwind marketing site
backend/    Express + TypeScript API (Knex/PostgreSQL) backing the contact form
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
cp .env.example .env   # fill in DATABASE_URL etc.
npm install
npm run migrate
npm run dev             # http://localhost:3000
```

See `backend/README.md` for the API contract and available scripts.

## Development

Run both apps side by side (two terminals) for local development. The
frontend's `environment.development.ts` points at `http://localhost:3000/api`
by default.
