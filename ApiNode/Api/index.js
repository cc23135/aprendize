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



app.get('/api/users', async (req, res) => {
  try {
    const users = await prisma.usuario.findMany(); 
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar usuários' });
  }
});

app.listen(port, () => {
  console.log('Servidor rodando na porta ' + port);
});

module.exports = app;
