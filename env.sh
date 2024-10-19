#!/bin/bash
# chmod +x env.sh 
# ./env.sh
# Carregar as variáveis do arquivo .env
export $(grep -v '^#' .env | xargs)

# Iniciar o Dart Frog em modo de depuração usando a porta definida no .env
cat .env ; dart_frog dev --port=$PORT
