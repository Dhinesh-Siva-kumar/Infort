import 'dotenv/config';

function required(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

export const env = {
  nodeEnv: process.env['NODE_ENV'] ?? 'development',
  isProduction: process.env['NODE_ENV'] === 'production',
  port: Number(process.env['PORT'] ?? 3000),
  frontendOrigins: (process.env['FRONTEND_ORIGIN'] ?? 'http://localhost:4200')
    .split(',')
    .map((origin) => origin.trim()),
  db: {
    host: required('DB_HOST'),
    port: Number(process.env['DB_PORT'] ?? 5432),
    database: required('DB_NAME'),
    user: required('DB_USER'),
    password: required('DB_PASSWORD'),
  },
  jwt: {
    accessSecret: required('JWT_ACCESS_SECRET'),
    refreshSecret: required('JWT_REFRESH_SECRET'),
    accessExpiresIn: process.env['JWT_ACCESS_EXPIRES_IN'] ?? '15m',
    refreshExpiresIn: process.env['JWT_REFRESH_EXPIRES_IN'] ?? '30d',
  },
};
