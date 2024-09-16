require('dotenv').config(); 
const express = require('express');
const { PrismaClient } = require('@prisma/client');
const cors = require('cors');
const multer = require('multer');
const { Storage } = require('@google-cloud/storage');
const { v4: uuidv4 } = require('uuid');
const sharp = require('sharp');
const path = require('path');

const app = express(); 
const prisma = new PrismaClient();


const storage = new Storage({
  keyFilename: path.join(__dirname, 'codedrafts-401521-9a4d49f88703.json'), 
  projectId: 'codedrafts-401521',
});
const bucketName = 'imagesaprendize'; 

const upload = multer({
  storage: multer.memoryStorage(), // Armazena o arquivo na memória temporariamente
  limits: {
    fileSize: 5 * 1024 * 1024, // Limite de 5MB para o tamanho do arquivo
  },
});

const port = process.env.PORT || 3000;

const corsOptions = {
  origin: '*', 
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'], 
  allowedHeaders: ['Content-Type', 'Authorization'],
};
app.use(cors(corsOptions));

app.use(express.json());

app.get('/', (req, res) => {
  res.send('Hello world');
});

app.post('/api/upload-image', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      console.error('Nenhum arquivo enviado');
      return res.status(400).json({ error: 'Nenhum arquivo enviado' });
    }
    // Otimiza a imagem com sharp
    const optimizedImageBuffer = await sharp(req.file.buffer)
      .resize(800)
      .jpeg({ quality: 80 })
      .toBuffer();

    const uniqueFileName = `${uuidv4()}-${req.file.originalname}`;

    const bucket = storage.bucket(bucketName);
    const blob = bucket.file(uniqueFileName);
    const blobStream = blob.createWriteStream({
      resumable: false,
    });

    blobStream.on('error', (err) => {
      console.error('Erro ao criar o stream:', err);
      res.status(500).json({ error: err.message });
    });

    blobStream.on('finish', () => {
      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;
      res.status(200).json({ message: 'Upload bem-sucedido', url: publicUrl });
    });

    blobStream.end(optimizedImageBuffer);
  } catch (error) {
    console.error('Erro ao fazer upload da imagem:', error);
    res.status(500).json({ error: 'Erro ao fazer upload da imagem' });
  }
});

app.get('/api/users', async (req, res) => {
  try {
    const users = await prisma.usuario.findMany();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'DATABASE_URL: ' });
  }
});


