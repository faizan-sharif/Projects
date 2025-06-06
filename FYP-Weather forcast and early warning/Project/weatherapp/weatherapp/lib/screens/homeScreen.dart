// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/controllers/auth_controller.dart';
import 'package:weatherapp/controllers/cyclone_controller.dart';
import 'package:weatherapp/controllers/theme_controller.dart';
import 'package:weatherapp/controllers/weather_controller.dart';
import 'package:weatherapp/screens/auth/update_password_screen.dart';
import 'package:weatherapp/screens/feedback/feedback_screen.dart';
import 'package:weatherapp/screens/locationError.dart';
import 'package:weatherapp/screens/profile/user_profile_screen.dart';
import 'package:weatherapp/screens/weather/base_url_screen.dart';
import 'package:weatherapp/screens/weather/cyclone_detection.dart';
import 'package:weatherapp/widgets/WeatherInfoHeader.dart';
import 'package:weatherapp/widgets/custom_searchbar.dart';
import 'package:weatherapp/widgets/mainWeatherDetail.dart';
import 'package:weatherapp/widgets/mainWeatherInfo.dart';
import '../provider/weatherProvider.dart';
import 'requestError.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FloatingSearchBarController fsc = FloatingSearchBarController();
  ThemeController themeController = Get.put(ThemeController());
  WeatherController weatherController = Get.put(WeatherController());

  @override
  void initState() {
    super.initState();
    requestWeather();
  }

  Future<void> requestWeather() async {
    await Provider.of<WeatherProvider>(
      context,
      listen: false,
    ).getWeatherData(context);
  }

  static const double boxWidth = 52.0;
  static const double boxHeight = 40.0;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            // const DrawerHeader(child: Text('Drawer Header')),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.dark_mode_outlined,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => themeController.toggleTheme(),
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: boxHeight,
                              width: boxWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Icon(
                                Icons.nights_stay_outlined,
                                color: themeController.isDarkMode.value
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                            Container(
                              height: boxHeight,
                              width: boxWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode.value
                                    ? Colors.transparent
                                    : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Icon(
                                Icons.wb_sunny_outlined,
                                color: themeController.isDarkMode.value
                                    ? Colors.grey.shade600
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ListTile(
              leading: Icon(
                Icons.wifi,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(
                'Set Base URL',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                _scaffoldKey
                    .currentState!
                    .closeDrawer();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BaseUrlScreen()));
              },
            ),

            ListTile(
              leading: Icon(
                Icons.cyclone,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(
                'Cyclone Detection',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                Get.put(CycloneController());
                _scaffoldKey
                    .currentState!
                    .closeDrawer();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CycloneDetection()));
              },
            ),

            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                _scaffoldKey
                    .currentState!
                    .closeDrawer();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.key,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(
                'Update Password',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                _scaffoldKey
                    .currentState!
                    .closeDrawer();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdatePasswordScreen(email: FirebaseAuth.instance.currentUser!.email!,)));
              },
            ),

            ListTile(
              leading: Icon(
                Icons.feedback,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(
                'Feedback',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                _scaffoldKey
                    .currentState!
                    .closeDrawer();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()));
              },
            ),

            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () => Get.find<AuthController>().logout(),
            ),
          ],
        ),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProv, _) {
          if (!weatherProv.isLoading && !weatherProv.isLocationserviceEnabled) {
            return LocationServiceErrorDisplay();
          }

          if (!weatherProv.isLoading &&
              weatherProv.locationPermission != LocationPermission.always &&
              weatherProv.locationPermission != LocationPermission.whileInUse) {
            return LocationPermissionErrorDisplay();
          }

          if (weatherProv.isRequestError) return RequestErrorDisplay();

          if (weatherProv.isSearchError) return SearchErrorDisplay(fsc: fsc);

          return Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0).copyWith(
                  top: kToolbarHeight +
                      MediaQuery.viewPaddingOf(context).top +
                      24.0,
                ),
                children: [
                  WeatherInfoHeader(),
                  const SizedBox(height: 16.0),
                  MainWeatherInfo(),
                  const SizedBox(height: 16.0),
                  MainWeatherDetail(),
                  const SizedBox(height: 24.0),
                  // TwentyFourHourForecast(),
                  // const SizedBox(height: 18.0),
                  // SevenDayForecast(),
                ],
              ),
              CustomSearchBar(fsc: fsc),
            ],
          );
        },
      ),
    );
  }
}

