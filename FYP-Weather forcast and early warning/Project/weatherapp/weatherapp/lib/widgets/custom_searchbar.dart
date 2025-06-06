import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/provider/weatherProvider.dart';

class CustomSearchBar extends StatefulWidget {
  final FloatingSearchBarController fsc;
  const CustomSearchBar({Key? key, required this.fsc}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  List<CitySuggestion> _citySuggestions = [];
  Timer? _debounce;

  Future<void> _fetchCitySuggestions(String query) async {
    if (query.trim().length < 2) return;

    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search?format=json&limit=5'
      '&addressdetails=1&q=$query&class=place&type=city',
    );

    try {
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'GlowGradeApp/1.0 (glow@grade.app)'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        final List<CitySuggestion> cities = data.map<CitySuggestion>((item) {
          return CitySuggestion(
            displayName: item['display_name'],
            lat: double.tryParse(item['lat']) ?? 0.0,
            lon: double.tryParse(item['lon']) ?? 0.0,
          );
        }).toList();

        setState(() {
          _citySuggestions = cities;
        });
      } else {
        setState(() {
          _citySuggestions = [];
        });
      }
    } catch (e) {
      setState(() {
        _citySuggestions = [];
      });
    }
  }

  void _onQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchCitySuggestions(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: widget.fsc,
      hint: 'Search...',
      clearQueryOnClose: false,
      scrollPadding: const EdgeInsets.only(top: 16.0, bottom: 56.0),
      transitionDuration: const Duration(milliseconds: 400),
      borderRadius: BorderRadius.circular(16.0),
      transitionCurve: Curves.easeInOut,
      accentColor: Theme.of(context).primaryColor,
      hintStyle: Theme.of(context).textTheme.bodySmall,
      queryStyle: Theme.of(context).textTheme.bodySmall,
      physics: const BouncingScrollPhysics(),
      elevation: 2.0,
      debounceDelay: const Duration(milliseconds: 0), // handled manually
      onQueryChanged: _onQueryChanged,
      onSubmitted: (query) async {
        widget.fsc.close();
        await Provider.of<WeatherProvider>(
          context,
          listen: false,
        ).searchWeather(query);
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: PhosphorIcon(
            PhosphorIconsBold.magnifyingGlass,
            color: Theme.of(context).primaryColor,
          ),
        ),
        FloatingSearchBarAction.icon(
          showIfClosed: false,
          showIfOpened: true,
          icon: PhosphorIcon(
            PhosphorIconsBold.x,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () {
            if (widget.fsc.query.isEmpty) {
              widget.fsc.close();
            } else {
              widget.fsc.clear();
              setState(() => _citySuggestions = []);
            }
          },
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _citySuggestions.length,
              itemBuilder: (context, index) {
                final city = _citySuggestions[index];
                return InkWell(
                  onTap: () async {
                    widget.fsc.query = city.displayName;
                    widget.fsc.close();
                    await Provider.of<WeatherProvider>(
                      context,
                      listen: false,
                    ).searchWeatherLatLng(city.lat, city.lon); // <- New method
                  },
                  child: Container(
                    padding: const EdgeInsets.all(22.0),
                    child: Row(
                      children: [
                        PhosphorIcon(PhosphorIconsFill.mapPin),
                        const SizedBox(width: 22.0),
                        Expanded(
                          child: Text(
                            city.displayName,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(thickness: 1.0, height: 0.0),
            ),
          ),
        );
      },
    );
  }
}

class CitySuggestion {
  final String displayName;
  final double lat;
  final double lon;

  CitySuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
  });
}
