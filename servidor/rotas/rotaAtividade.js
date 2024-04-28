const express = require('express');
const router = express.Router();
const conexaoMySql = require('../conexaoMySQL.js');

// Rota para buscar todas as atividades
router.get('/api/atividade', (req, res) => {
    try {
        // Query SQL para buscar todas as atividades não canceladas
        const sql = 'SELECT * FROM Atividade WHERE CANCELADO = ?';
        
        // Definindo 'CANCELADO' como 'F' para buscar apenas atividades não canceladas
        conexaoMySql.query(sql, ['F'], (error, resultados, campos) => {
            if (error) {
                console.error('Erro ao buscar atividades:', error.sqlMessage);
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


// Rota para buscar uma atividade pelo ID
router.get('/api/atividade/:id', (req, res) => {
    try {
        const { id } = req.params;
        const sql = 'SELECT * FROM Atividade WHERE ID_ATIVIDADE = ?';
        conexaoMySql.query(sql, [id], (error, resultados) => {
            if (error) {
                console.error('Erro ao buscar atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.length > 0) {
                    res.status(200).json(resultados[0]);
                } else {
                    res.status(404).send('Atividade não encontrada');
                }
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).send('Erro ao processar requisição');
    }
});

// Rota para criar uma nova atividade
router.post('/api/atividade', (req, res) => {
    try {
        const { titulo, descricao, data } = req.body;
        // Modificando a query para incluir o valor 'F' para o campo CANCELADO
        const sql = 'INSERT INTO Atividade (TITULO, `DESC`, `DATA`, CANCELADO) VALUES (?, ?, ?, ?)';
        // Definindo 'CANCELADO' como 'F'
        conexaoMySql.query(sql, [titulo, descricao, data, 'F'], (error, resultados) => {
            if (error) {
                console.error('Erro ao criar nova atividade:', error.sqlMessage);
                res.status(500).json({ message: 'Erro ao criar nova atividade', erro: error.sqlMessage });
            } else {
                console.log('Nova atividade criada com sucesso');
                res.status(200).json({ message: 'Nova atividade criada com sucesso' });
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).json({ message: 'Erro ao processar requisição', erro: error });
    }
});

// Rota para atualizar os dados de uma atividade
router.put('/api/atividade/:id', (req, res) => {
    try {
        const { id } = req.params;
        const { titulo, descricao, data } = req.body;
        // Modificando a query para atualizar o campo CANCELADO como 'F'
        const sql = 'UPDATE Atividade SET TITULO = ?, `DESC` = ?, `DATA` = ? WHERE ID_ATIVIDADE = ?';
        // Definindo 'CANCELADO' como 'F'
        conexaoMySql.query(sql, [titulo, descricao, data, id], (error, resultados) => {
            if (error) {
                console.error('Erro ao atualizar atividade:', error.sqlMessage);
                res.status(500).json({ message: 'Erro ao atualizar atividade', erro: error.sqlMessage });
            } else {
                if (resultados.affectedRows > 0) {
                    res.status(200).json({ message: 'Atividade atualizada com sucesso' });
                } else {
                    res.status(404).json({ message: 'Atividade não encontrada' });
                }
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).json({ message: 'Erro ao processar requisição', erro: error });
    }
});

// Rota para excluir uma atividade
router.delete('/api/atividade/:id', (req, res) => {
    try {
        const { id } = req.params;
        const sql = 'UPDATE Atividade SET CANCELADO = ? WHERE ID_ATIVIDADE = ?';
        // Definindo 'CANCELADO' como 'T'
        conexaoMySql.query(sql, ['T', id], (error, resultados) => {
            if (error) {
                console.error('Erro ao excluir atividade:', error.sqlMessage);
                res.status(500).json({ message: 'Erro ao excluir atividade', erro: error.sqlMessage });
            } else {
                if (resultados.affectedRows > 0) {
                    res.status(200).json({ message: 'Atividade excluída com sucesso' });
                } else {
                    res.status(404).json({ message: 'Atividade não encontrada' });
                }
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).json({ message: 'Erro ao processar requisição', erro: error });
    }
});


module.exports = router;
