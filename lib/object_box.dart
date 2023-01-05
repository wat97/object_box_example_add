import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_object_box/model/model_notification.dart';
import 'objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  // Keeping reference to avoid Admin getting closed.
  // ignore: unused_field
  late final Admin _admin;

  /// Two Boxes: one for Tasks, one for Tags.
  late final Box<ModelNotification> boxNotification;

  /// A stream of all tasks ordered by date.
  late final Stream<Query<ModelNotification>> notificationStream;

  ObjectBox._create(this.store) {
    if (Admin.isAvailable()) {
      // Keep a reference until no longer needed or manually closed.
      _admin = Admin(store);
    }

    boxNotification = Box<ModelNotification>(store);

    if (boxNotification.isEmpty()) {
      putDemoData();
    }

    final qBuilder = boxNotification.query();
    notificationStream = qBuilder.watch(triggerImmediately: true);
  }

  void putDemoData() {
    ModelNotification model = ModelNotification(
      id: 0,
      title: "Welcome",
      detail: "Selamat datang do notif ",
    );
    boxNotification.put(model);
  }

  void addNotification(ModelNotification model) {
    boxNotification.put(model);
  }

  Stream<List<ModelNotification>> getAllNotification() {
    final builder = boxNotification.query()
      ..order(ModelNotification_.date, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  Stream<ModelNotification> getFirstId() {
    final builder = boxNotification.query()
      ..order(
        ModelNotification_.id,
        flags: Order.descending,
      );

    return builder.watch(triggerImmediately: true).map((event) {
      print("eventDa ${event.toString()}");
      return event.find().last;
    });
  }

  clearList() {
    boxNotification.removeAll();
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }
}
