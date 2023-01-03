import 'package:flutter/material.dart';
import 'package:test_object_box/model/model_notification.dart';

class ItemNotification extends StatelessWidget {
  ModelNotification modelNotification;
  ItemNotification({
    Key? key,
    required this.modelNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      child: ListTile(
        title: Text(modelNotification.title),
        subtitle: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Text(
                  modelNotification.detail,
                ),
              ),
              Expanded(
                child: Text(
                  modelNotification.date.toIso8601String(),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
