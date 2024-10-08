require('dotenv').config(); 
const express = require('express');
const { PrismaClient } = require('@prisma/client');
const cors = require('cors');
const multer = require('multer');
const { Storage } = require('@google-cloud/storage');
const { v4: uuidv4 } = require('uuid');
const sharp = require('sharp');
const path = require('path');
const { Console } = require('console');

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

    const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;

    blobStream.on('finish', async () => {
      const { username } = req.body; // Supondo que username seja passado no corpo da requisição

      // Verifica se o username não está vazio
      if (username) {
          await prisma.$executeRaw`UPDATE Aprendize.Usuario SET linkFotoDePerfil = ${publicUrl} WHERE "username" = ${username}`; // Execute a consulta raw para atualizar a imagem
      }

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
    
    res.json(notifications);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar notificações' });
  }
});


app.post('/api/existeUsuario', async (req, res) => {
  const { username } = req.body;

  if (!username) return res.status(400).json({ error: 'Username é necessário.' });

  try {
    const userExists = await prisma.usuario.findFirst({ where: { username } });
    res.json({ success: !!userExists }); 
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Erro ao verificar usuário.' });
  }
});


app.post('/api/updateNome', async (req, res) => {
  const { username, novoNome } = req.body;
  try {
    await prisma.$executeRaw`UPDATE Aprendize.Usuario SET nome = ${novoNome} WHERE "username" = ${username}`;

    res.json({ message: 'Nome atualizado com sucesso' });
  } catch (error) {
    console.error('Erro ao atualizar o nome:', error);
    res.status(500).json({ error: 'Erro ao atualizar o nome' });
  }
});

app.post('/api/updateUsername', async (req, res) => {
  const { usernameAntigo, novoUsername } = req.body;

  try {
    await prisma.$executeRaw`UPDATE Aprendize.Usuario SET username = ${novoUsername} WHERE "username" = ${usernameAntigo}`;
    res.json({ message: 'Username atualizado com sucesso' });
  } catch (error) {
    console.error('Erro ao atualizar o username:', error);
    res.status(500).json({ error: 'Erro ao atualizar o username' });
  }
});

