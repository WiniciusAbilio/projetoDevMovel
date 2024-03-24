const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../variaveis.env') });


const rotaUsuario = require('./rotas/rotaUsuario');


const app = express();
const port = process.env.PORT;

//Rota Padrao ao acessar a localhost:3010 isso será informado
app.get('/', (req, res) => {
  res.send('Servidor está rodando!!!!!!!!!');
});


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

//Rotas do sistema
app.use(rotaUsuario);//Rota de Usúario



//Rota Padrao ao acessar qualquer rota que nao foi definida isso será informado (OBS: SEMPRE COLOCAR NO FINAL DAS ROTAS JÁ DEFINIDAS)
app.get('*', (req, res) => {
  res.send(`
    <html>
      <body style="display: flex; justify-content: center; align-items: center; height: 100vh;">
        <h1 style="font-size: 5em;">404 Página não encontrada no sistema!!!</h1>
      </body>
    </html>
  `);
});//


app.listen(port, () => {
  console.log(`Aplicativo Express.js rodando na porta ${port}`);
});