# 🚀 Projeto Desenvolvimento Móvel - projetoDevMovel

Este é o repositório do projeto de Desenvolvimento Móvel. Aqui estão as instruções para configurar o projeto.
Siga estas etapas para configurar e rodar o projeto.

### 📋 Pré-requisitos

Primeiro, crie o banco de dados com o script que está na pasta 'bancoDeDados'.

### 🔑 Configurando a senha do banco de dados

Em seguida, modifique a senha padrão para 'password' com o seguinte comando:

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
```
### 📦 Instalando as dependências

```bash
npm install
```

### ⚙️ Executando o projeto
Executar o projeto normalmente:
```bash
npm start
```


Executar o projeto com o debug do VSCode:
```bash
npm run debug
```
Após isso, clique no ícone de debug do VSCode, crie um arquivo launch.json e cole a seguinte configurações:
```js
//Configuração do debug do VSCODE para o servidor do express
{
    "version": "0.2.0",
    "configurations": [
      {
        "type": "node",
        "request": "attach",
        "name": "Debug do servidor express",
        "skipFiles": [
            "<node_internals>/**"
        ]
      }
    ]
  }
```
