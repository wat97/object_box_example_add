import 'package:flutter/material.dart';
import 'package:test_object_box/main.dart';
import 'package:test_object_box/model/model_notification.dart';
import 'package:test_object_box/object_box.dart';
import 'package:test_object_box/widget/item_notification.dart';

class ListNotification extends StatefulWidget {
  const ListNotification({super.key});

  @override
  State<ListNotification> createState() => _ListNotificationState();
}

class _ListNotificationState extends State<ListNotification> {
  late ObjectBox objectBox;
  late Stream<List<ModelNotification>> stream;
  bool isInitialize = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      objectBox = await getStore();
      setState(() {
        isInitialize = false;
      });
      stream = await objectBox.getAllNotification();
      setState(() {
        isInitialize = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isInitialize
        ? StreamBuilder<List<ModelNotification>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  itemBuilder: (context, index) {
                    ModelNotification modelNotification = snapshot.data![index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: ItemNotification(
                          modelNotification: modelNotification),
                    );
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
          )
        : CircularProgressIndicator();
  }
}
