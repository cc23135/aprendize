create schema Aprendize

-- CRIA��O DE TABELAS

CREATE TABLE Aprendize.Usuario (
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    senha VARCHAR(30) NOT NULL,
    linkFotoDePerfil VARCHAR(100) NOT NULL
);

CREATE TABLE Aprendize.Colecao (
    idColecao INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(500),
    linkImagem VARCHAR(500) NOT NULL,
    idCriador INT FOREIGN KEY REFERENCES Aprendize.Usuario(idUsuario) NOT NULL,
    dataCriacao DATE NOT NULL
);

CREATE TABLE Aprendize.Materia (
    idMateria INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    capa VARCHAR(100) NOT NULL,
    idColecao INT FOREIGN KEY REFERENCES Aprendize.Colecao(idColecao)
);

CREATE TABLE Aprendize.Topico (
    idTopico INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ordem INT NOT NULL,
    idMateria INT FOREIGN KEY REFERENCES Aprendize.Materia(idMateria) NOT NULL
);

CREATE TABLE Aprendize.DiaRotina (
    idDiaRotina INT IDENTITY(1,1) PRIMARY KEY,
    idMateria INT FOREIGN KEY REFERENCES Aprendize.Materia(idMateria) NOT NULL,
    idUsuario INT FOREIGN KEY REFERENCES Aprendize.Usuario(idUsuario) NOT NULL,
    metaExercicios INT,
    metaTempo TIME,
    diaDaSemana INT CHECK(diaDaSemana BETWEEN 1 AND 7) NOT NULL
);

CREATE TABLE Aprendize.Estudo (
    idEstudo INT IDENTITY(1,1) PRIMARY KEY,
    idTopico INT FOREIGN KEY REFERENCES Aprendize.Topico(idTopico) NOT NULL,
    idUsuario INT FOREIGN KEY REFERENCES Aprendize.Usuario(idUsuario) NOT NULL,
    metaExercicios INT,
    metaTempo TIME,
    qtosExercicios INT,
    qtosExerciciosAcertados INT,
    qtoTempo TIME NOT NULL,
    dataEstudo DATE NOT NULL
);


CREATE TABLE Aprendize.Tarefa (
    idTarefa INT IDENTITY(1,1) PRIMARY KEY,
    idTopico INT FOREIGN KEY REFERENCES Aprendize.Topico(idTopico) NOT NULL,
    idUsuario INT FOREIGN KEY REFERENCES Aprendize.Usuario(idUsuario) NOT NULL,
    metaExercicios INT,
    metaTempo TIME,
    dataTarefa DATE NOT NULL,
    ehRevisao BIT NOT NULL
);

CREATE TABLE Aprendize.Notificacao (
    idNotificacao INT IDENTITY(1,1) PRIMARY KEY,
    conteudo VARCHAR(300) NOT NULL,
    idUsuario INT FOREIGN KEY REFERENCES Aprendize.Usuario(idUsuario) NOT NULL,
    lida BIT NOT NULL,
);

CREATE TABLE Aprendize.UsuarioColecao (
    idUsuarioColecao INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT FOREIGN KEY REFERENCES Aprendize.Usuario(idUsuario) NOT NULL,
    idColecao INT FOREIGN KEY REFERENCES Aprendize.Colecao(idColecao) NOT NULL,
    cargo CHAR(1) CHECK(cargo IN ('0', '1', '2')) -- 0: Membro, 1: Moderador, 2: Administrador
);

CREATE TABLE Aprendize.Mensagem (
    idMensagem INT IDENTITY(1,1) PRIMARY KEY,
    conteudo VARCHAR(1000) NOT NULL,
    idUsuario INT FOREIGN KEY REFERENCES Aprendize.Usuario(idUsuario) NOT NULL,
    tempoMensagem DATETIME NOT NULL,
    idColecao INT FOREIGN KEY REFERENCES Aprendize.Colecao(idColecao) NOT NULL
);

-- DADOS DE TESTE

