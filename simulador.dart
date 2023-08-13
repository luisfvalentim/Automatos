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

  return Automaton(initial, finalStates, transitions);
}

bool processInputString(Automaton automaton, String inputString) {
  int currentState = automaton.initial;

  for (final symbol in inputString.split('')) {
    final transition = automaton.transitions.firstWhere(
      (t) => t.from == currentState && (t.read == symbol || t.read == null),
      orElse: () => Transition(currentState, null, -1),
    );

    if (transition.to == -1) {
      return false;
    }

    currentState = transition.to;
  }

  return automaton.finalStates.contains(currentState);
}

void main() {
  final diagramPath = 'diagrama.json'; // Path para o diuagrama de testes
  final testsPath = 'testes.txt'; // Path para arquivo de teste
  final outputPath = 'saida.txt'; // Path para arquivo de saida

  final automaton = loadAutomaton(diagramPath);

  final tests = File(testsPath).readAsStringSync().split('\n').where((line) => line.trim().isNotEmpty);
  final output = <String>[];

  for (final inputString in tests) {
    final result = processInputString(automaton, inputString);

    output.add('Teste = [$inputString] \n ${result ? '* Aceito' : '* Rejeitado'} \n ------------------ \n');
  }

  File(outputPath).writeAsStringSync(output.join('\n'));
}
