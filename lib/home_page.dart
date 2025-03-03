import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'more_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  // Add a new task
  Future<void> addTask(String title) async {
    if (title.trim().isNotEmpty) {
      await tasks.add({'title': title, 'timestamp': FieldValue.serverTimestamp()});
    }
  }

  // Update a task
  Future<void> updateTask(String id, String newTitle) async {
    if (newTitle.trim().isNotEmpty) {
      await tasks.doc(id).update({'title': newTitle});
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }

  // Show Task Dialog (for Adding & Editing)
  void showTaskDialog({String? taskId, String? initialText}) {
    TextEditingController controller = TextEditingController(text: initialText ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(taskId == null ? "Add Task" : "Edit Task"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter task title...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskId == null) {
                  addTask(controller.text);
                } else {
                  updateTask(taskId, controller.text);
                }
                Navigator.pop(context);
              },
              child: Text(taskId == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "FireSync",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MorePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Add Task Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => showTaskDialog(),
                icon: const Icon(Icons.add, size: 20),
                label: const Text("Add Task"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),

          // Task List with Swipe to Delete
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasks.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks available.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                var taskList = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    var task = taskList[index];
                    var taskId = task.id;
                    var taskTitle = task['title'];

                    return Dismissible(
                      key: Key(taskId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white, size: 30),
                      ),
                      onDismissed: (direction) {
                        deleteTask(taskId);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            taskTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showTaskDialog(taskId: taskId, initialText: taskTitle),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
