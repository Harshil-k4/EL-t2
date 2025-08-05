#Build Stage
FROM node:18-alpine AS builder
WORKDIR /app

#Cp package files
COPY package*.json ./
RUN npm ci --production

COPY . .

#Production Stage
FROM node:18-alpine
WORKDIR /app

# Cp modules buildrs
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/src ./src

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q --spider http://localhost:3000/ || exit 1

CMD [ "npm", "start" ]