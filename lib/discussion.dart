import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List Discussion Board',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: TodoDiscussionPage(),
    );
  }
}

class TodoDiscussionPage extends StatefulWidget {
  @override
  _TodoDiscussionPageState createState() => _TodoDiscussionPageState();
}

class _TodoDiscussionPageState extends State<TodoDiscussionPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? currentUser;
  TextEditingController postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> addPost(String postContent) async {
    if (currentUser != null) {
      String username = currentUser!.displayName ?? 'Anonymous';
      await firestore.collection('posts').add({
        'content': postContent,
        'created_at': Timestamp.now(),
        'likes': 0,
        'username': username,
      }).then((_) {
        _updateAchievementStatus(currentUser!.uid, 'Post on Discussion');
      });
    }
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

  Future<void> addReply(String postId, String replyContent) async {
    if (currentUser != null) {
      String username = currentUser!.displayName ?? 'Anonymous';
      await firestore
          .collection('posts')
          .doc(postId)
          .collection('replies')
          .add({
        'content': replyContent,
        'created_at': Timestamp.now(),
        'username': username,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List Discussion',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: firestore
                  .collection('posts')
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data!.docs[index];
                    return PostWidget(
                      post: Post(
                        id: post.id,
                        content: post['content'],
                        likes: post['likes'],
                        username: post['username'],
                      ),
                      onReply: (replyContent) {
                        addReply(post.id, replyContent);
                      },
                      onLike: () {
                        firestore.collection('posts').doc(post.id).update({
                          'likes': FieldValue.increment(1),
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: postController,
                    decoration: InputDecoration(
                      hintText: 'To-Do',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        addPost(value);
                        postController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Post added!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    String value = postController.text.trim();
                    if (value.isNotEmpty) {
                      addPost(value);
                      postController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Post added!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child: Text('Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Post {
  String id;
  String content;
  int likes;
  String username;
  List<String> replies;
  bool liked;

  Post({
    required this.id,
    required this.content,
    required this.likes,
    required this.username,
    List<String>? replies,
    this.liked = false,
  }) : this.replies = replies ?? [];
}

class PostWidget extends StatefulWidget {
  final Post post;
  final Function(String) onReply;
  final VoidCallback onLike;

  PostWidget({required this.post, required this.onReply, required this.onLike});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool showReplies = false;
  TextEditingController replyController = TextEditingController();

  void toggleRepliesVisibility() {
    setState(() {
      showReplies = !showReplies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Colors.lightBlue[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.post.username}',
              style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.post.content,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onLike,
                      icon: Icon(
                        Icons.handshake_outlined,
                        color:
                            widget.post.likes > 0 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    Text(
                      '${widget.post.likes}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: toggleRepliesVisibility,
                  icon: Icon(
                    Icons.reply,
                    color: showReplies ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
            if (showReplies) ...[
              SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  SizedBox(height: 8.0),
                  Text(
                    'Replies:',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.post.id)
                        .collection('replies')
                        .orderBy('created_at')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: snapshot.data!.docs.map((reply) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            margin: EdgeInsets.only(bottom: 8.0),
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${reply['username']}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  reply['content'],
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 12.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: replyController,
                              decoration: InputDecoration(
                                hintText: 'Write a reply...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            String replyContent = replyController.text.trim();
                            if (replyContent.isNotEmpty) {
                              widget.onReply(replyContent);
                              replyController.clear();
                            }
                          },
                          child: Text(
                            'Reply',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        SizedBox(width: 8.0),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }
}
