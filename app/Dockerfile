# Stage 1: Build
FROM node:24-alpine AS builder
WORKDIR /app

# Install ALL dependencies (including dev deps needed to compile)
COPY package*.json ./
RUN npm ci

# Copy source and compile TypeScript -> JavaScript
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# Stage 2: Runtime
FROM node:24-alpine
WORKDIR /app

# Install ONLY production dependencies (no typescript, ts-node, @types/*)
COPY package*.json ./
RUN npm ci --omit=dev

# Pull in just the compiled output from the builder stage
COPY --from=builder /app/dist ./dist

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD wget -qO- http://localhost:3000/health || exit 1

# Run as non-root for security
USER node

CMD ["node", "dist/main.js"]
