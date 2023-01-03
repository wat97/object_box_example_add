import 'package:flutter/material.dart';
import 'package:test_object_box/model/model_notification.dart';
import 'package:test_object_box/object_box.dart';
import 'package:test_object_box/widget/list_notification.dart';

late ObjectBox objectBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListNotification(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<ModelNotification> listModel =
              await objectBox.getAllNotification().first;

          ModelNotification rowModel = await objectBox.getFirstId().first;
          ModelNotification rowFirst = listModel.last;
          int count = listModel.length + 1;

          String title = "${rowFirst.title} [{count}]";
          String detail = "${rowFirst.detail} [{count}]";
          title = title.replaceAll("{count}", "${count}");
          detail = detail.replaceAll("{count}", "${count}");
          DateTime date = DateTime.now();
          ModelNotification added = ModelNotification(
            title: title,
            detail: detail,
          );
          print(rowFirst.toJson());
          print(added.toJson());
          // result.forEach((element) {
          //   print("resultEach ${element}");
          // });
          print("rowModel = ${rowModel.toJson()}");
          // setState(() {
          objectBox.addNotification(added);
          // });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
