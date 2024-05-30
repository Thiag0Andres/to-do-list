import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ToDoItem> _toDoItems = [];
  final TextEditingController _controller = TextEditingController();

  // Adds a new to-do item to the beginning of the list
  void _addToDoItem(String title) {
    setState(() {
      _toDoItems.insert(0, ToDoItem(title: title));
    });
    _controller.clear();
  }

  // Updates the status of the to-do item and rearranges the list
  void _updateToDoItem(ToDoItem toDoItem, bool? completed) {
    setState(() {
      toDoItem.completed = completed ?? false;
      _toDoItems.remove(toDoItem);
      if (toDoItem.completed) {
        _toDoItems.add(toDoItem); // Move to end if completed
      } else {
        _toDoItems.insert(0, toDoItem); // Move to start if not completed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Tarefa',
                prefixIcon: Icon(Icons.assignment),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _addToDoItem(_controller.text);
                }
              },
              child: const Text('Cadastrar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _toDoItems.length,
                itemBuilder: (context, index) {
                  final toDoItem = _toDoItems[index];
                  return CheckboxListTile(
                    title: Text(
                      toDoItem.title,
                      style: TextStyle(
                        decoration: toDoItem.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    value: toDoItem.completed,
                    onChanged: (bool? value) {
                      _updateToDoItem(toDoItem, value);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToDoItem {
  String title;
  bool completed;

  ToDoItem({required this.title, this.completed = false});
}