-- Inserindo dados na tabela Usuario
INSERT INTO Aprendize.Usuario (nome, senha, linkFotoDePerfil)
VALUES 
('Nobara Kugisaki', 'EstouViva', 'https://i.pinimg.com/736x/ba/5a/70/ba5a7064b4b1f9b260df25901008e21c.jpg'),
('Nagito Komaeda', '11037', 'https://upload.wikimedia.org/wikipedia/en/b/b8/NagitoKomaeda.png'),
('Senhor Ver�ssimo', '04131129', 'https://i.ytimg.com/vi/1Vr0gejP76k/maxresdefault.jpg');

-- Inserindo dados na tabela Colecao
INSERT INTO Aprendize.Colecao (nome, descricao, linkImagem, idCriador, dataCriacao)
VALUES 
('Unicamp - COMVEST', 'Cole��o para revis�o de conte�dos para o vestibular unicamp', 'https://www.unicamp.br/wp-content/uploads/sites/33/2023/07/Logo_Unicamp__0.jpg', 1, '2024-08-22'),
('Programa��o em Python', 'Cole��o para iniciantes em programa��o com Python', 'https://www.richgarcia.com.br/wp-content/uploads/2021/10/python.png', 2, '2024-08-22');

-- Inserindo dados na tabela Materia
INSERT INTO Aprendize.Materia (nome, capa, idColecao)
VALUES 
('Matem�tica', 'https://www.youtz.com.br/wp-content/uploads/2019/10/YOUTZ-MATEMATICA-ENEM.jpg', 1),
('Geografia', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV3BlGPahOfSq9Nq7YKL0Vwy4ivCE4sSc3KQ&s', 1),
('Estrutura de dados', 'https://hermes.dio.me/articles/cover/a3f96e47-8696-49c0-a776-c9f065667cb7.png', 2);

-- Inserindo dados na tabela Topico
INSERT INTO Aprendize.Topico (nome, ordem, idMateria)
VALUES 
('Equa��es Lineares', 1, 1),
('Tri�ngulos', 1, 2),
('Hashing', 1, 3);

-- Inserindo dados na tabela DiaRotina
INSERT INTO Aprendize.DiaRotina (idMateria, idUsuario, metaExercicios, metaTempo, diaDaSemana)
VALUES 
(1, 1, 10, null, 2), -- Estuda Matem�tica na segunda-feira
(2, 1, null, '01:00:00', 2), -- Estuda Geografia na segunda-feira
(3, 2, null, '00:30:00', 4);  -- Estuda Python na quarta-feira

-- Inserindo dados na tabela Estudo
INSERT INTO Aprendize.Estudo (idTopico, idUsuario, metaExercicios, metaTempo, qtosExercicios, qtosExerciciosAcertados, qtoTempo, dataEstudo)
VALUES 
(1, 1, 10, '01:00:00', 8, 7, '00:50:00', '2024-08-22'),
(2, 2, 5, '00:30:00', 4, 4, '00:25:00', '2024-08-22');

-- Inserindo dados na tabela Tarefa
INSERT INTO Aprendize.Tarefa (idTopico, idUsuario, metaExercicios, metaTempo, dataTarefa, ehRevisao)
VALUES 
(1, 1, 10, '01:00:00', '2024-08-22', 0),
(2, 2, 5, '00:30:00', '2024-08-22', 1);

-- Inserindo dados na tabela Notificacao
INSERT INTO Aprendize.Notificacao (conteudo, idUsuario, lida)
VALUES 
('Sua tarefa de �lgebra est� pendente.', 1, 0),
('Nova mat�ria em sua cole��o de Programa��o em Python.', 2, 1);

-- Inserindo dados na tabela UsuarioColecao
INSERT INTO Aprendize.UsuarioColecao (idUsuario, idColecao, cargo)
VALUES 
(1, 1, '2'), -- Jo�o � Administrador da cole��o de Matem�tica B�sica
(2, 2, '1'); -- Maria � Moderadora da cole��o de Python

-- Inserindo dados na tabela Mensagem
INSERT INTO Aprendize.Mensagem (conteudo, idUsuario, tempoMensagem, idColecao)
VALUES 
('Estou com dificuldade em entender equa��es lineares.', 1, '2024-01-22 10:30:00', 1),
('Algu�m pode me ajudar com o exerc�cio 5?', 2, '2024-02-01 14:00:00', 2);
