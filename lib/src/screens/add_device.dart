import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/text_controller.dart';

class AddDevice extends StatelessWidget {
  const AddDevice({super.key});

  @override
  Widget build(BuildContext context) {
    final addDeviceC = Get.put(AddDeviceC());

    return Scaffold(
      appBar: AppBar(
        title: Text("Add New switch"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
                decoration: const InputDecoration(
                    hintText: "testing",
                    label: Text("Nama Switch"),
                    alignLabelWithHint: true),
                controller: addDeviceC.namaSwitch),
            SizedBox(
              height: 10,
            ),
            FilledButton(onPressed: () {}, child: Text("Simpan")),
          ],
        ),
      ),
    );
  }
}
