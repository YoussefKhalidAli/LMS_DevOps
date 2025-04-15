FROM node:18 as builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

FROM nginx:alpine
COPY --from=builder /app/dist/ailms/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
