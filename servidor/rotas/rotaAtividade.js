const express = require('express');
const router = express.Router();
const conexaoMySql = require('../conexaoMySQL.js');

// Rota para buscar todas as atividades
router.get('/api/atividade', (req, res) => {
    try {
        // Query SQL para buscar todas as atividades
        const sql = 'SELECT * FROM Atividade';

        // Executa a query
        conexaoMySql.query(sql, (error, resultados, campos) => {
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
        const sql = 'INSERT INTO Atividade (TITULO, DESC, DATA) VALUES (?, ?, ?)';
        conexaoMySql.query(sql, [titulo, descricao, data], (error, resultados) => {
            if (error) {
                console.error('Erro ao criar nova atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                console.log('Nova atividade criada com sucesso');
                res.status(200).send('Nova atividade criada com sucesso');
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).send('Erro ao processar requisição');
    }
});

// Rota para atualizar os dados de uma atividade
router.put('/api/atividade/:id', (req, res) => {
    try {
        const { id } = req.params;
        const { titulo, descricao, data } = req.body;
        const sql = 'UPDATE Atividade SET TITULO = ?, DESC = ?, DATA = ? WHERE ID_ATIVIDADE = ?';
        conexaoMySql.query(sql, [titulo, descricao, data, id], (error, resultados) => {
            if (error) {
                console.error('Erro ao atualizar atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.affectedRows > 0) {
                    res.status(200).send('Atividade atualizada com sucesso');
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

// Rota para excluir uma atividade
router.delete('/api/atividade/:id', (req, res) => {
    try {
        const { id } = req.params;
        const sql = 'DELETE FROM Atividade WHERE ID_ATIVIDADE = ?';
        conexaoMySql.query(sql, [id], (error, resultados) => {
            if (error) {
                console.error('Erro ao excluir atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.affectedRows > 0) {
                    res.status(200).send('Atividade excluída com sucesso');
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

module.exports = router;
