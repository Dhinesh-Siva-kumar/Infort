# Infort Backend

Express + TypeScript API backing the contact form on the Infort marketing site,
using Knex + PostgreSQL for persistence.

## Request flow

```
Request → helmet/cors/json → rate limit (contact route only) → validate (zod)
        → controller → service → repository → PostgreSQL
        → standardized JSON response
```

## Setup

```bash
cp .env.example .env   # then fill in DATABASE_URL etc.
npm install
npm run migrate        # creates the contact_submissions table
npm run dev            # starts on http://localhost:3000
```

## API

`POST /api/contact`

```json
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "phone": "9876543210",
  "service": "web-development",
  "message": "Tell us about your project..."
}
```

Responses follow `{ success, data, message }` on success and
`{ success: false, message, code, errors }` on failure.

`GET /health` — liveness check.

## Scripts

- `npm run dev` — run with hot reload (ts-node-dev)
- `npm run build` / `npm start` — compile to `dist/` and run compiled JS
- `npm run migrate` / `migrate:make` / `migrate:rollback` — Knex migrations
