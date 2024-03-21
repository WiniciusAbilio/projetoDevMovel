const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config({ path: 'variaveis.env' });


const rotaUsuario = require('./rotas/rotaUsuario');


const app = express();
const port = process.env.PORT;


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/api/usuarios', rotaUsuario);



app.use(cors());


app.listen(port, () => {
  console.log(`Aplicativo Express.js rodando na porta ${port}`);
});