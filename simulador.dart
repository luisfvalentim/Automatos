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

DateTime inicio = DateTime.now();
bool processInputString(Automaton automaton, String inputString) {
  int currentState = automaton.initial;

  for (final symbol in inputString
      .replaceAll(';', '')
      .replaceAll('0', '')
      .replaceAll('1', '')
      .split('')) {
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
  final diagramPath = 'diagrama.json';
  final testsPath = 'arquivo_de_testes.in.csv';
  final outputPath = 'arquivo_de_saida.out.csv';

  final automaton = loadAutomaton(diagramPath);

  final tests = File(testsPath)
      .readAsStringSync()
      .split('\n')
      .where((line) => line.trim().isNotEmpty);
  final output = <String>[];

  for (final inputString in tests) {
    DateTime startTime = DateTime.now();
    final result = processInputString(automaton, inputString);
    DateTime endTime = DateTime.now();
    Duration responseTime = endTime.difference(startTime);
    output.add(
        '$inputString;${result ? '1' : '0'};${(responseTime.inMicroseconds)} microsegundos');
  }

  File(outputPath).writeAsStringSync(output.join('\n'));
}
