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

    if (!req.query.userId) {
      return res.status(401).json({ error: 'User not authenticated' });
    }
    
    const userId = req.query.userId; // Assuming you have user information in the request
    // Call stored procedures and retrieve data

    const exerciciosFeitosSemanal = await prisma.$executeRaw`EXEC GetTotalExerciciosLastFourWeeks @idUsuario = ${userId}`;
    const exerciciosFeitosDiario = await prisma.$executeRaw`EXEC GetTotalExerciciosLastSevenDays @idUsuario = ${userId}`;
    // const exerciciosFeitosMensal = await prisma.$executeRaw`EXEC GetExerciciosFeitosMensal @idUsuario = ${userId}`;
    const tempoGastoTotalSemanal = await prisma.$executeRaw`EXEC GetTotalTempoLastFourWeeks @idUsuario = ${userId}`;
    const tempoGastoTotalDiario = await prisma.$executeRaw`EXEC GetTotalTempoLastSevenDays @idUsuario = ${userId}`;
    // const tempoGastoTotalMensal = await prisma.$executeRaw`EXEC GetTempoGastoTotalMensal @idUsuario = ${userId}`;
    
    const nomesMateriasExerciciosSemanal = await prisma.$executeRaw`EXEC GetNomesMateriasExerciciosSemanal @idUsuario = ${userId}`;
    const exerciciosFeitosPorMateriaSemanal = await prisma.$executeRaw`EXEC GetExerciciosFeitosPorMateriaSemanal @idUsuario = ${userId}`;
    const nomesMateriasExerciciosMensal = await prisma.$executeRaw`EXEC GetNomesMateriasExerciciosMensal @idUsuario = ${userId}`;
    const exerciciosFeitosPorMateriaMensal = await prisma.$executeRaw`EXEC GetExerciciosFeitosPorMateriaMensal @idUsuario = ${userId}`;
    
    const nomesMateriasTempoSemanal = await prisma.$executeRaw`EXEC GetNomesMateriasTempoSemanal @idUsuario = ${userId}`;
    const tempoGastoPorMateriaSemanal = await prisma.$executeRaw`EXEC GetTempoGastoPorMateriaSemanal @idUsuario = ${userId}`;
    const nomesMateriasTempoMensal = await prisma.$executeRaw`EXEC GetNomesMateriasTempoMensal @idUsuario = ${userId}`;
    const tempoGastoPorMateriaMensal = await prisma.$executeRaw`EXEC GetTempoGastoPorMateriaMensal @idUsuario = ${userId}`;
    
    const nomesColecoesExerciciosSemanal = await prisma.$executeRaw`EXEC GetNomesColecoesExerciciosSemanal @idUsuario = ${userId}`;
    const exerciciosFeitosPorColecaoSemanal = await prisma.$executeRaw`EXEC GetExerciciosFeitosPorColecaoSemanal @idUsuario = ${userId}`;
    const nomesColecoesExerciciosMensal = await prisma.$executeRaw`EXEC GetNomesColecoesExerciciosMensal @idUsuario = ${userId}`;
    const exerciciosFeitosPorColecaoMensal = await prisma.$executeRaw`EXEC GetExerciciosFeitosPorColecaoMensal @idUsuario = ${userId}`;
    
    const nomesColecoesTempoSemanal = await prisma.$executeRaw`EXEC GetNomesColecoesTempoSemanal @idUsuario = ${userId}`;
    const tempoGastoPorColecaoSemanal = await prisma.$executeRaw`EXEC GetTempoGastoPorColecaoSemanal @idUsuario = ${userId}`;
    const nomesColecoesTempoMensal = await prisma.$executeRaw`EXEC GetNomesColecoesTempoMensal @idUsuario = ${userId}`;
    const tempoGastoPorColecaoMensal = await prisma.$executeRaw`EXEC GetTempoGastoPorColecaoMensal @idUsuario = ${userId}`;

    console.log(tempoGastoPorColecaoMensal + "aaaaaa")

    res.json({
      exerciciosFeitosSemanal,
      exerciciosFeitosDiario,
      exerciciosFeitosMensal,
      tempoGastoTotalSemanal,
      tempoGastoTotalDiario,
      tempoGastoTotalMensal,
      nomesMateriasExerciciosSemanal,
      exerciciosFeitosPorMateriaSemanal,
      nomesMateriasExerciciosMensal,
      exerciciosFeitosPorMateriaMensal,
      nomesMateriasTempoSemanal,
      tempoGastoPorMateriaSemanal,
      nomesMateriasTempoMensal,
      tempoGastoPorMateriaMensal,
      nomesColecoesExerciciosSemanal,
      exerciciosFeitosPorColecaoSemanal,
      nomesColecoesExerciciosMensal,
      exerciciosFeitosPorColecaoMensal,
      nomesColecoesTempoSemanal,
      tempoGastoPorColecaoSemanal,
      nomesColecoesTempoMensal,
      tempoGastoPorColecaoMensal,
    });
  } catch (error) {
    console.error(error);
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
            idMateria: true,
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
      idMateria: materia.idMateria,
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


app.post('/api/getMateriaInfo', async (req, res) => {
  const { idMateria } = req.body.query; 

  try {
    const materia = await prisma.materia.findUnique({
      where: {
        idMateria: idMateria
      },
      include: {
        Topico: { 
          select: {
            idTopico: true,
            nome: true,
            ordem: true
          }
        }
      }
    });

    if (!materia) {
      return res.status(404).json({ error: 'Matéria não encontrada' });
    }

    const response = {
      idMateria: materia.idMateria,
      nome: materia.nome,
      linkCapa: materia.capa,
      topicos: materia.Topico // Array de tópicos
    };

    res.json(response);
    
  } catch (error) {
    console.error('Error fetching materia:', error);
    res.status(500).json({ error: 'Erro ao buscar matéria' });
  }
});


app.post('/api/getTarefasDoDia', async (req, res) => {
  const { username, dataTarefa } = req.body; 

  if (!username || !dataTarefa) {
    return res.status(400).json({ error: 'username e dataTarefa são obrigatórios.' });
  }

  try {
    // Usando query raw para buscar o usuário
    const usuario = await prisma.$queryRaw`
      SELECT *
      FROM Aprendize.Usuario
      WHERE username = ${username}
    `;

    if (usuario.length === 0) {
      return res.status(404).json({ error: 'Usuário não encontrado.' });
    }

    const idUsuario = usuario[0].idUsuario; // Acessa o primeiro (e único) usuário encontrado
    const data = new Date(dataTarefa);

    if (isNaN(data.getTime())) {
      return res.status(400).json({ error: 'dataTarefa deve ser uma data válida.' });
    }
    const tarefas = await prisma.tarefa.findMany({
      where: {
        idUsuario: idUsuario, // idUsuario obtido do usuário
        dataTarefa: {
          equals: data, // dataTarefa recebida no corpo da requisição
        },
      },
      include: {
        Topico: {
          select: {
            nome: true, 
            idTopico: true,
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


app.get('/api/getEstudos', async (req, res) => {
  const { idUsuario } = req.query; 
  try {
    const estudos = await prisma.$queryRaw`
      SELECT Aprendize.Estudo.*, Aprendize.Topico.nome AS topicoNome, Aprendize.Materia.nome AS materiaNome 
      FROM Aprendize.Estudo
      JOIN 
        Aprendize.Topico ON Aprendize.Estudo.idTopico = Aprendize.Topico.idTopico
      JOIN 
        Aprendize.Materia ON Aprendize.Topico.idMateria = Aprendize.Materia.idMateria
      WHERE 
        Aprendize.Estudo.idUsuario = ${parseInt(idUsuario, 10)} 
      ORDER BY Aprendize.Estudo.dataEstudo ASC
    `;


    res.status(200).json(estudos);
  } catch (error) {
    console.error('Erro ao buscar estudos:', error);
    res.status(500).json({ error: 'Erro ao buscar estudos' });
  }
});


function converterMinutosParaIso(minutos) {
  const dataBase = new Date('1970-01-01T00:00:00Z');
  dataBase.setMinutes(minutos);
  return dataBase.toISOString(); 
}


app.post('/api/criarEstudo', async (req, res) => {
  const { idTarefa, idTopico, username, metaExercicios, metaTempo, qtosExercicios, qtosExerciciosAcertados, qtoTempo, dataEstudo } = req.body;

  const user = await prisma.usuario.findUnique({ where: { username } });
  if (!user) {
    return res.status(404).json({ error: 'Usuário não encontrado' });
  }

  try {
    await prisma.$transaction(async (prisma) => {
      await prisma.tarefa.delete({
        where: {
          idTarefa: idTarefa,
        },
      });

      const formattedMetaTempo = converterMinutosParaIso(metaTempo);
      const formattedQtoTempo = converterMinutosParaIso(qtoTempo);

      const novoEstudo = await prisma.estudo.create({
        data: {
          idTopico,
          idUsuario: user.idUsuario,
          metaExercicios,
          metaTempo: formattedMetaTempo,
          qtosExercicios,
          qtosExerciciosAcertados,
          qtoTempo: formattedQtoTempo,
          dataEstudo: new Date(dataEstudo),
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






app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});

module.exports = app;

