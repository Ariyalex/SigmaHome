import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/text_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: "current name");
    print("controller dibuat");
  }

  @override
  void dispose() {
    nameController.dispose();
    print("controller dihapus");
    super.dispose();
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Edit Profile",
                  style: AppTheme.h2,
                ),
                SizedBox(
                  height: 10,
                ),
                AuthTextField(
                    labelText: "New Name",
                    hintText: "new name",
                    controller: TextEditingController()),
                Text(
                  "*Ganti nama menjadi nama yang baru",
                  style: AppTheme.actionS,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffF8F9FE),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(32),
                          ),
                        ),
                        child: Image.asset('assets/images/profile.jpg'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton.icon(
                            style: ButtonStyle(
                              side: WidgetStateProperty.all(
                                const BorderSide(
                                  color: AppTheme.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            onPressed: () {},
                            label: Text("Pick New Profile"),
                            icon: Icon(Icons.person),
                          ),
                          Text(
                            "File: Prabowo x teddy.png",
                            style: AppTheme.actionS.copyWith(fontSize: 12),
                          ),
                          Text(
                            "Size: 2.5 MB",
                            style: AppTheme.actionS.copyWith(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 12,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        // Handle save logic
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditDialog(context),
      child: ListTile(
        leading: Icon(
          Icons.edit_square,
          color: AppTheme.iconColor,
        ),
        title: Text("Edit Profile"),
      ),
    );
  }
}
