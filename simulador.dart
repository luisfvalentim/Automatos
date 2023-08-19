import 'dart:convert';
import 'dart:io';

class Transition {
  final int from;
  final String? read;
  final int to;

  Transition(this.from, this.read, this.to);
}

class Automaton {
  final int initial;
  final List<int> finalStates;
  final List<Transition> transitions;

  Automaton(this.initial, this.finalStates, this.transitions);
}

Automaton loadAutomaton(String filePath) {
  final data = File(filePath).readAsStringSync();
  final jsonData = json.decode(data);

  final int initial = jsonData['initial'];
  final List<int> finalStates = List<int>.from(jsonData['final']);

  final List<Transition> transitions = [];
  for (final transitionData in jsonData['transitions']) {
    final transition = Transition(
      transitionData['from'],
      transitionData['read'],
      transitionData['to'],
    );
    transitions.add(transition);
  }

  print('Initial: $initial');
  print('Final states: $finalStates');
  print('Transitions:');
  for (final transition in transitions) {
    print('  From: ${transition.from}, Read: ${transition.read}, To: ${transition.to}');
  }

  return Automaton(initial, finalStates, transitions);
}

bool processInputString(Automaton automaton, String inputString) {
  int currentState = automaton.initial;

  for (final symbol in inputString.split('')) {
    final transition = automaton.transitions.firstWhere(
      (t) => t.from == currentState && (t.read == symbol || t.read == null),
      orElse: () => Transition(currentState, null, -1),
    );

    print(
        'Current state: $currentState, Symbol: $symbol, Transition: From ${transition.from}, Read: ${transition.read}, To: ${transition.to}');

    if (transition.to == -1) {
      return false;
    }

    currentState = transition.to;
  }

  return automaton.finalStates.contains(currentState);
}

void main() {
  final diagramPath = 'diagrama.json'; // Substitua pelo caminho correto do arquivo de diagrama JSON
  final testsPath = 'testes.csv'; // Substitua pelo caminho correto do arquivo de testes
  final outputPath = 'saida.csv'; // Substitua pelo caminho correto do arquivo de saída

  final automaton = loadAutomaton(diagramPath);

  final tests = File(testsPath).readAsStringSync().split('\n').where((line) => line.trim().isNotEmpty);
  final output = <String>[];

  for (final inputString in tests) {
    final result = processInputString(automaton, inputString);
    output.add('Teste = [$inputString] \n ${result ? '* Aceito' : '* Rejeitado'} \n ------------------ \n');
  }

  File(outputPath).writeAsStringSync(output.join('\n'));
}
