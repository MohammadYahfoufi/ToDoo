import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:last/menu.dart' as prefix;
import 'tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CategoryPage(),
    );
  }
}

class category {
  final String id;
  final String name;
  final String location;
  final String priority;
  final String imagePath;
  final String userId;

  category({
    required this.id,
    required this.name,
    required this.location,
    required this.priority,
    required this.imagePath,
    required this.userId,
  });

  factory category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return category(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      priority: data['priority'] ?? '',
      imagePath: data['imagePath'] ?? '',
      userId: data['userId'] ?? '',
    );
  }
}

class CategoryService {
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future<void> deleteCategory(String categoryId) async {
    try {
      await categories.doc(categoryId).delete();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  Future<void> addCategory(Category category) async {
    await categories.add({
      'name': category.name,
      'location': category.location,
      'priority': category.priority,
      'userId': category.userId,
    });
    await _updateAchievementStatus(category.userId, 'Create a Category');
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

  Stream<List<Category>> getCategories(String userId) {
    return categories
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }
}

class CategoryPage extends StatelessWidget {
  final CategoryService _categoryService = CategoryService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Categories',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ],
      ),
      drawer: prefix.UnifiedDrawer(),
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
          return Padding(
            padding: EdgeInsets.only(top: 50),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 450,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                autoPlay: false,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: categories.map((category) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TasksPage(category: category),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 18, 27, 34),
                            image: DecorationImage(
                              image: AssetImage('assets/carousel.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 28.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Location: ${category.location}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Priority: ${category.priority}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _categoryService.deleteCategory(category.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
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
                      priorityValue = value;
                    }
                  },
                  decoration: InputDecoration(labelText: 'Priority'),
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
                  _categoryService.addCategory(newCategory);
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
