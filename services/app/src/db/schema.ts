import { pgTable, serial, text, timestamp, jsonb, varchar, integer, pgEnum } from 'drizzle-orm/pg-core';

export const relationshipTypeEnum = pgEnum('relationship_type', ['parent', 'sibling', 'partner', 'child', 'other']);
export const insightPriorityEnum = pgEnum('insight_priority', ['high', 'medium', 'low']);
export const insightTopicEnum = pgEnum('insight_topic', ['health', 'connection', 'memory']);
export const runStatusEnum = pgEnum('run_status', ['queued', 'running', 'succeeded', 'failed']);

// Users (linked to Privy)
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  privyUserId: varchar('privy_user_id', { length: 255 }).notNull().unique(),
  didPrimary: varchar('did_primary', { length: 255 }),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
});

// Persons (family members)
export const persons = pgTable('persons', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => users.id),
  name: text('name').notNull(),
  dob: timestamp('dob', { withTimezone: true }),
  email: varchar('email', { length: 255 }),
  cNFT: varchar('c_nft', { length: 255 }), // Solana compressed NFT mint address
  metadata: jsonb('metadata'),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).defaultNow().notNull(),
});

// Wallets (Solana addresses)
export const wallets = pgTable('wallets', {
  id: serial('id').primaryKey(),
  personId: integer('person_id').references(() => persons.id).notNull(),
  chain: varchar('chain', { length: 50 }).default('solana').notNull(),
  address: varchar('address', { length: 255 }).notNull(),
  verified: timestamp('verified', { withTimezone: true }),
  labels: jsonb('labels'),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
});

// Relationships (family graph edges)
export const relationships = pgTable('relationships', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => users.id),
  fromId: integer('from_id').references(() => persons.id).notNull(),
  toId: integer('to_id').references(() => persons.id).notNull(),
  type: relationshipTypeEnum('type').notNull(),
  strength: integer('strength').default(50), // 0-100, AI-calculated
  evidenceHash: varchar('evidence_hash', { length: 255 }),
  s3Uri: varchar('s3_uri', { length: 512 }),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
});

// Pipeline definitions
export const pipelineDefs = pgTable('pipeline_defs', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => users.id),
  name: varchar('name', { length: 255 }).notNull(),
  def: jsonb('def').notNull(), // Pipeline DAG definition
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
});

// Pipeline runs
export const pipelineRuns = pgTable('pipeline_runs', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => users.id),
  defId: integer('def_id').references(() => pipelineDefs.id),
  status: runStatusEnum('status').notNull(),
  log: jsonb('log').$type<string[]>().default([]),
  result: jsonb('result'),
  startedAt: timestamp('started_at', { withTimezone: true }).defaultNow().notNull(),
  endedAt: timestamp('ended_at', { withTimezone: true }),
});

// Insight cards (AI-generated feed items)
export const insights = pgTable('insights', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => users.id),
  priority: insightPriorityEnum('priority').notNull(),
  topic: insightTopicEnum('topic').notNull(),
  content: text('content').notNull(),
  sources: jsonb('sources').$type<string[]>().default([]),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
});

// VC records (verifiable credentials)
export const vcRecords = pgTable('vc_records', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => users.id).notNull(),
  issuer: varchar('issuer', { length: 255 }).notNull(),
  schemaId: varchar('schema_id', { length: 255 }),
  s3Uri: varchar('s3_uri', { length: 512 }),
  contentHash: varchar('content_hash', { length: 255 }).notNull(),
  status: varchar('status', { length: 50 }).default('active'),
  issuedAt: timestamp('issued_at', { withTimezone: true }).defaultNow().notNull(),
  revokedAt: timestamp('revoked_at', { withTimezone: true }),
});

// Anchors (Solana on-chain anchors)
export const anchors = pgTable('anchors', {
  id: serial('id').primaryKey(),
  userId: integer('user_id').references(() => users.id),
  kind: varchar('kind', { length: 100 }), // 'graph', 'pipeline', 'vc'
  contentHash: varchar('content_hash', { length: 255 }).notNull(),
  chainTx: varchar('chain_tx', { length: 255 }), // Solana transaction signature
  uri: varchar('uri', { length: 512 }),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
});


