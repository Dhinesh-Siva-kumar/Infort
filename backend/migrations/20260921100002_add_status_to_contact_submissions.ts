import type { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  await knex.schema.alterTable('contact_submissions', (table) => {
    table.string('status', 20).notNullable().defaultTo('NEW');
    table.timestamp('updated_at', { useTz: true }).notNullable().defaultTo(knex.fn.now());
    table.index('status');
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.alterTable('contact_submissions', (table) => {
    table.dropColumn('status');
    table.dropColumn('updated_at');
  });
}
