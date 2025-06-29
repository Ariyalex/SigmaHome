import 'package:get/get.dart';

class RoomController extends GetxController {
  final RxInt activeRoomIndex = 0.obs;
  final RxString selectedRoomName = 'All'.obs;

  void selectedRoom(int index, String roomName) {
    activeRoomIndex.value = index;
    selectedRoomName.value = roomName;
  }

  void resetRoomSelection() {
    activeRoomIndex.value = 0;
    selectedRoomName.value = 'All';
  }
}