// class CustomSearchBar extends StatefulWidget {
//   final FloatingSearchBarController fsc;
//   const CustomSearchBar({Key? key, required this.fsc}) : super(key: key);

//   @override
//   State<CustomSearchBar> createState() => _CustomSearchBarState();
// }

// class _CustomSearchBarState extends State<CustomSearchBar> {
//   final List<String> _allCities = [
//     'New York',
//     'Tokyo',
//     'Dubai',
//     'London',
//     'Singapore',
//     'Sydney',
//     'Wellington',
//   ];

//   List<String> _filteredSuggestions = [];

//   @override
//   void initState() {
//     super.initState();
//     _filteredSuggestions = _allCities; // Show all initially or keep empty
//   }

//   void _updateSuggestions(String query) {
//     final suggestions = _allCities
//         .where((city) => city.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     setState(() {
//       _filteredSuggestions = suggestions;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FloatingSearchBar(
//       controller: widget.fsc,
//       hint: 'Search...',
//       clearQueryOnClose: false,
//       scrollPadding: const EdgeInsets.only(top: 16.0, bottom: 56.0),
//       transitionDuration: const Duration(milliseconds: 400),
//       borderRadius: BorderRadius.circular(16.0),
//       transitionCurve: Curves.easeInOut,
//       accentColor: Theme.of(context).primaryColor,
//       hintStyle: Theme.of(context).textTheme.bodySmall,
//       queryStyle: Theme.of(context).textTheme.bodySmall,
//       physics: const BouncingScrollPhysics(),
//       elevation: 2.0,
//       debounceDelay: const Duration(milliseconds: 300),
//       onQueryChanged: _updateSuggestions,
//       onSubmitted: (query) async {
//         widget.fsc.close();
//         await Provider.of<WeatherProvider>(
//           context,
//           listen: false,
//         ).searchWeather(query);
//       },
//       transition: CircularFloatingSearchBarTransition(),
//       actions: [
//         FloatingSearchBarAction(
//           showIfOpened: false,
//           child: PhosphorIcon(
//             PhosphorIconsBold.magnifyingGlass,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//         FloatingSearchBarAction.icon(
//           showIfClosed: false,
//           showIfOpened: true,
//           icon: PhosphorIcon(
//             PhosphorIconsBold.x,
//             color: Theme.of(context).primaryColor,
//           ),
//           onTap: () {
//             if (widget.fsc.query.isEmpty) {
//               widget.fsc.close();
//             } else {
//               widget.fsc.clear();
//               _updateSuggestions(''); // Reset suggestions when cleared
//             }
//           },
//         ),
//       ],
//       builder: (context, transition) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: Material(
//             color: Colors.white,
//             elevation: 4.0,
//             child: ListView.separated(
//               shrinkWrap: true,
//               physics: BouncingScrollPhysics(),
//               padding: EdgeInsets.zero,
//               itemCount: _filteredSuggestions.length,
//               itemBuilder: (context, index) {
//                 String data = _filteredSuggestions[index];
//                 return InkWell(
//                   onTap: () async {
//                     widget.fsc.query = data;
//                     widget.fsc.close();
//                     await Provider.of<WeatherProvider>(
//                       context,
//                       listen: false,
//                     ).searchWeather(data);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(22.0),
//                     child: Row(
//                       children: [
//                         PhosphorIcon(PhosphorIconsFill.mapPin),
//                         const SizedBox(width: 22.0),
//                         Text(
//                           data,
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               separatorBuilder: (context, index) =>
//                   Divider(thickness: 1.0, height: 0.0),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
