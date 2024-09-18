# 🧠 Aprendize

## Visão Geral

**Nome do Projeto:** Aprendize

**Objetivo Principal:** Auxiliar estudantes na organização de seus estudos de forma eficiente, centralizando ferramentas úteis em um único aplicativo.

O **Aprendize** é um aplicativo projetado para otimizar a experiência de estudo, oferecendo ferramentas para gerenciar horários, acompanhar progresso e interagir com uma comunidade de apoio. Ele permite aos usuários criar e gerenciar coleções de matérias e subtópicos, configurar rotinas de estudo e se conectar com outras pessoas interessadas nos mesmos temas.

## 🎯 Funcionalidades-Chave

- **Organização de Rotina:** Configure horários disponíveis para estudo e crie rotinas semanais personalizadas.
- **Temporizador:** Cronômetro baseado na técnica Pomodoro ou outras técnicas de produtividade para sessões de estudo.
- **Histórico de Estudos:** Registro detalhado dos conteúdos aprendidos e tempo dedicado ao estudo, com resumos semanais.
- **Agendamento Automático de Revisões:** Sugere revisões com base na técnica de repetição espaçada, ajustando-se ao progresso do usuário.
- **Notificações:** Lembretes automáticos para sessões de estudo, revisões e outras tarefas programadas.
- **Comunidade de Estudos:** Espaço para interagir, discutir e tirar dúvidas com outras pessoas que estão estudando os mesmos tópicos.

## 🌟 Impacto Esperado

**Benefícios:**

- **Melhor Organização:** Facilita a gestão do tempo e do conteúdo de estudo, reduzindo o estresse e melhorando a eficiência.
- **Aumento da Produtividade:** Ferramentas como o temporizador e o agendamento de revisões ajudam a maximizar o tempo de estudo e melhorar a retenção de informações.
- **Suporte e Motivação:** A comunidade integrada oferece um ambiente colaborativo que encoraja e apoia os estudantes.

**Impacto Social/Econômico:**

- **Impacto Social:** Promove um ambiente de aprendizado colaborativo e acessível, ajudando aqueles com dificuldades em organizar seu tempo ou sem acesso a recursos pagos.
- **Impacto Econômico:** Melhor desempenho acadêmico e preparatório pode levar a melhores oportunidades acadêmicas e profissionais, potencializando o sucesso em exames e concursos.

## 📁 Anexos

- [Design no Canva](https://www.canva.com/pt_br/login/?redirect=%2Fdesign%2FDAGNgig3Gis%2FoqhxYU6KLmtk2G2coNM0lw%2Fedit)
- [Protótipo no Figma](https://www.figma.com/design/E1tBrXkEF3vLZ3pXjn87vO/Aprendize?node-id=0-1)
- [MER](https://lucid.app/lucidchart/e2f256d3-c3a7-4f2e-989a-aa9174ed20bf/edit?beaconFlowId=A0531744E941EAEE&invitationId=inv_bab0ff9a-d43e-43a1-8ddc-83a0cb3310e0&page=HWEp-vi-RSFO#)
- [Docs](https://docs.google.com/document/d/13lYIa2goEvbmv9-VFuTJ4FxTMG0gYBkv5I9BB-ekzoM/edit)
- [Drive](https://drive.google.com/drive/folders/1m9Y1Mtlh5-NJmDtdsa6GCkAD-0JHnwxi)

## 🚀 Instruções de Configuração Local

```console
  git clone https://github.com/seu-usuario/seu-repositorio.git
```
```console
  cd aprendize
```

### Flutter

```console
  cd flutter
```
```console
  flutter pub get
```
```console
  flutter run
```

### API Node
```console
  cd apiNode
```
```console
  npm install
```
Criar arquivo .env na raiz do ApiNode e inserir as chaves abaixo
```console
  PORT=6060
  DATABASE_URL="sqlserver://<ENDEREÇO DO SERVIDOR>:1433;database=<NOME DO SEU DATABASE>;user=<NOME DO SEU USUÁRIO>;password=<SUA SENHA>;encrypt=true;trustServerCertificate=true;schema=Aprendize"
```
```console
  npx prisma init
```
Troque o provider por “sqlserver” no schema.prisma recém criado
```console
  npx prisma db pull
```
```console
  npx prisma generate
```
Adicione o seu json da chave do bucket storage do google cloud

E para executar entre na pasta api e insira
```console
  node index
```

## 👥 Membros do Grupo

- **Alice Lopes dos Santos** (22117)
- **Angelina Durigan** (22118)
- **Arthur Gama Jorge** (23578)
- **Daniel Dorigan de Carvalho Campos** (23124)
- **Ion Mateus Nunes Oprea** (23135)
