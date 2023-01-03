import 'package:flutter/material.dart';
import 'package:test_object_box/main.dart';
import 'package:test_object_box/model/model_notification.dart';
import 'package:test_object_box/widget/item_notification.dart';

class ListNotification extends StatefulWidget {
  const ListNotification({super.key});

  @override
  State<ListNotification> createState() => _ListNotificationState();
}

class _ListNotificationState extends State<ListNotification> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ModelNotification>>(
      stream: objectBox.getAllNotification(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: snapshot.hasData ? snapshot.data!.length : 0,
            itemBuilder: (context, index) {
              ModelNotification modelNotification = snapshot.data![index];
              return ItemNotification(modelNotification: modelNotification);
            },
          );
        } else {
          return const Center(
            child: Text(
              "Press add + icon to Add",
            ),
          );
        }
      },
    );
  }
}
