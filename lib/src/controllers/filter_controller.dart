import 'package:get/get.dart';
import 'package:sigma_home/src/models/device_model.dart';

class FilterController extends GetxController {
  // ✅ Ganti TextEditingController dengan RxString
  final RxString searchQuery = "".obs;

  final RxString selectedDeviceType = "All".obs;
  final RxBool showActiveOnly = false.obs;

  void setDeviceTypeFilter(String deviceType) {
    selectedDeviceType.value = deviceType;
  }

  void setActiveOnlyFilter(bool activeOnly) {
    showActiveOnly.value = activeOnly;
  }

  // ✅ Update search method untuk RxString
  void setSearchQuery(String query) {
    searchQuery.value = query.trim();
  }

  // ✅ Update clear method untuk RxString
  void clearSearch() {
    searchQuery.value = "";
  }

  // ✅ Update reset method untuk RxString
  void resetFilters() {
    selectedDeviceType.value = "All";
    showActiveOnly.value = false;
    searchQuery.value = "";
  }

  List<DeviceModel> filterDevices(List<DeviceModel> devices) {
    List<DeviceModel> filtered = List.from(devices);

    // ✅ Update untuk menggunakan .value
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((device) {
        return device.name.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by device type
    if (selectedDeviceType.value != "All") {
      filtered = filtered.where((device) {
        return device.deviceType.displayName == selectedDeviceType.value;
      }).toList();
    }

    // Filter by active status
    if (showActiveOnly.value) {
      filtered = filtered.where((device) => device.deviceStatus).toList();
    }

    return filtered;
  }

  String get filterSummary {
    List<String> filters = [];

    // ✅ Add search query to summary
    if (searchQuery.value.isNotEmpty) {
      filters.add('Search: "${searchQuery.value}"');
    }

    if (selectedDeviceType.value != "All") {
      filters.add(selectedDeviceType.value);
    }

    if (showActiveOnly.value) {
      filters.add("Active only");
    }

    return filters.isEmpty ? "No filters" : filters.join(", ");
  }

  bool get hasActiveFilters {
    return selectedDeviceType.value != "All" ||
        showActiveOnly.value ||
        searchQuery.value.isNotEmpty; // ✅ Update untuk .value
  }

  bool get hasSearchQuery {
    return searchQuery.value.isNotEmpty; // ✅ Update untuk .value
  }

  int getFilteredDeviceCount(List<DeviceModel> devices) {
    return filterDevices(devices).length;
  }
}
