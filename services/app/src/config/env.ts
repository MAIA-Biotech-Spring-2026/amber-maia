/**
 * Environment configuration with validation
 * Ensures required env vars are set at startup
 * 
 * Note: dotenv is loaded in index.ts before this module
 */

function requireEnv(key: string): string {
  const value = process.env[key];
  if (!value) {
    throw new Error(`Missing required environment variable: ${key}. Check your .env file.`);
  }
  return value;
}

function optionalEnv(key: string, defaultValue?: string): string | undefined {
  return process.env[key] || defaultValue;
}

export const config = {
  // Privy
  privy: {
    appId: requireEnv('PRIVY_APP_ID'),
    appSecret: requireEnv('PRIVY_APP_SECRET'),
  },

  // Database
  database: {
    url: optionalEnv('DATABASE_URL'),
  },

  // Storage
  storage: {
    bucket: optionalEnv('STORAGE_BUCKET'),
  },

  // Server
  server: {
    port: Number(optionalEnv('PORT', '8080')),
    host: optionalEnv('HOST', '0.0.0.0'),
  },

  // Environment
  env: optionalEnv('NODE_ENV', 'development'),
  isDevelopment: optionalEnv('NODE_ENV', 'development') === 'development',
  isProduction: optionalEnv('NODE_ENV', 'development') === 'production',
};

// Validate Privy config at startup
if (!config.isDevelopment) {
  // In production, Privy must be configured
  requireEnv('PRIVY_APP_ID');
  requireEnv('PRIVY_APP_SECRET');
}

