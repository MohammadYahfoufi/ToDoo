import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Category {
  final String id;
  final String name;
  final String location;
  final String priority;
  final String userId;

  Category({
    required this.id,
    required this.name,
    required this.location,
    required this.priority,
    required this.userId,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      priority: data['priority'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  get color => null;
}

class Task {
  String taskId;
  String name;
  bool completed;
  String userId;

  Task({
    required this.taskId,
    required this.name,
    required this.completed,
    required this.userId,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      taskId: doc.id,
      name: data['name'] ?? '',
      completed: data['completed'] ?? false,
      userId: data['userId'] ?? '',
    );
  }
}

class CategoryService {
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future<void> addCategory(Category category) {
    return categories.add({
      'name': category.name,
      'location': category.location,
      'priority': category.priority,
      'userId': category.userId,
    });
  }

  Stream<List<Category>> getCategories(String userId) {
    return categories
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }
}

class TaskService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');
  final String categoryId;

  TaskService({required this.categoryId});

  Future<void> addTask(Task task) async {
    await tasks.add({
      'categoryId': categoryId,
      'name': task.name,
      'completed': task.completed,
      'userId': task.userId,
    });

    await _updateAchievementStatus(task.userId, 'Create a Task');
  }

  Future<void> _updateAchievementStatus(
      String userId, String achievementTitle) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    DocumentSnapshot docSnapshot = await userDoc.get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      if (data[achievementTitle] != true) {
        userDoc.set({achievementTitle: true}, SetOptions(merge: true));
      }
    } else {
      userDoc.set({achievementTitle: true}, SetOptions(merge: true));
    }
  }

  Stream<List<Task>> getTasks(String userId) {
    return tasks
        .where('userId', isEqualTo: userId)
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    });
  }

  Future<void> updateTaskCompletion(Task task) {
    return tasks.doc(task.taskId).update({'completed': task.completed});
  }

  Future<void> deleteTask(String taskId) {
    return tasks.doc(taskId).delete();
  }
}

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryService _categoryService = CategoryService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Task Categories'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ],
        backgroundColor: Colors.blue[700],
      ),
      drawer: UnifiedDrawer(),
      body: StreamBuilder<List<Category>>(
        stream: _categoryService
            .getCategories(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<Category> categories = snapshot.data!;
          return CarouselSlider(
            options: CarouselOptions(
              height: 400,
              enlargeCenterPage: true,
              autoPlay: false,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
            ),
            items: categories.map((category) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TasksPage(category: category),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(category.name,
                        style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    String priorityValue = 'Medium';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Category Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                DropdownButtonFormField<String>(
                  value: priorityValue,
                  items: ['High', 'Medium', 'Low']
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        priorityValue = value;
                      });
                    }
                  },
                  decoration: InputDecoration(labelText: 'Priority'),
                ),
                SizedBox(height: 10),
                SizedBox(height: 5),
                Container(
                  height: 100,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Category newCategory = Category(
                    id: '',
                    name: nameController.text,
                    location: locationController.text,
                    priority: priorityValue,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                  );
                  _categoryService.addCategory(newCategory).then((_) {
                    setState(() {});
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class TasksPage extends StatefulWidget {
  final Category category;

  TasksPage({required this.category});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: StreamBuilder<List<Task>>(
          stream: TaskService(categoryId: widget.category.id)
              .getTasks(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<Task> tasks = snapshot.data!;
            int incompleteTasks = tasks.where((task) => !task.completed).length;

            return Text(
              '${tasks.length} Tasks ($incompleteTasks incomplete)',
              style: TextStyle(fontSize: 18),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: TaskService(categoryId: widget.category.id)
            .getTasks(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Task> tasks = snapshot.data!;

          return ListView.separated(
            itemCount: tasks.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1.5,
              );
            },
            itemBuilder: (context, index) {
              var task = tasks[index];
              return Dismissible(
                key: Key(task.taskId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  TaskService(categoryId: widget.category.id)
                      .deleteTask(task.taskId);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(task.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        Task updatedTask = Task(
                          taskId: task.taskId,
                          name: task.name,
                          completed: newValue,
                          userId: task.userId,
                        );
                        TaskService(categoryId: widget.category.id)
                            .updateTaskCompletion(updatedTask);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Task Name'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      Task newTask = Task(
                        taskId: '',
                        name: nameController.text,
                        completed: false,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                      );
                      TaskService(categoryId: widget.category.id)
                          .addTask(newTask)
                          .then((_) {
                        TaskService(categoryId: widget.category.id)
                            ._updateAchievementStatus(
                          FirebaseAuth.instance.currentUser!.uid,
                          'Create a Task',
                        );
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class UnifiedDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
