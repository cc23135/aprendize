require('dotenv').config({ path: '../.env' }); 
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
  keyFilename: path.join(__dirname, '..', 'codedrafts-401521-9a4d49f88703.json'), 
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
  res.send('Hello, World!');
});

app.post('/api/upload-image', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      console.error('Nenhum arquivo enviado');
      return res.status(400).json({ error: 'Nenhum arquivo enviado' });
    }
    console.log("Arquivo recebido:", req.file.originalname);

    // Otimiza a imagem com sharp
    const optimizedImageBuffer = await sharp(req.file.buffer)
      .resize(800)
      .jpeg({ quality: 80 })
      .toBuffer();

    console.log("Imagem otimizada");

    const uniqueFileName = `${uuidv4()}-${req.file.originalname}`;
    console.log('Nome único do arquivo:', uniqueFileName);
    console.log('Project ID:', storage.projectId);

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
      console.log('URL pública do arquivo:', publicUrl);
      res.status(200).json({ message: 'Upload bem-sucedido', url: publicUrl });
    });

    blobStream.end(optimizedImageBuffer);
  } catch (error) {
    console.error('Erro ao fazer upload da imagem:', error);
    res.status(500).json({ error: 'Erro ao fazer upload da imagem' });
  }
});



// signup
// envia nome, senha e depois coloca a coleção inicial

// 'https://i.pinimg.com/736x/ba/5a/70/ba5a7064b4b1f9b260df25901008e21c.jpg'
app.post("/signup", async(req, res) =>{
  try{
     await prisma.$queryRaw
    `
    INSERT INTO Aprendize.Usuario (nome, senha, linkFotoDePerfil)
    VALUES 
    ('${req.body.username}', '${req.body.password}', ${req.body.imagePath});


    -- INSERT INTO Aprendize.UsuarioColecao (idUsuario, idColecao, cargo)            TODO
    -- VALUES 
    -- (1, 1, '2'), -- Jo�o � Administrador da cole��o de Matem�tica B�sica
    -- (2, 2, '1'); -- Maria � Moderadora da cole��o de Python
    `;

    res.json({resposta: "Sucesso"})
  } catch(error){
    if (error.message.includes("UNIQUE em username e e-mail")){
      res.json({resposta: "Unique"})
    } else{
      res.json({resposta: "Erro"})
    }
  }
})


// verifica se o username informado existe, 
// se existir verifica se a senha informada é congruente
// login


// para signup, buscar se já existe um usuário com o nome informado
// procurar usuário



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