app.post('/api/updatePassword', async (req, res) => {
  const { username, novaSenha } = req.body;

  try {
    await prisma.$executeRaw`UPDATE Aprendize.Usuario SET senha = ${novaSenha} WHERE "username" = ${username}`;

    res.json({ message: 'Senha atualizada com sucesso' });
  } catch (error) {
    console.error('Erro ao atualizar a senha:', error);
    res.status(500).json({ error: 'Erro ao atualizar a senha' });
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
    const { username, senha } = req.query;


    if (!username || !senha) {
      return res.json({ success: false, message: 'Nome de usuário e senha são obrigatórios.' });
    }

    const user = await prisma.usuario.findFirst({
      where: {
        AND: [
          { username: username },
          { senha: senha }
        ]
      }
    });
    colecoes = null
    if(user){
      colecoes = await prisma.colecao.findMany({
        where: {
          idColecao: {
            in: await prisma.usuarioColecao.findMany({
              where: { idUsuario: user.idUsuario },
              select: { idColecao: true }
            }).then(results => results.map(result => result.idColecao))
          }
        }
      });
    }

    if (user) {
      return res.json({ success: true, user: user, colecoes: colecoes});
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

  if (!username || !nome || !senha) {
    return res.status(400).json({ error: 'Todos campos necessários.' });
  }

  const idColecaoInicialInt = idColecaoInicial ? parseInt(idColecaoInicial, 10) : null;

  if (isNaN(idColecaoInicialInt) && idColecaoInicial !== undefined) {
    return res.status(400).json({ error: 'idColecaoInicial deve ser um número válido.' });
  }

  try {
    const existingUser = await prisma.$queryRaw`SELECT * FROM Aprendize.Usuario WHERE "username" = ${username}`;

    if (existingUser.length > 0) {
      console.log("Já existe!");
      return res.status(409).json({ error: 'Nome de usuário já está em uso.' });
    }

    const newUser = await prisma.usuario.create({
      data: {
        nome,
        username,
        senha,
        linkFotoDePerfil,
      },
    });

    let colecoes = [];
    if (idColecaoInicialInt) {
      await prisma.usuarioColecao.create({
        data: {
          idUsuario: newUser.idUsuario,
          idColecao: idColecaoInicialInt,
          cargo: '1',
        },
      });

      colecoes = await prisma.colecao.findMany({
        where: { idColecao: idColecaoInicialInt }
      });
    }

    res.status(201).json({
      message: 'Usuário criado com sucesso!',
      user: { idUsuario: newUser.idUsuario, nome, username, senha, linkFotoDePerfil },
      colecoes, 
    });
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({ error: 'Erro ao criar usuário.' });
  }
});


app.get('/api/rankingUsers', async (req, res) => {
  try {
    const { idColecao, comBaseEmTempo } = req.query;

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

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});


app.get('/api/getColecoes', async (req, res) => {
  try {
    const colecoes = await prisma.colecao.findMany({
      include: {
        UsuarioColecao: {
          select: {
            idUsuarioColecao: true,
          }
        }
      }
    });
    
    const colecoesComEstudantes = colecoes.map(colecao => ({
      ...colecao,
      numEstudantes: colecao.UsuarioColecao.length 
    }));
    
    res.json({ colecoes: colecoesComEstudantes });
  } catch (error) {
    console.error('Error fetching colecoes:', error);
    res.status(500).json({ error: 'Erro ao buscar colecoes' });
  }
});

app.post('/api/getTopicsFromGroups', async (req, res) => {
  const { groupIds } = req.body;

  try {
    const topics = await prisma.topico.findMany({
      where: {
        Materia: {
          idColecao: {
            in: groupIds, 
          },
        },
      },
      include: {
        Materia: true, // Inclui informações da matéria se necessário
      },
    });

    console.log(topics)

    res.json(topics); 
  } catch (error) {
    console.error('Error fetching topics:', error);
    res.status(500).json({ error: 'Erro ao buscar tópicos' });
  }
});


app.post('/api/getGroupMembers', async (req, res) => {
  const { idColecao } = req.body.query; 

  try {
    const membros = await prisma.usuario.findMany({
      where: {
        UsuarioColecao: {
          some: {
            idColecao: idColecao,
          },
        },
      },
      include: {
        UsuarioColecao: {
          select: {
            idUsuarioColecao: true,
            idColecao: true,
          },
        },
      },
    });

    res.json({ membros: membros });
  } catch (error) {
    console.error('Error fetching membros:', error);
    res.status(500).json({ error: 'Erro ao buscar membros' });
  }
});




app.post('/api/getColecaoInfo', async (req, res) => {
  const { idColecao } = req.body.query; 

  try {
    const colecao = await prisma.colecao.findUnique({
      where: {
        idColecao: idColecao
      },
      include: {
        Materia: {
          select: {
            nome: true,
            capa: true,
            Topico: {
              select: {
                idTopico: true
              }
            }
          }
        }
      }
    });

    if (!colecao) {
      return res.status(404).json({ error: 'Coleção não encontrada' });
    }

    const materias = colecao.Materia.map(materia => ({
      nome: materia.nome,
      linkCapa: materia.capa,
      quantidadeTopicos: materia.Topico.length,
    }));

    res.json({
      colecao: {
        ...colecao,
        materias
      }
    });
    
  } catch (error) {
    console.error('Error fetching colecao:', error);
    res.status(500).json({ error: 'Erro ao buscar coleção' });
  }
});

app.post('/api/criarTarefa', async (req, res) => {
  const { idUsuario, data, subjects } = req.body; // Extrair dados do corpo da requisição

  try {
    console.log(subjects[1]);

    const tarefas = subjects.map(subject => {
      const tempoDeEstudo = subject.tempoDeEstudo === 0 ? null : new Date(new Date(data).getTime() + subject.tempoDeEstudo * 60000); // Converte minutos em milissegundos

      return {
        idUsuario: idUsuario,
        idTopico: subject.idTopico,
        metaExercicios: subject.exercicios === 0 ? null : subject.exercicios,
        metaTempo: tempoDeEstudo ? tempoDeEstudo.toISOString() : null, // Formato ISO 8601 se não for null
        dataTarefa: new Date(data).toISOString(), // Formato ISO 8601 para dataTarefa
        ehRevisao: false,
      };
    });

    // Inserir tarefas utilizando createMany
    await prisma.tarefa.createMany({
      data: tarefas,
    });

    res.status(200).json({ message: 'Tarefas criadas com sucesso!' });
  } catch (error) {
    console.error('Erro ao criar as tarefas:', error);
    res.status(500).json({ error: 'Erro ao criar as tarefas' });
  }
});


app.post('/api/getTarefasDoDia', async (req, res) => {
  const { username, dataTarefa } = req.body; 

  if (!username || !dataTarefa) {
    return res.status(400).json({ error: 'username e dataTarefa são obrigatórios.' });
  }

  try {
    const usuario = await prisma.$queryRaw 
    `SELECT * FROM Aprendize.usuario  WHERE username = ${username}
    `;

    if (!usuario) {
      return res.status(404).json({ error: 'Usuário não encontrado.' });
    }

    const idUsuario = usuario.idUsuario;
    const data = new Date(dataTarefa);

    if (isNaN(data.getTime())) {
      return res.status(400).json({ error: 'dataTarefa deve ser uma data válida.' });
    }

    const tarefas = await prisma.tarefa.findMany({
      where: {
        idUsuario: idUsuario,
        dataTarefa: {
          equals: data,
        },
      },
      include: {
        Topico: {
          select: {
            nome: true, 
            idTopico: true
          },
        },
      },
    });

    const tarefasComTopicos = tarefas.map(tarefa => ({
      ...tarefa,
      topicoNome: tarefa.Topico.nome, 
    }));

    res.json(tarefasComTopicos); 
  } catch (error) {
    console.error('Error fetching tasks:', error);
    res.status(500).json({ error: 'Erro ao buscar tarefas' });
  }
});


<<<<<<< HEAD
app.post('/api/criarEstudo', async (req, res) => {
  const { idTarefa, idTopico, idUsuario, metaExercicios, metaTempo, qtosExercicios, qtosExerciciosAcertados, qtoTempo, dataEstudo } = req.body;

  try {
    await prisma.$transaction(async (prisma) => {
      await prisma.tarefa.delete({
        where: {
          idTarefa: idTarefa,
        },
      });

      const novoEstudo = await prisma.estudo.create({
        data: {
          idTopico,
          idUsuario,
          metaExercicios,
          metaTempo,
          qtosExercicios,
          qtosExerciciosAcertados,
          qtoTempo,
          dataEstudo,
        },
      });

      return novoEstudo;
    });

    res.status(201).json({ message: 'Estudo criado e tarefa deletada com sucesso' });
  } catch (error) {
    console.error('Error creating estudo and deleting tarefa:', error);
    res.status(500).json({ error: 'Erro ao criar estudo e deletar tarefa' });
  }
});








=======
>>>>>>> 1f1a6c3f7879e4e30e8c9861668f37af746a8299
app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});

module.exports = app;

