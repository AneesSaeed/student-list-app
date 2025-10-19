# ---------- build ----------
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build    # outputs to /app/dist

# ---------- run ----------
FROM node:20-alpine
WORKDIR /srv/app
COPY --from=build /app/dist ./dist
RUN npm i -g serve   # tiny static server
EXPOSE 80
CMD ["serve", "-s", "dist", "-l", "80"]
