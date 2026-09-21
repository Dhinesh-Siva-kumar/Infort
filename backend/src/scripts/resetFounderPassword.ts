/**
 * One-time helper to reset the Founder account's password.
 * Usage: npm run reset-founder-password -- --email founder@infort.in --password "..."
 */
import bcrypt from 'bcryptjs';
import { db } from '../config/database';

function getArg(flag: string): string | undefined {
  const index = process.argv.indexOf(flag);
  return index !== -1 ? process.argv[index + 1] : undefined;
}

async function main() {
  const email = getArg('--email')?.toLowerCase();
  const password = getArg('--password');

  if (!email || !password) {
    console.error('Usage: npm run reset-founder-password -- --email founder@infort.in --password "..."');
    process.exit(1);
  }

  const user = await db('users').where({ email }).first();
  if (!user) {
    console.error(`No user found with email ${email}.`);
    process.exit(1);
  }

  const passwordHash = await bcrypt.hash(password, 12);
  await db('users').where({ email }).update({ password_hash: passwordHash, updated_at: db.fn.now() });

  console.log(`Password reset for ${email}.`);
  await db.destroy();
}

main().catch(async (err) => {
  console.error(err);
  await db.destroy();
  process.exit(1);
});
