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
#### 📦 Instalando as dependências
Node:
```bash
npm install
```
Flutter:
```bash
flutter pub get
```
**(Observação:Lembrar de criar o suporte para web e outras plataformas pelo VSCode indo no botão de rodar sem o debug e escolhendo as opções.)**



##### ⚙️ Executando o projeto
Node:
    Executar o projeto normalmente:
    ```bash
    npm start
    ```
    Executar o projeto com o debug do VSCode:
    ```bash
    npm run debug
    ```
    Após isso, clique no ícone de debug do VSCode, crie um arquivo launch.json escolha o tipo node e cole a seguinte configuração:
    
    **(Observação: Lembrar de definir breakpoints no código para exibir as informações durante o uso do debug.)**
    
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
Flutter:
    Para ver quais dispositivos estão disponíveis:
    ```bash
    flutter devices
    ```
    Escolher e rodar no dispositivo:
    ```bash
    flutter run -d (DISPOSITIVO)
    ```
