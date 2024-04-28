const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const conexaoMySql = require('../conexaoMySQL.js');

// Rota de login
router.post('/api/login', (req, res) => {
    try {
        const { email, senha } = req.body;
        // Verifique as credenciais do usuário no banco de dados
        const sql = 'SELECT * FROM Usuario WHERE email = ? AND senha = ?';
        conexaoMySql.query(sql, [email, senha], (error, resultados) => {
            if (error) {
                console.error('Erro ao autenticar usuário:', error.sqlMessage);
                res.status(500).json({ erro: 'Erro interno do servidor' });
            } else {
                if (resultados.length > 0) {
                    // Se as credenciais estiverem corretas, gere um token JWT
                    const token = jwt.sign({ email }, 'segredo'); // 'segredo' é a chave secreta usada para assinar o token
                    res.status(200).json({
                        message: "Login feito com sucesso!!!",
                        token
                    });
                } else {
                    res.status(401).json({ erro: 'Credencias inválidas!!!' });
                }
            }
        });
    } catch (error) {
        console.error('Erro ao processar requisição:', error);
        res.status(500).send('Erro ao processar requisição');
    }
});

module.exports = router;
