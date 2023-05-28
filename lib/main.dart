import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO: keyboard shortcuts only work when the field is active
//TODO: Search should search across lists, grouped by lists, then j/k and enter to go to the task in the list or x to whatever
//TODO: make look like terminal

void main() {
  runApp(TodoListApp());
}

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> todoList1 = [];
  List<String> todoList2 = [];
  List<String> todoList3 = [];
  List<String> todoList4 = [];

  int activeListIndex = 1;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.show');
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _addTask(String task) {
    switch (activeListIndex) {
      case 1:
        setState(() => todoList1.add(task));
        break;
      case 2:
        setState(() => todoList2.add(task));
        break;
      case 3:
        setState(() => todoList3.add(task));
        break;
      case 4:
        setState(() => todoList4.add(task));
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
    setState(() => activeListIndex = index);
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (activeListIndex > 1) {
        setState(() => activeListIndex--);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (activeListIndex < 4) {
        setState(() => activeListIndex++);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.keyU) {
      setState(() => activeListIndex = 1);
    } else if (event.logicalKey == LogicalKeyboardKey.keyT) {
      setState(() => activeListIndex = 2);
    }
  }

  void _searchTasks(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todudester'),
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
                      !task.toLowerCase().contains(searchQuery.toLowerCase())) {
                    return Container();
                  }
                  return ListTile(
                    title: Text(task),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTask(index),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                onSubmitted: (task) {
                  _addTask(task);
                  // Clear the text field after submitting a task
                  _textEditingController.clear();
                },
                decoration: InputDecoration(
                  hintText: 'Add a task',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _addTask(_textEditingController.text);
                      // Clear the text field after adding a task
                      _textEditingController.clear();
                    },
                  ),
                ),
                controller: _textEditingController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getList() {
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

  final TextEditingController _textEditingController = TextEditingController();
}
