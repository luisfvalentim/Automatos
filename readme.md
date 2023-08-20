# Relatório de Desenvolvimento

Este relatório está descrevendo o desenvolvimento de um programa em Dart para processar entradas utilizando um autômato. O código foi desenvolvido como parte de um projeto para ler entradas e determinar se elas pertencem à linguagem reconhecida pelo autômato e no final dizer se o automato é aceito(1) ou rejeitado(0), como pedido na descrição do trabalho.

## Ferramenta Desenvolvida

O programa desenvolvido é responsável por carregar um autômato a partir de um arquivo JSON, realizar o processamento de entradas e gerar um arquivo CSV de saída contendo os resultados e os tempos de resposta para cada entrada.

### Funcionamento

O programa é composto pelas seguintes partes principais:

1. **Classe Transition**: Representa uma transição no autômato. Cada transição é definida por um estado de origem, um símbolo de entrada opcional, estado de destino e esstado final.

2. **Classe Automaton**: Representa o autômato em si. Possui informações sobre o estado inicial, os estados finais e as transições, para que possa ser rodado o altomato.

3. **Função `loadAutomaton`**: A função carrega as informações de um autômato a partir de um arquivo JSON. As informações incluem o estado inicial, os estados finais e as transições.

4. **Função `processInputString`**: Processa o autômato, seguindo suas transições. Retorna `true` se a string é aceita e `false` caso contrário.

5. **Função `main`**: Essa é a fução principal que faz todo o processamento acotecer. É feito a leitura do arquivo de testes, processa cada string de entrada usando o autômato e gera um arquivo CSV no modelo passado na descriçao do trabalho.

### Exemplo de Uso

Linguagem Dart

SDK: Dart SDK version: 3.0.6 (stable) (Tue Jul 11 18:49:07 2023 +0000) on "windows_x64"

O exemplo a seguir demonstra como utilizar o programa:

Entre com o diagrama que deseja trabalhar.

exemplo:

diagrama.json 

```
{
  "initial": 0,
  "final": [2, 4],
  "transitions": [
    {"from": 0, "read": "a", "to": 1},
    {"from": 1, "read": "a", "to": 1},
    {"from": 1, "read": "b", "to": 2},
    {"from": 0, "read": null, "to": 3},
    {"from": 3, "read": "a", "to": 4},
    {"from": 4, "read": "b", "to": 4}
  ]
}
```

Agora indique a entrada e saida em um arquivo chamado testes.csv, 'aceito' sendo 1 e 'rejeitado' sendo 0.

exepmlo:

abacaba;1

Por ultimo, sera necessario que seja compilado para trazer a saida no devido molde.

[palavra de entrada;resultadoesperado;resultadoobtido;tempo]

exemplo:

abacaba;1 ; 1 ;  907 microsegundos




