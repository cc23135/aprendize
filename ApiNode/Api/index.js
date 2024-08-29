require('dotenv').config({ path: '../.env' }); // Ajuste o caminho se necessário
const express = require('express');
const { PrismaClient } = require('@prisma/client');
const cors = require('cors');

const app = express(); // Inicialização do Express
const prisma = new PrismaClient();

const port = process.env.PORT || 3000;

const corsOptions = {
  origin: '*', 
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'], 
  allowedHeaders: ['Content-Type', 'Authorization'],
};
app.use(cors(corsOptions));

app.use(express.json());

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.get('/api/users', async (req, res) => {
  try {
    const users = await prisma.usuario.findMany(); // Ajuste o nome do modelo para o seu caso
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar usuários' });
  }
});

app.listen(port, () => {
  console.log('Servidor rodando na porta ' + port);
});

module.exports = app;
