# Stage 1: Build Vite app
FROM node:20-alpine AS build
WORKDIR /app

# ติดตั้ง dependencies สำหรับ build
COPY package*.json ./
RUN npm install --no-audit --no-fund

# build โปรเจกต์
COPY . .
RUN npm run build

# Stage 2: Run Express server สำหรับไฟล์ที่ build แล้ว
FROM node:20-alpine
WORKDIR /app

ENV NODE_ENV=production

# ติดตั้ง dependencies (รวม express) ใน runtime image
COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund

# copy build output + server.js เข้า runtime image
COPY --from=build /app/dist ./dist
COPY server.js ./server.js

EXPOSE 8081
CMD ["node", "server.js"]
