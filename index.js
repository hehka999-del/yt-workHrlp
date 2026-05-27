const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const app = express();

// Настраиваем прокси на YouTube
app.use('/', createProxyMiddleware({
  target: 'https://www.youtube.com',
  changeOrigin: true,
  headers: {
    'User-Agent': 'Mozilla/5.0',
  },
  onProxyRes: (proxyRes, req, res) => {
    // Убираем запрет на встройку в iframe (на всякий случай)
    delete proxyRes.headers['x-frame-options'];
    delete proxyRes.headers['content-security-policy'];
  },
}));

// Запускаем сервер на порту, который даст Render (или 3000)
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Proxy running on port ${port}`));