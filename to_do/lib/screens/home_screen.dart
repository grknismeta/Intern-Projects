import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Todo> _todos = [];
  final List<Color> _colors = [];

  void _addTodo() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _todos.add(Todo(title: _controller.text, createdAt: DateTime.now()));
      _colors.add(
        Colors.primaries[Random().nextInt(Colors.primaries.length)].shade300,
      );
    });
    _controller.clear();
  }

  void _removeTodoAt(int index) {
    setState(() {
      _todos.removeAt(index);
      _colors.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todo's", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _todos.isEmpty
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Good Day, Mr Gürkan."),
                      Text(DateFormat('KK:mm a').format(DateTime.now())),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Empty Todos...',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _todos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (ctx, i) => TodoTile(
                  todo: _todos[i],
                  color: _colors[i],
                  onDelete: () => _removeTodoAt(i),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add New Todo", style: TextStyle(fontSize: 16)),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "What’s up today?",
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addTodo();
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
