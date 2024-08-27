require('dotenv').config();

const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Rota de exemplo
app.get('/api/hello', (req, res) => {
  res.send('Hello, World!');
});

// Inicia o servidor
app.listen(port, () => {
  console.log(`API rodando na porta ${port}`);
});