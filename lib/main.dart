import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(TodudeApp());
}

enum Mode { none, newTask, search, dialog }

enum TodudeDialog { shortcuts, confirm }

enum ListNames { urgent, today, shortTerm, longTerm }

class TodudeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyMedium: const TextStyle(
                fontFamily: 'Andale Mono',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<List<Task>> _tasks = [[], [], [], []];

  int _activeListIndex = 0;
  int _activeTaskIndex = 0;

  String _searchQuery = '';
  Mode _activeMode = Mode.none;
  TodudeDialog _activeDialog = TodudeDialog.shortcuts;

  @override
  void initState() {
    super.initState();
  }

  void _addTask(String task) {
    setState(() => _tasks[_activeListIndex].add(Task(task: task)));
  }

  void _removeTask(int index) {
    setState(() => _tasks[_activeListIndex].removeAt(index));
  }

  void _changeActiveList(int index) {
    setState(() {
      _activeListIndex = index;
    });
  }

  void _searchTasks(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Task> _getList() => _tasks[_activeListIndex];

  void _handleKeyEvent(RawKeyEvent event) {
    if (_activeMode == Mode.none &&
            event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.keyK) {
      if (_activeTaskIndex > 0) {
        setState(() => _activeTaskIndex--);
      }
    } else if (_activeMode == Mode.none &&
            event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.keyJ) {
      if (_activeTaskIndex < _getList().length - 1) {
        setState(() => _activeTaskIndex++);
      }
    } else if (_activeMode == Mode.none &&
        event.logicalKey == LogicalKeyboardKey.keyX) {
      final task = _getList()[_activeTaskIndex];
      setState(() => task.isCompleted = !task.isCompleted);
    } else if (event.isShiftPressed &&
        event.logicalKey == LogicalKeyboardKey.slash) {
      _showShortcutsDialog();
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_activeMode == Mode.dialog) {
        Navigator.pop(context);
      }
      setState(() => _activeMode = Mode.none);
    }
  }

  void _showShortcutsDialog() {
    _activeMode = Mode.dialog;
    _activeDialog = TodudeDialog.shortcuts;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              'Shit+\\ Keyboard shortcuts\n\n Esc end edit or close dialog\n\n / Search\n\n C new task\n\n Cmd Z/Ctrl Z Undo... '),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todude'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: _searchTasks,
            enabled: _activeMode == Mode.search,
            style: const TextStyle(fontFamily: 'Courier'),
            decoration: const InputDecoration(
              labelText: '... # for tags',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: _handleKeyEvent,
            child: Expanded(
              child: ListView.builder(
                itemCount: _getList().length,
                itemBuilder: (context, index) {
                  final task = _getList()[index];
                  if (_searchQuery.isNotEmpty &&
                      !task.task
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase())) {
                    return Container();
                  }
                  return ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        setState(() => task.isCompleted = value ?? false);
                      },
                    ),
                    title: Text(
                      task.task,
                      style: const TextStyle(fontFamily: 'Courier'),
                    ),
                    tileColor:
                        index == _activeTaskIndex ? Colors.grey[200] : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Task {
  String task;
  bool isCompleted;

  Task({required this.task, this.isCompleted = false});
}
