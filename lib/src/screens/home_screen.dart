import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/providers/button_provider.dart';
import 'package:sigma_home/src/routes/route_named.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStatus = Get.put(ButtonProvider());
    return Scaffold(
      appBar: AppBar(
        title: Text("Sigma Home"),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(RouteNamed.addDevice);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () {
                return buttonStatus.status.value
                    ? OutlinedButton(
                        onPressed: () {
                          buttonStatus.buttonOnOff();
                        },
                        child: Text("Off"))
                    : FilledButton(
                        onPressed: () {
                          buttonStatus.buttonOnOff();
                        },
                        child: Text("On"));
              },
            )
          ],
        ),
      ),
    );
  }
}
