// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:weatherapp/controllers/cyclone_controller.dart';

// class CycloneDetection extends StatefulWidget {
//   const CycloneDetection({super.key});

//   @override
//   State<CycloneDetection> createState() => _CycloneDetectionState();
// }

// class _CycloneDetectionState extends State<CycloneDetection> {
//   final CycloneController cycloneController = Get.put(CycloneController());

//   List<LatLng> _fullPath = [];
//   List<LatLng> _visiblePath = [];
//   Set<Marker> _visibleMarkers = {};
//   Set<Polyline> _polylines = {};
//   int _currentIndex = 0;
//   Timer? _timer;
//   GoogleMapController? _mapController;

//   bool _loading = true;
//   bool _error = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadPath();
//   }

//   void _loadPath() async {
//     try {
//       _fullPath = await cycloneController.fetchCyclonePath();
//       setState(() => _loading = false);
//       _startAnimation();
//     } catch (e) {
//       setState(() {
//         _error = true;
//         _loading = false;
//       });
//     }
//   }

//   void _startAnimation() {
//     _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
//       if (_currentIndex >= _fullPath.length) {
//         timer.cancel();
//         return;
//       }

//       setState(() {
//         LatLng currentPoint = _fullPath[_currentIndex];
//         _visiblePath.add(currentPoint);

//         // Add marker (arrow head only every Nth point)
//         if (_currentIndex % 2 == 0) {
//           _visibleMarkers.add(
//             Marker(
//               markerId: MarkerId('point_$_currentIndex'),
//               position: currentPoint,
//               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//               infoWindow: InfoWindow(title: 'Point ${_currentIndex + 1}'),
//             ),
//           );
//         }

//         // Create gradient polylines
//         _generateGradientPolyline();

//         // Animate camera to current point
//         _mapController?.animateCamera(
//           CameraUpdate.newLatLng(currentPoint),
//         );

//         _currentIndex++;
//       });
//     });
//   }

//   void _generateGradientPolyline() {
//     _polylines.clear();
//     for (int i = 0; i < _visiblePath.length - 1; i++) {
//       final color = HSVColor.fromAHSV(1, (i * 360 / _visiblePath.length) % 360, 1, 1).toColor();
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId('segment_$i'),
//           points: [_visiblePath[i], _visiblePath[i + 1]],
//           color: color,
//           width: 5,
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_error) {
//       return Scaffold(
//         body: Center(child: Text('Failed to load cyclone path')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text("Cyclone Path")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _fullPath.first,
//           zoom: 5,
//         ),
//         onMapCreated: (controller) => _mapController = controller,
//         polylines: _polylines,
//         markers: _visibleMarkers,
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weatherapp/controllers/cyclone_controller.dart';
import 'package:weatherapp/models/cyclone_model.dart';

class CycloneDetection extends StatefulWidget {
  const CycloneDetection({super.key});

  @override
  State<CycloneDetection> createState() => _CycloneDetectionState();
}

class _CycloneDetectionState extends State<CycloneDetection> {
  final CycloneController cycloneController = Get.put(CycloneController());

  List<CyclonePoint> _fullPath = [];
  List<CyclonePoint> _visiblePath = [];
  Set<Marker> _visibleMarkers = {};
  Set<Polyline> _polylines = {};
  int _currentIndex = 0;
  Timer? _timer;
  GoogleMapController? _mapController;

  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadPath();
  }

  void _loadPath() async {
    try {
      _fullPath = await cycloneController.fetchCyclonePath();
      setState(() => _loading = false);
      _startAnimation();
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (_currentIndex >= _fullPath.length) {
        timer.cancel();
        return;
      }

      setState(() {
        CyclonePoint currentPoint = _fullPath[_currentIndex];
        _visiblePath.add(currentPoint);

        // Add marker with name (every Nth point)
        _visibleMarkers.add(
          Marker(
            markerId: MarkerId('point_$_currentIndex'),
            position: currentPoint.toLatLng(),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              title: currentPoint.name.isNotEmpty
                  ? currentPoint.name
                  : 'Point ${_currentIndex + 1}',
            ),
          ),
        );

        _generateGradientPolyline();

        _mapController?.animateCamera(
          CameraUpdate.newLatLng(currentPoint.toLatLng()),
        );

        _currentIndex++;
      });
    });
  }

  void _generateGradientPolyline() {
    _polylines.clear();
    for (int i = 0; i < _visiblePath.length - 1; i++) {
      final color =
          HSVColor.fromAHSV(1, (i * 360 / _visiblePath.length) % 360, 1, 1)
              .toColor();
      _polylines.add(
        Polyline(
          polylineId: PolylineId('segment_$i'),
          points: [_visiblePath[i].toLatLng(), _visiblePath[i + 1].toLatLng()],
          color: color,
          width: 5,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error) {
      return const Scaffold(
        body: Center(child: Text('Failed to load cyclone path')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Cyclone Path")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _fullPath.first.toLatLng(),
          zoom: 5,
        ),
        onMapCreated: (controller) => _mapController = controller,
        polylines: _polylines,
        markers: _visibleMarkers,
      ),
    );
  }
}
