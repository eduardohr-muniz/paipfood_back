#!/bin/bash
#  chmod +x env_dev.sh
# ./env_dev.sh
# Carregar as variáveis do arquivo .env
export $(grep -v '^#' .env.example | xargs)

# Iniciar o Dart Frog em modo de depuração usando a porta definida no .env
cat .env.example ; dart_frog dev --port=$PORT
