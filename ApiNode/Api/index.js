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
    const users = await prisma.usuario.findMany();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar usuários' });
  }
});

app.get('/api/statistics', async (req, res) => {
  console.log("Statistics")
  try {
    // Total de estudos e tarefas
    const totalEstudos = await prisma.estudo.count();
    const totalTarefas = await prisma.tarefa.count();

    // Tempo total estudado e metas atingidas
    const estudos = await prisma.estudo.findMany();
    const totalTempoEstudado = estudos.reduce((acc, estudo) => acc + (estudo.qtoTempo.getHours() * 3600 + estudo.qtoTempo.getMinutes() * 60 + estudo.qtoTempo.getSeconds()), 0);

    const tarefas = await prisma.tarefa.findMany();
    const totalTarefasRevisao = tarefas.filter(tarefa => tarefa.ehRevisao).length;

    // Total de notificações
    const totalNotificacoes = await prisma.notificacao.count();

    // Formatação de tempo total estudado para HH:MM:SS
    const hours = Math.floor(totalTempoEstudado / 3600);
    const minutes = Math.floor((totalTempoEstudado % 3600) / 60);
    const seconds = totalTempoEstudado % 60;
    const tempoEstudadoFormatado = `${hours}h ${minutes}m ${seconds}s`;

    console.log(
      totalEstudos + "|" + 
      totalTarefas + "|" +
      totalTarefasRevisao + "|" +
      tempoEstudadoFormatado + "|" +
      totalNotificacoes + "|")

    res.json({
      totalEstudos,
      totalTarefas,
      totalTarefasRevisao,
      tempoEstudadoFormatado,
      totalNotificacoes
    });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar estatísticas' });
  }
});


app.listen(port, () => {
  console.log('Servidor rodando na porta ' + port);
});

module.exports = app;
