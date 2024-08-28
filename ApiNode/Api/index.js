require('dotenv').config();

const express = require('express');
const app = express();
console.log(process.env.PORT)
const port = process.env.PORT || 3000;

app.use(express.json());

// Rota de exemplo
app.get('/api/hello', (req, res) => {
  res.send('Hello, World! ' + port);
});

app.get('/*', (req, res) => {
  res.send('Opa ' + port);
});

module.exports = app;