#!/bin/bash

DOMAIN=$1
PORT=$2
REPO=$3
ROOT_DIR="/home/ubuntu/apps/$DOMAIN"

if [ -z "$DOMAIN" ] || [ -z "$PORT" ] || [ -z "$REPO" ]; then
  echo "Uso: $0 dominio.com.br 3001 git@github.com:usuario/repo.git"
  exit 1
fi

echo "\n▶ Criando diretório: $ROOT_DIR"
mkdir -p "$ROOT_DIR"

echo "\n▶ Clonando repositório: $REPO"
git clone "$REPO" "$ROOT_DIR"

cd "$ROOT_DIR"

echo "\n▶ Instalando dependências e buildando..."
npm install --omit=dev
npm run build

echo "\n▶ Gerando ecosystem.config.js..."
cat > "$ROOT_DIR/ecosystem.config.js" <<EOF
module.exports = {
  apps: [
    {
      name: '$DOMAIN',
      cwd: '$ROOT_DIR',
      script: 'npm',
      args: 'start',
      interpreter: '/bin/bash',
      env: {
        NODE_ENV: 'production',
        PORT: $PORT
      },
    },
  ],
};
EOF

echo "\n▶ Inicializando PM2..."
pm2 start ecosystem.config.js
pm2 save

echo "\n▶ Criando configuração do NGINX..."
NGINX_PATH="/etc/nginx/sites-available/$DOMAIN"
cat > "$NGINX_PATH" <<EOF
server {
  listen 80;
  server_name $DOMAIN www.$DOMAIN;

  location / {
    proxy_pass http://127.0.0.1:$PORT;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
  }
}
EOF

ln -sf "$NGINX_PATH" /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

echo "\n▶ Emitindo certificado SSL com Certbot..."
certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos -m seuemail@dominio.com.br

echo "\n✅ Aplicação do domínio $DOMAIN disponível em: https://$DOMAIN"
