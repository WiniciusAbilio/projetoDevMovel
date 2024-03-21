require('dotenv').config({ path: 'variaveis.env' });

const mysql = require('mysql');

const db = mysql.createConnection({
    host: process.env.HOST,
    user: process.env.USERDB,
    password: process.env.PASSWORDDB,
    database: process.env.NAMEDB
});

db.connect((err) => {
    if (err) {
      console.error('Erro ao conectar ao MySQL:', err);
      return;
    }
    console.log('Conectado ao MySQL!');
});

module.exports = db;
