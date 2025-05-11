# 🚀 Script de Configuração Automática de Domínio

Este script automatiza todo o processo de deploy de uma aplicação Node.js/Next.js para um novo domínio em uma instância Linux com NGINX + PM2 + Certbot.

## ✅ Funcionalidades
- Criação da estrutura de diretório
- Clonagem do repositório
- Instalação e build do projeto
- Criação automática do `ecosystem.config.js` para PM2
- Configuração do NGINX com proxy reverso
- Emissão automática de certificado SSL com Certbot
- Inicialização do app com PM2

---

## 📦 Pré-requisitos no servidor

- Node.js e npm instalados
- PM2 instalado globalmente (`npm i -g pm2`)
- NGINX instalado
- Certbot com plugin NGINX (`sudo apt install certbot python3-certbot-nginx`)
- Porta 80 e 443 liberadas no firewall da instância
- Domínio apontado corretamente para o IP da instância

---

## ⚙️ Como usar

```bash
chmod +x setup-domain.sh
./setup-domain.sh dominio.com.br 3001 git@github.com:usuario/repositorio.git
```

- `dominio.com.br`: o domínio a ser configurado
- `3001`: porta local onde a aplicação rodará
- `git@...`: URL do repositório contendo o projeto (Next.js, Node.js, etc.)

---

## 📁 Exemplo de estrutura final criada

```
/home/ubuntu/apps/dominio.com.br/
├── .next
├── public
├── node_modules
├── package.json
├── ecosystem.config.js
```

---

## 📌 Dica adicional
Se quiser reaproveitar este script para múltiplos projetos, mantenha-o versionado em um repositório separado de utilitários de DevOps.

---

Criado com ❤️ por Reginaldo Gomes
