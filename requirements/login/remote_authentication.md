# Remote Authentication Use Case

> ## Caso de sucesso

1. ✅ Sistema Valida os dados
2. ✅ Sistema faz uma requisição para a URL da API de login
3. Sistema valida os dados recebidos da API
4. Sistema entrega os dados da conta do usuário

> ## Exceção - URL Inválida
1. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Dados Inválidos
1. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Resposta Inválida
1. Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Falha no servidor
1.  ✅  Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Credenciais Inválidas
1. ✅  Sistema retorna uma mensagem informando que as credenciais estão inválidas.