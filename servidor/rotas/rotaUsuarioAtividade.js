const express = require('express');
const router = express.Router();
const conexaoMySql = require('../conexaoMySQL.js');

// Rota para buscar todas as relações de Usuario_Atividade
router.get('/api/usuario_atividade', (req, res) => {
    try {
        const sql = 'SELECT * FROM Usuario_Atividade WHERE `CANCELADO` = "F"';
        conexaoMySql.query(sql, (error, resultados, campos) => {
            if (error) {
                console.error('Erro ao buscar relações de Usuario_Atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                res.json(resultados);
            }
        });
    } catch (error) {
        console.error('Erro inesperado:', error);
        res.status(500).json({ erro: 'Erro inesperado ao processar a solicitação' });
    }
});

// Rota para buscar uma relação de Usuario_Atividade pelo ID do usuário e da atividade
router.get('/api/usuario_atividade/:idUsuario/:idAtividade', (req, res) => {
    try {
        const { idUsuario, idAtividade } = req.params;
        const sql = 'SELECT * FROM Usuario_Atividade WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?';
        conexaoMySql.query(sql, [idUsuario, idAtividade], (error, resultados) => {
            if (error) {
                console.error('Erro ao buscar relação de Usuario_Atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.length > 0) {
                    res.status(200).json(resultados[0]);
                } else {
                    res.status(404).json({ erro: 'Relação de Usuario_Atividade não encontrada' });
                }
            }
        });
    } catch (error) {
        console.error('Erro inesperado:', error);
        res.status(500).json({ erro: 'Erro inesperado ao processar a solicitação' });
    }
});

// Rota para criar uma nova relação de Usuario_Atividade
router.post('/api/usuario_atividade', (req, res) => {
    try {
        const { idUsuario, idAtividade, dataEntrega, nota } = req.body;
        const sql = 'INSERT INTO Usuario_Atividade (`USUARIO.ID`, `ATIVIDADE.ID`, `DATA_ENTREGA`, `NOTA`, `CANCELADO`) VALUES (?, ?, ?, ?, "F")';
        conexaoMySql.query(sql, [idUsuario, idAtividade, dataEntrega, nota], (error, resultados) => {
            if (error) {
                console.error('Erro ao criar nova relação de Usuario_Atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                console.log('Nova relação de Usuario_Atividade criada com sucesso');
                res.status(200).json({ message: 'Nova relação de Usuario_Atividade criada com sucesso' });
            }
        });
    } catch (error) {
        console.error('Erro inesperado:', error);
        res.status(500).json({ erro: 'Erro inesperado ao processar a solicitação' });
    }
});


// Rota para atualizar os dados de uma relação de Usuario_Atividade
router.put('/api/usuario_atividade/:idUsuario/:idAtividade', (req, res) => {
    try {
        const { idUsuario, idAtividade } = req.params;
        const { dataEntrega, nota } = req.body;
        const sql = 'UPDATE Usuario_Atividade SET `DATA_ENTREGA` = ?, `NOTA` = ? WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?';
        conexaoMySql.query(sql, [dataEntrega, nota, idUsuario, idAtividade], (error, resultados) => {
            if (error) {
                console.error('Erro ao atualizar relação de Usuario_Atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.affectedRows > 0) {
                    res.status(200).json({ message: 'Relação de Usuario_Atividade atualizada com sucesso' });
                } else {
                    res.status(404).json({ erro: 'Relação de Usuario_Atividade não encontrada' });
                }
            }
        });
    } catch (error) {
        console.error('Erro inesperado:', error);
        res.status(500).json({ erro: 'Erro inesperado ao processar a solicitação' });
    }
});

// Rota para excluir uma relação de Usuario_Atividade
router.delete('/api/usuario_atividade/:idUsuario/:idAtividade', (req, res) => {
    try {
        const { idUsuario, idAtividade } = req.params;
        const sql = 'UPDATE Usuario_Atividade SET `CANCELADO` = "T" WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?';
        conexaoMySql.query(sql, [idUsuario, idAtividade], (error, resultados) => {
            if (error) {
                console.error('Erro ao cancelar relação de Usuario_Atividade:', error.sqlMessage);
                res.status(500).json({ erro: error.sqlMessage });
            } else {
                if (resultados.affectedRows > 0) {
                    res.status(200).json({ message: 'Relação de Usuario_Atividade marcada como cancelada com sucesso' });
                } else {
                    res.status(404).json({ erro: 'Relação de Usuario_Atividade não encontrada' });
                }
            }
        });
    } catch (error) {
        console.error('Erro inesperado:', error);
        res.status(500).json({ erro: 'Erro inesperado ao processar a solicitação' });
    }
});

module.exports = router;
