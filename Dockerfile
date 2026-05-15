# --- Stage 1: Build dashboard ---
FROM node:20-alpine AS dashboard-build
WORKDIR /app/dashboard
COPY dashboard/package.json dashboard/package-lock.json ./
RUN npm ci
COPY dashboard/ ./
COPY package.json /app/package.json
ARG VITE_INSFORGE_BASE_URL
ARG VITE_INSFORGE_ANON_KEY
RUN npm run build

# --- Stage 2: Nginx serves dashboard + proxies /functions to InsForge ---
FROM nginx:alpine
ARG VITE_INSFORGE_BASE_URL
COPY --from=dashboard-build /app/dashboard/dist /usr/share/nginx/html
RUN printf 'events { worker_connections 1024; }\n\
http {\n\
    include /etc/nginx/mime.types;\n\
    server {\n\
        listen 7680;\n\
        root /usr/share/nginx/html;\n\
        location /functions/ {\n\
            proxy_pass INSFORGE_URL_PLACEHOLDER/functions/;\n\
            proxy_set_header Host INSFORGE_HOST_PLACEHOLDER;\n\
            proxy_set_header X-Real-IP $remote_addr;\n\
            proxy_set_header Cookie $http_cookie;\n\
            proxy_set_header Authorization $http_authorization;\n\
            proxy_set_header apikey $http_apikey;\n\
            proxy_pass_header Set-Cookie;\n\
        }\n\
        location /api/ {\n\
            proxy_pass INSFORGE_URL_PLACEHOLDER/api/;\n\
            proxy_set_header Host INSFORGE_HOST_PLACEHOLDER;\n\
            proxy_set_header X-Real-IP $remote_addr;\n\
            proxy_set_header Cookie $http_cookie;\n\
            proxy_set_header Authorization $http_authorization;\n\
            proxy_pass_header Set-Cookie;\n\
        }\n\
        location / {\n\
            try_files $uri $uri/ /index.html;\n\
        }\n\
    }\n\
}\n' > /etc/nginx/nginx.conf && \
    INSFORGE_HOST=$(echo "${VITE_INSFORGE_BASE_URL}" | sed 's|https://||;s|/.*||') && \
    sed -i "s|INSFORGE_URL_PLACEHOLDER|${VITE_INSFORGE_BASE_URL}|g" /etc/nginx/nginx.conf && \
    sed -i "s|INSFORGE_HOST_PLACEHOLDER|${INSFORGE_HOST}|g" /etc/nginx/nginx.conf
EXPOSE 7680
CMD ["nginx", "-g", "daemon off;"]
