# -------- Stage 1: Build --------
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies only
COPY package*.json ./
RUN npm install --frozen-lockfile

# Copy the rest of the code
COPY . .

# Build the Next.js app
RUN npm run build

# -------- Stage 2: Run --------
FROM node:18-alpine AS runner

WORKDIR /app

# Only copy production node_modules & build output
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Set environment to production
ENV NODE_ENV=production

EXPOSE 3000

# Start Next.js
CMD ["npm", "start"]
