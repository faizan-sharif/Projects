import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';

import '../provider/weatherProvider.dart';

class RequestErrorDisplay extends StatelessWidget {
  const RequestErrorDisplay({Key? key}) : super(key: key);

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
            child: Image.asset('assets/images/requestError.png'),
          ),
          Center(
            child: Text(
              'Request Error',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: Text(
              'Request error, please check your internet connection',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
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
                  child: Text(
                    'Return Home',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                  onPressed: weatherProv.isLoading
                      ? null
                      : () async {
                          await weatherProv.getWeatherData(
                            context,
                            notify: true,
                          );
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

class SearchErrorDisplay extends StatelessWidget {
  const SearchErrorDisplay({Key? key, required this.fsc}) : super(key: key);

  final FloatingSearchBarController fsc;

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
            child: Image.asset('assets/images/searchError.png'),
          ),
          Center(
            child: Text(
              'Search Error',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: Text(
              'Unable to find "${fsc.query}", check for typo or check your internet connection',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
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
                  onPressed: weatherProv.isLoading
                      ? null
                      : () async {
                          await weatherProv.getWeatherData(
                            context,
                            notify: true,
                          );
                        },
                  child: Text(
                    'Return Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
