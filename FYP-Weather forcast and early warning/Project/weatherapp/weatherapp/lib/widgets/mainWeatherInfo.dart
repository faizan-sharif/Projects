import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/helper/extensions.dart';
import 'package:weatherapp/helper/utils.dart';
import 'package:weatherapp/provider/weatherProvider.dart';

import 'customShimmer.dart';

class MainWeatherInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProv, _) {
        if (weatherProv.isLoading) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: CustomShimmer(height: 148.0, width: 148.0)),
              const SizedBox(width: 16.0),
              CustomShimmer(height: 148.0, width: 148.0),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(
                              weatherProv.isCelsius
                                  ? weatherProv.weather.temp.toStringAsFixed(1)
                                  : weatherProv.weather.temp
                                        .toFahrenheit()
                                        .toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              weatherProv.measurementUnit,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: Colors.grey.shade700,
                                    fontSize: 26,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      weatherProv.weather.description.toTitleCase(),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 148.0,
                width: 148.0,
                child: Image.asset(
                  getWeatherImage(weatherProv.weather.weatherCategory),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
