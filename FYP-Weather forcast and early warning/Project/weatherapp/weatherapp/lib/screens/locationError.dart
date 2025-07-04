import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../provider/weatherProvider.dart';

class LocationPermissionErrorDisplay extends StatelessWidget {
  const LocationPermissionErrorDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProv, _) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width,
                  minWidth: 100,
                  maxHeight: MediaQuery.sizeOf(context).height / 3,
                ),
                child: Image.asset('assets/images/locError.png'),
              ),
              Center(
                child: Text(
                  'Location Permission Error',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Center(
                child: Text(
                  weatherProv.locationPermission ==
                          LocationPermission.deniedForever
                      ? 'Location permissions are permanently denied, Please enable manually from app settings and restart the app'
                      : 'Location permission not granted, please check your location permission',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textStyle: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                        padding: const EdgeInsets.all(12.0),
                        shape: StadiumBorder(),
                      ),
                      child: weatherProv.isLoading
                          ? const SizedBox(
                              width: 16.0,
                              height: 16.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              weatherProv.locationPermission ==
                                      LocationPermission.deniedForever
                                  ? 'Open App Settings'
                                  : 'Request Permission',
                            ),
                      onPressed: weatherProv.isLoading
                          ? null
                          : () async {
                              if (weatherProv.locationPermission ==
                                  LocationPermission.deniedForever) {
                                await Geolocator.openAppSettings();
                              } else {
                                weatherProv.getWeatherData(
                                  context,
                                  notify: true,
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 4.0),
                    if (weatherProv.locationPermission ==
                        LocationPermission.deniedForever)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        child: Text('Restart'),
                        onPressed: weatherProv.isLoading
                            ? null
                            : () => weatherProv.getWeatherData(
                                context,
                                notify: true,
                              ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LocationServiceErrorDisplay extends StatefulWidget {
  const LocationServiceErrorDisplay({Key? key}) : super(key: key);

  @override
  State<LocationServiceErrorDisplay> createState() =>
      _LocationServiceErrorDisplayState();
}

class _LocationServiceErrorDisplayState
    extends State<LocationServiceErrorDisplay> {
  late StreamSubscription<ServiceStatus> serviceStatusStream;

  @override
  void initState() {
    super.initState();
    serviceStatusStream = Geolocator.getServiceStatusStream().listen((_) {});
    serviceStatusStream.onData((ServiceStatus status) {
      if (status == ServiceStatus.enabled) {
        print('enabled');
        Provider.of<WeatherProvider>(
          context,
          listen: false,
        ).getWeatherData(context);
      }
    });
  }

  @override
  void dispose() {
    serviceStatusStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width,
              minWidth: 100,
              maxHeight: MediaQuery.sizeOf(context).height / 3,
            ),
            child: Image.asset('assets/images/locError.png'),
          ),
          Center(
            child: Text(
              'Location Service Disabled',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: Text(
              'Your device location service is disabled, please turn it on before continuing',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          Consumer<WeatherProvider>(
            builder: (context, weatherProv, _) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                    padding: const EdgeInsets.all(12.0),
                    shape: StadiumBorder(),
                  ),
                  child: Text('Turn On Service'),
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
