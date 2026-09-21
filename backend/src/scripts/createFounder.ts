/**
 * One-time setup script to create the Founder account.
 * Usage: npm run create-founder -- --name "Samuvel" --email founder@infort.in --password "..." --phone "+91..."
 */
import bcrypt from 'bcryptjs';
import { db } from '../config/database';

function getArg(flag: string): string | undefined {
  const index = process.argv.indexOf(flag);
  return index !== -1 ? process.argv[index + 1] : undefined;
}

async function main() {
  const name = getArg('--name');
  const email = getArg('--email')?.toLowerCase();
  const password = getArg('--password');
  const phone = getArg('--phone') ?? null;

  if (!name || !email || !password) {
    console.error('Usage: npm run create-founder -- --name "Samuvel" --email founder@infort.in --password "..."');
    process.exit(1);
  }

  const existing = await db('users').where({ email }).first();
  if (existing) {
    console.error(`A user with email ${email} already exists.`);
    process.exit(1);
  }

  const passwordHash = await bcrypt.hash(password, 12);

  await db('users').insert({
    name,
    email,
    password_hash: passwordHash,
    phone,
    role: 'FOUNDER',
    is_active: true,
  });

  console.log(`Founder account created for ${email}.`);
  await db.destroy();
}

main().catch(async (err) => {
  console.error(err);
  await db.destroy();
  process.exit(1);
});
