import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/providers/button_provider.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/search.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStatus = Get.put(ButtonProvider());

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu_rounded,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: mediaQueryWidth,
        height: mediaQueryHeight,
        child: Column(
          spacing: 12,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello Zeta',
                        style: AppTheme.h1,
                      ),
                      Text(
                        "Welcome to SigmaHome",
                        style: TextStyle(
                            color: AppTheme.onDefaultColor, fontSize: 12),
                      )
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16),
                      ),
                    ),
                    child: Image.asset('assets/images/profile.jpg'),
                  )
                ],
              ),
            ),
            Container(
              //container cuaca
              margin: EdgeInsets.symmetric(horizontal: 28),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.accentColor,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 22,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BoxedIcon(
                    WeatherIcons.day_cloudy,
                    color: AppTheme.secondaryColor,
                    size: 50,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cerah Berawan",
                        style: AppTheme.h1,
                      ),
                      Text(
                        "24°C",
                        style: AppTheme.h2,
                      ),
                      Text(
                        "Ngemplak, Sleman, Yogyakarta",
                        style: AppTheme.actionS,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 22),
              child: Search(
                icon: Icon(Icons.search),
                hint: "Search Device",
                textController: TextEditingController(),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
