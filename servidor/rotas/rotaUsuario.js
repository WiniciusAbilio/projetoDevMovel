const express = require('express');
const router = express.Router();
const conexaoMySql = require('../conexaoMySQL.js');

// Rota para buscar todos os usuários
router.get('/api/usuario', (req, res) => {
    try {
        // Query SQL para buscar todos os usuários
        const sql = 'SELECT * FROM Usuario';

        // Executa a query
        conexaoMySql.query(sql, (error, resultados, campos) => {
            if (error) {
                console.error('Erro ao buscar usuários:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                // Retorna os resultados da consulta
                res.json(resultados);
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).send('Erro ao processar requisição');
    }
});

// Rota para buscar um usuário pelo ID
router.get('/api/usuario/:id', (req, res) => {
    try {
        const { id } = req.params;
        const sql = 'SELECT * FROM Usuario WHERE ID_USUARIO = ?';
        conexaoMySql.query(sql, [id], (error, resultados) => {
            if (error) {
                console.error('Erro ao buscar usuário:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.length > 0) {
                    res.status(200).json(resultados[0]);
                } else {
                    res.status(404).send('Usuário não encontrado');
                }
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).send('Erro ao processar requisição');
    }
});

// Rota para criar um novo usuário
router.post('/api/usuario', (req, res) => {
    try {
        const { nome, email, senha } = req.body;
        const sql = 'INSERT INTO Usuario (NOME, EMAIL, SENHA) VALUES (?, ?, ?)';
        conexaoMySql.query(sql, [nome, email, senha], (error, resultados) => {
            if (error) {
                console.error('Erro ao criar novo usuário:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                console.log('Novo usuário criado com sucesso');
                res.status(200).send('Novo usuário criado com sucesso');
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).send('Erro ao processar requisição');
    }
});

// Rota para atualizar os dados de um usuário
router.put('/api/usuario/:id', (req, res) => {
    try {
        const { id } = req.params;
        const { nome, email, senha } = req.body;
        const sql = 'UPDATE Usuario SET NOME = ?, EMAIL = ?, SENHA = ? WHERE ID_USUARIO = ?';
        conexaoMySql.query(sql, [nome, email, senha, id], (error, resultados) => {
            if (error) {
                console.error('Erro ao atualizar usuário:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.affectedRows > 0) {
                    res.status(200).send('Usuário atualizado com sucesso');
                } else {
                    res.status(404).send('Usuário não encontrado');
                }
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).send('Erro ao processar requisição');
    }
});

// Rota para excluir um usuário
router.delete('/api/usuario/:id', (req, res) => {
    try {
        const { id } = req.params;
        const sql = 'DELETE FROM Usuario WHERE ID_USUARIO = ?';
        conexaoMySql.query(sql, [id], (error, resultados) => {
            if (error) {
                console.error('Erro ao excluir usuário:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.affectedRows > 0) {
                    res.status(200).send('Usuário excluído com sucesso');
                } else {
                    res.status(404).send('Usuário não encontrado');
                }
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).send('Erro ao processar requisição');
    }
});

module.exports = router;
