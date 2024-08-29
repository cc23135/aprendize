require('dotenv').config({ path: '../.env' });
const express = require('express');
const { PrismaClient } = require('@prisma/client');

const app = express();
const prisma = new PrismaClient();

const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', async (req, res) => {
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
