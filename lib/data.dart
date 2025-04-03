import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Data Table"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('numbersy').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            print('Documents fetched: ${snapshot.data!.docs.length}');
          }

          var dataList = snapshot.data!.docs
              .map((document) => document.data() as Map<String, dynamic>)
              .toList();
          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              var data = dataList[index];
              print('Data at index $index: $data');
              return ListTile(
                title: Text(data['name']),
              );
            },
          );
        },
      ),
    );
  }
}
