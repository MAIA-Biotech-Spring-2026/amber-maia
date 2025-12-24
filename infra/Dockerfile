FROM node:20-slim

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm@9

# Copy root package files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY tsconfig.base.json ./

# Copy service package files
COPY services/app/package.json ./services/app/

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code
COPY services/app ./services/app

# Build the app
WORKDIR /app/services/app
RUN pnpm build

# Expose port (Cloud Run default)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Run the app
CMD ["node", "dist/index.js"]

