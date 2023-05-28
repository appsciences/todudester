import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(TodoListApp());
}

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText2: TextStyle(
                fontFamily: 'Courier',
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
  List<Task> todoList1 = [];
  List<Task> todoList2 = [];
  List<Task> todoList3 = [];
  List<Task> todoList4 = [];

  int activeListIndex = 1;
  String searchQuery = '';
  bool isShortcutDialogOpen = false;
  int activeTaskIndex = 0;
  FocusNode _textFieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.show');
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _addTask(String task) {
    final newTask = Task(task: task);
    switch (activeListIndex) {
      case 1:
        setState(() => todoList1.add(newTask));
        break;
      case 2:
        setState(() => todoList2.add(newTask));
        break;
      case 3:
        setState(() => todoList3.add(newTask));
        break;
      case 4:
        setState(() => todoList4.add(newTask));
        break;
    }
  }

  void _removeTask(int index) {
    switch (activeListIndex) {
      case 1:
        setState(() => todoList1.removeAt(index));
        break;
      case 2:
        setState(() => todoList2.removeAt(index));
        break;
      case 3:
        setState(() => todoList3.removeAt(index));
        break;
      case 4:
        setState(() => todoList4.removeAt(index));
        break;
    }
  }

  void _changeActiveList(int index) {
    setState(() {
      activeListIndex = index;
      activeTaskIndex = 0;
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (!_textFieldFocus.hasFocus) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyK) {
        if (activeTaskIndex > 0) {
          setState(() => activeTaskIndex--);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.keyJ) {
        final currentTaskList = _getList();
        if (activeTaskIndex < currentTaskList.length - 1) {
          setState(() => activeTaskIndex++);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.keyX) {
        final currentTaskList = _getList();
        if (activeTaskIndex >= 0 && activeTaskIndex < currentTaskList.length) {
          final task = currentTaskList[activeTaskIndex];
          setState(() => task.isCompleted = !task.isCompleted);
        }
      } else if (event.isShiftPressed &&
          event.logicalKey == LogicalKeyboardKey.slash) {
        setState(() => isShortcutDialogOpen = true);
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _textFieldFocus.unfocus();
      setState(() => isShortcutDialogOpen = false);
    }
  }

  void _searchTasks(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<Task> _getList() {
    switch (activeListIndex) {
      case 1:
        return todoList1;
      case 2:
        return todoList2;
      case 3:
        return todoList3;
      case 4:
        return todoList4;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: _handleKeyEvent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _searchTasks,
                style: TextStyle(fontFamily: 'Courier'),
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeActiveList(1),
                    style: ButtonStyle(
                      backgroundColor: activeListIndex == 1
                          ? MaterialStateProperty.all(Colors.blue)
                          : null,
                    ),
                    child: Text('List 1'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeActiveList(2),
                    style: ButtonStyle(
                      backgroundColor: activeListIndex == 2
                          ? MaterialStateProperty.all(Colors.blue)
                          : null,
                    ),
                    child: Text('List 2'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeActiveList(3),
                    style: ButtonStyle(
                      backgroundColor: activeListIndex == 3
                          ? MaterialStateProperty.all(Colors.blue)
                          : null,
                    ),
                    child: Text('List 3'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeActiveList(4),
                    style: ButtonStyle(
                      backgroundColor: activeListIndex == 4
                          ? MaterialStateProperty.all(Colors.blue)
                          : null,
                    ),
                    child: Text('List 4'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _getList().length,
                itemBuilder: (context, index) {
                  final task = _getList()[index];
                  if (searchQuery.isNotEmpty &&
                      !task.task
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase())) {
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
                      style: TextStyle(fontFamily: 'Courier'),
                    ),
                    tileColor:
                        index == activeTaskIndex ? Colors.grey[200] : null,
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Focus(
                focusNode: _textFieldFocus,
                child: TextField(
                  onSubmitted: (task) {
                    _addTask(task);
                    // Clear the text field after submitting a task
                    //TODO: Error _textEditingController.clear();
                  },
                  style: TextStyle(fontFamily: 'Courier'),
                  decoration: InputDecoration(
                    hintText: 'Add a task',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        //TODO: Error _addTask(_textEditingController.text);
                        // Clear the text field after adding
                        //TODO: Error _textEditingController.clear();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String task;
  bool isCompleted;

  Task({required this.task, this.isCompleted = false});
}
