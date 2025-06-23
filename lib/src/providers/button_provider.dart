import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class ButtonProvider extends GetxController {
  var status = true.obs;
  var activeRoomIndex = 0.obs;

  final DatabaseReference _relayRef =
      FirebaseDatabase.instance.ref("kontrol/relay");

  @override
  void onInit() {
    super.onInit();
    _relayRef.child("status").onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is bool) {
        status.value = value;
      }
    });
  }

  buttonOnOff() async {
    try {
      status.value = !status.value;

      await _relayRef.update({
        "status": status.value,
      });
      print("status $status");
    } catch (e) {
      print("firebase update error: $e");
    }

    //update ke firebase secera realtime
  }

  void setActiveRoom(int index) {
    activeRoomIndex.value = index;
  }
}
