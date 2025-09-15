FROM node:20-slim
WORKDIR /app

# Install CA certs (good practice) and keep image small
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm ci

COPY . .
# Generate Prisma client
RUN npx prisma generate

EXPOSE 3000

# Run migrations, then try common start scripts (start → dev → fallback to dist)
CMD sh -lc "npx prisma migrate deploy && (npm run start || npm run dev || node dist/api/main.js)"
