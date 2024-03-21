// rotasUsuario.js
const express = require('express');
const router = express.Router();
const conexaoMySql = require('../conexaoMySql');

// Rota para inserir um novo usuário
router.post('/api/usuarios', (req, res) => {
  const { nome, email, senha } = req.body;
  const usuarioData = { nome, email, senha };

  // Obtém a conexão com o banco de dados
  const db = conexaoMySql;

  db.query('INSERT INTO Usuario SET ?', usuarioData, (err, results) => {
    if (err) {
      console.error('Erro ao inserir dados na tabela Usuario:', err);
      res.status(500).json({ error: 'Erro ao inserir usuário' });
      return;
    }
    console.log('Dados inseridos na tabela Usuario com sucesso:', results);
    res.status(200).json({ message: 'Usuário inserido com sucesso' });
  });
});

module.exports = router;
