import 'dart:convert';
import 'dart:io';

List<Map<String, dynamic>> loadTransitionTable(String filePath) {
  final data = File(filePath).readAsStringSync();
  final jsonData = json.decode(data);
  return List<Map<String, dynamic>>.from(jsonData);
}

bool processInputString(List<Map<String, dynamic>> transitionTable, String currentState, String inputString, List<String> finalStates) {
  if (inputString.isEmpty) {
    // Verifica se o estado inicial é um estado final
    if (finalStates.contains(currentState)) {
      return true;
    } else {
      // Tratamento de movimento vazio indefinido
      return false;
    }
  }

  for (final symbol in inputString.split('')) {
    final nextStates = transitionTable.where(
      (row) => row['Estado atual'] == currentState && (row['Símbolo de entrada'] == symbol || row['Símbolo de entrada'] == "")
    );
    if (nextStates.isEmpty) {
      // Tratamento de transição indefinida
      return false;
    }
    currentState = nextStates.first['Próximo estado']!;
    if (finalStates.contains(currentState)) {
      return true;
    }
  }
  // Verifica se o estado inicial é um estado final
    if (finalStates.contains(currentState)) {
      return true;
    }

  // Verifica se o estado final é um estado final após o processamento dos símbolos de entrada
  return finalStates.contains(currentState);
}

enum AutomatonType {
  Deterministic,
  NonDeterministic,
  Unknown,
}

AutomatonType determineAutomatonType(List<Map<String, dynamic>> transitionTable) {
  bool isDeterministic = true;
  bool hasEmptyTransitions = false;

  for (final transition in transitionTable) {
    if (transition['Símbolo de entrada'] == '') {
      hasEmptyTransitions = true;
    }

    final nextStateCount = transitionTable.where(
      (row) => row['Estado atual'] == transition['Estado atual'] && row['Símbolo de entrada'] == transition['Símbolo de entrada']
    ).length;

    if (nextStateCount > 1) {
      isDeterministic = false;
      break;
    }
  }

  if (isDeterministic && !hasEmptyTransitions) {
    return AutomatonType.Deterministic;
  } else if (hasEmptyTransitions) {
    return AutomatonType.NonDeterministic;
  } else {
    return AutomatonType.Unknown;
  }
}

void main() {
  final diagramPath = 'diagrama.json'; // Substitua pelo caminho correto do arquivo de diagrama JSON
  final testsPath = 'testes.txt'; // Substitua pelo caminho correto do arquivo de testes
  final outputPath = 'saida.txt'; // Substitua pelo caminho correto do arquivo de saída
  final transitionTable = loadTransitionTable(diagramPath);
  
  final automatonType = determineAutomatonType(transitionTable);

  switch (automatonType) {
    case AutomatonType.Deterministic:
      print('O autômato é determinístico.');
      break;
    case AutomatonType.NonDeterministic:
      print('O autômato é não determinístico devido a transições vazias.');
      break;
    case AutomatonType.Unknown:
      print('Não foi possível determinar o tipo do autômato.');
      break;
  }


  final tests = File(testsPath).readAsStringSync().split('\n').where((line) => line.trim().isNotEmpty);
  final output = <String>[];
  

  // Defina os estados finais do autômato
  final finalStates = ['q2'];

  for (final inputString in tests) {
    final result = processInputString(transitionTable, 'q0', inputString, finalStates);
    output.add('Teste = $inputString: ${result ? 'Aceito' : 'Rejeitado'} \n\n');
  }

  File(outputPath).writeAsStringSync(output.join('\n'));
  
}