app.get('/api/statistics', async (req, res) => {
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


app.get('/api/getNotifications', async (req, res) => {
  try {
    const userId = req.query.userId; // Pega o ID do usuário da query string
    if (!userId) {
      return res.status(400).json({ error: 'User ID is required' });
    }
    
    const notifications = await prisma.notificacao.findMany({
      where: { idUsuario: parseInt(userId, 10) } // Filtra as notificações pelo ID do usuário
    });
    
    console.log(notifications)
    res.json(notifications);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar notificações' });
  }
});


app.post('/api/existeUsuario', async (req, res) => {
  try {
    const { username } = req.body; 
    console.log("Verificando " + username + "...")
    if (!username) {
      return res.status(400).json({ error: 'Username é necessário.' });
    }

    const user = await prisma.usuario.findUnique({
      where: { username: username },
    });

    if (user) {
      console.log("Existe usuario")
      res.json({ success: true });
    } else {
      console.log("Nao existe usuario")
      res.json({ success: false });
    }
   
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Erro ao verificar usuário.' });
  }
});



app.get('/api/haveNewNotification', async (req, res) => {
  try {
    const userId = req.query.userId; 
    if (!userId) {
      return res.status(400).json({ error: 'User ID is required' });
    }
    
    const hasNewNotification = await prisma.notificacao.findFirst({
      where: {
        idUsuario: parseInt(userId, 10),
        lida: false,
      },
    });
    
    res.json({ hasNewNotification: !!hasNewNotification });
  } catch (error) {
    console.error('Error fetching notifications:', error);
    res.status(500).json({ error: 'Erro ao buscar notificações' });
  }
});


app.get('/api/login', async (req, res) => {
  try {
    const { nome, senha } = req.query;

    console.log("Tentando logar como " + nome + "...")

    if (!nome || !senha) {
      return res.json({ success: false, message: 'Nome de usuário e senha são obrigatórios.' });
    }

    const user = await prisma.usuario.findFirst({
      where: {
        AND: [
          { nome: nome },
          { senha: senha }
        ]
      }
    });

    console.log(user)

    if (user) {
      return res.json({ success: true });
    } else {
      return res.json({ success: false, message: 'Nome de usuário ou senha inválidos.' });
    }
  } catch (error) {
    console.error('Erro ao fazer login:', error);
    return res.status(500).json({ success: false, message: 'Erro interno do servidor.' });
  }
});


app.post('/api/signUp', async (req, res) => {
  const { username, nome, senha, linkFotoDePerfil, idColecaoInicial } = req.body;
  console.log({ username, nome, senha, linkFotoDePerfil, idColecaoInicial });

  if (!username || !nome || !senha) {
    return res.status(400).json({ error: 'Todos campos necessários.' });
  }

  const idColecaoInicialInt = idColecaoInicial ? parseInt(idColecaoInicial, 10) : null;

  if (isNaN(idColecaoInicialInt) && idColecaoInicial !== undefined) {
    return res.status(400).json({ error: 'idColecaoInicial deve ser um número válido.' });
  }

  try {
    const existingUser = await prisma.usuario.findUnique({
      where: { username },
    });

    if (existingUser) {
      console.log("Já existe!")
      return res.status(409).json({ error: 'Nome de usuário já está em uso.' });
    }

    console.log("Usuario nao existe... Pode criar!")

    const newUser = await prisma.usuario.create({
      data: {
        nome,
        username,
        senha,
        linkFotoDePerfil,
      },
    });

    if (idColecaoInicialInt) {
      await prisma.usuarioColecao.create({
        data: {
          idUsuario: newUser.idUsuario,
          idColecao: idColecaoInicialInt,
          cargo: '1',
        },
      });
    }

    console.log("Criado!");
    res.status(201).json({
      message: 'Usuário criado com sucesso!',
      user: { idUsuario: newUser.idUsuario, nome, username, senha, linkFotoDePerfil },
    });
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({ error: 'Erro ao criar usuário.' });
  }
});










app.get('/api/rankingUsers', async (req, res) => {
  try {
    const { idColecao, comBaseEmTempo } = req.query;
    console.log({ idColecao, comBaseEmTempo })

    if (!idColecao) {
      return res.status(400).json({ error: 'idColecao é obrigatório' });
    }

    const idColecaoInt = parseInt(idColecao, 10);
    if (isNaN(idColecaoInt)) {
      return res.status(400).json({ error: 'idColecao deve ser um número válido' });
    }

    // Obter todos os estudos relacionados à coleção e agrupar por usuário
    const estudos = await prisma.estudo.findMany({
      where: {
        Topico: {
          Materia: {
            Colecao: {
              idColecao: idColecaoInt,
            },
          },
        },
      },
      select: {
        idUsuario: true,
        qtoTempo: true,
        qtosExercicios: true,
      },
    });

    // Agregar dados por usuário
    const rankings = estudos.reduce((acc, estudo) => {
      if (!acc[estudo.idUsuario]) {
        acc[estudo.idUsuario] = { qtoTempo: 0, qtosExercicios: 0 };
      }
      acc[estudo.idUsuario].qtoTempo += estudo.qtoTempo || 0;
      acc[estudo.idUsuario].qtosExercicios += estudo.qtosExercicios || 0;
      return acc;
    }, {});

    // Ordenar usuários
    const sortedRankings = Object.entries(rankings).map(([idUsuario, { qtoTempo, qtosExercicios }]) => ({
      idUsuario: parseInt(idUsuario, 10),
      qtoTempo,
      qtosExercicios,
    }));

    if (comBaseEmTempo === 'true') {
      sortedRankings.sort((a, b) => b.qtoTempo - a.qtoTempo);
    } else {
      sortedRankings.sort((a, b) => b.qtosExercicios - a.qtosExercicios);
    }

    // Obter informações do usuário
    const userIds = sortedRankings.map(r => r.idUsuario);
    const users = await prisma.usuario.findMany({
      where: {
        idUsuario: {
          in: userIds,
        },
      },
    });

    // Mapear informações do usuário
    const userMap = new Map(users.map(user => [user.idUsuario, user]));
    const result = sortedRankings.map(ranking => ({
      ...ranking,
      user: userMap.get(ranking.idUsuario),
    }));

    console.log(result)

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});











app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});

module.exports = app;

