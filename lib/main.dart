
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  final String name;
  bool isDone;

  Task({required this.name, this.isDone = false});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo lista',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 58, 103, 199),
      ),
      home: const InputNameScreen(),
    );
  }
}

class InputNameScreen extends StatefulWidget {
  const InputNameScreen({super.key});

  @override
  _InputNameScreenState createState() => _InputNameScreenState();
}

class _InputNameScreenState extends State<InputNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isButtonDisabled = true;

  _validateName(String name) {
    setState(() {
      _isButtonDisabled = name.length <= 3;
    });
  }

  _navigateToTaskListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListScreen(userName: _nameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo lista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              onChanged: (value) {
                _validateName(value);
              },
              decoration: InputDecoration(
                labelText: 'Podaj swoje imię',
                errorText: _isButtonDisabled ? '' : null,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonDisabled ? null : _navigateToTaskListScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  final String userName;

  const TaskListScreen({super.key, required this.userName});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  final TextEditingController _taskController = TextEditingController();

  _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        tasks.insert(0, Task(name: _taskController.text));
        _taskController.clear();
      });
    }
  }

  _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  _toggleTaskStatus(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista zadań'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          widget.userName.isNotEmpty
              ? Text('Witaj, ${widget.userName}!', style: const TextStyle(fontSize: 20, color: Colors.white))
              : const Text('Witaj!', style: TextStyle(color: Colors.white)),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    tasks[index].name,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: tasks[index].isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: tasks[index].isDone,
                        onChanged: (_) => _toggleTaskStatus(index),
                      ),
                      TextButton(
                        onPressed: () => _removeTask(index),
                        child: const Text('delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: 'Dodaj nowe zadanie',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.red),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
