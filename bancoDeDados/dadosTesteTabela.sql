-- Inserts para teste das Rotas do backend
-- Inserts para tabela Usuario
INSERT INTO `mydb`.`Usuario` (`ID_USUARIO`, `NOME`, `EMAIL`, `SENHA`) VALUES (1, 'João Silva', 'joao@example.com', 'senha123');
INSERT INTO `mydb`.`Usuario` (`ID_USUARIO`, `NOME`, `EMAIL`, `SENHA`) VALUES (2, 'Maria Oliveira', 'maria@example.com', 'senhamaria');

-- Inserts para tabela Atividade
INSERT INTO `mydb`.`Atividade` (`ID_ATIVIDADE`, `TITULO`, `DESC`, `DATA`) VALUES (1, 'Atividade 1', 'Descrição da atividade 1', '2024-04-01');
INSERT INTO `mydb`.`Atividade` (`ID_ATIVIDADE`, `TITULO`, `DESC`, `DATA`) VALUES (2, 'Atividade 2', 'Descrição da atividade 2', '2024-04-02');

-- Inserts para tabela Usuario_Atividade
INSERT INTO `mydb`.`Usuario_Atividade` (`USUARIO.ID`, `ATIVIDADE.ID`, `DATA_ENTREGA`, `NOTA`) VALUES (1, 1, '2024-04-03', 8.5);
INSERT INTO `mydb`.`Usuario_Atividade` (`USUARIO.ID`, `ATIVIDADE.ID`, `DATA_ENTREGA`, `NOTA`) VALUES (2, 2, '2024-04-04', 9.0);
