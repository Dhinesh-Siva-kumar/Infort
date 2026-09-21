import type { Knex } from 'knex';

// Scaffolding for future push notifications (FCM/APNs). No push send is
// wired up yet — there is no Firebase project configured for this app.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable('device_tokens', (table) => {
    table.increments('id').primary();
    table.integer('user_id').unsigned().notNullable().references('id').inTable('users').onDelete('CASCADE');
    table.string('token', 255).notNullable().unique();
    table.string('platform', 10).notNullable(); // 'android' | 'ios'
    table.timestamp('created_at', { useTz: true }).notNullable().defaultTo(knex.fn.now());
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists('device_tokens');
}
