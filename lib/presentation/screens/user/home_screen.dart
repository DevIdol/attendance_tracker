import 'package:attendance_tracker/core/extensions/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/utils.dart';
import '../../../data/data.dart';
import '../../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? mapController;
  LatLng? _currentLocation;
  bool _locationLoading = false;
  bool _showUserCard = true;
  bool _isOnline = true;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      setState(() {
        _isOnline = connectivityResult != ConnectivityResult.none;
      });
      logger.i('Connectivity status: ${_isOnline ? 'Online' : 'Offline'}');
    } catch (e) {
      logger.e('Error checking connectivity: $e');
      setState(() => _isOnline = false);
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        context.showSnackBar('Location services are disabled.', isError: true);
      }
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          context.showSnackBar('Location permissions are denied.',
              isError: true);
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        context.showSnackBar(
          'Location permissions are permanently denied. Please enable them in settings.',
          isError: true,
        );
      }
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    setState(() => _locationLoading = true);

    try {
      logger.i('Getting current location');
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        if (mounted) setState(() => _locationLoading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _markers = {
            Marker(
              markerId: const MarkerId('current_location'),
              position: _currentLocation!,
              infoWindow: const InfoWindow(title: 'Your Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            ),
          };
        });
      }

      final user = ref.read(authNotifierProvider).value;
      if (user != null && _isOnline) {
        try {
          await ref.read(authNotifierProvider.notifier).updateUserLocation(
                user.id,
                GeoPoint(position.latitude, position.longitude),
              );
        } catch (e) {
          logger.e('Failed to update location to Firestore: $e');
        }
      }

      logger.i('Location updated: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      logger.e('Error getting location: $e');
      if (mounted) {
        context.showSnackBar('Error getting location: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _locationLoading = false);
    }
  }

  Future<void> handleCheckInOut() async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) {
      if (mounted) {
        context.showSnackBar('Please log in to continue', isError: true);
      }
      return;
    }

    if (_currentLocation == null) {
      if (mounted) {
        context.showSnackBar('Location unavailable. Please try again.',
            isError: true);
      }
      return;
    }

    try {
      final attendanceState =
          ref.read(attendanceUpsertNotifierProvider(user.id));

      if (attendanceState.hasCheckedInToday) {
        logger.i('User ${user.id} attempting check-out');
        await ref
            .read(attendanceUpsertNotifierProvider(user.id).notifier)
            .checkOut(user.id, user.name);
        if (mounted) context.showSnackBar('Checked out successfully');
      } else {
        logger.i('User ${user.id} attempting check-in');
        await ref
            .read(attendanceUpsertNotifierProvider(user.id).notifier)
            .checkIn(user.id, user.name);
        if (mounted) context.showSnackBar('Checked in successfully');
      }
      await ref
          .read(attendanceUpsertNotifierProvider(user.id).notifier)
          .refreshHasCheckedInToday();
    } catch (e) {
      if (mounted) context.showSnackBar('Error: $e', isError: true);
    }
  }

  Widget _buildOfflineMap() {
    if (_currentLocation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Location not available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Retry Location'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLocation!,
            zoom: 16,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            mapController = controller;
          },
          padding: const EdgeInsets.only(bottom: 80),
          onTap: (latLng) {
            setState(() {
              _markers = {
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: latLng,
                  infoWindow: const InfoWindow(title: 'Selected Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                ),
              };
            });
          },
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton.small(
                onPressed: _getCurrentLocation,
                backgroundColor: Colors.white,
                child: const Icon(Icons.my_location, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                onPressed: _checkConnectivity,
                backgroundColor: Colors.orange,
                child: const Icon(Icons.wifi, color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.wifi_off, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Offline Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineMap() {
    if (_locationLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Getting your location...'),
          ],
        ),
      );
    }

    if (_currentLocation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Location not available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Retry Location'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLocation!,
            zoom: 16,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            mapController = controller;
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(_currentLocation!, 16),
            );
          },
          padding: const EdgeInsets.only(bottom: 80),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: FloatingActionButton.small(
            onPressed: _getCurrentLocation,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(
      User user, AttendanceUpsertState? attendanceState, bool connectivity) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: _showUserCard ? 16 : -200,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () =>
            mounted ? setState(() => _showUserCard = !_showUserCard) : null,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        user.profileImageUrl != null
                            ? CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    NetworkImage(user.profileImageUrl!),
                              )
                            : const CircleAvatar(
                                radius: 24,
                                child: Icon(Icons.person, size: 24),
                              ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        _showUserCard
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: Colors.blue,
                      ),
                      onPressed: () => mounted
                          ? setState(() => _showUserCard = !_showUserCard)
                          : null,
                    ),
                  ],
                ),
                if (_showUserCard) ...[
                  const SizedBox(height: 16),
                  _currentLocation != null
                      ? Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Lat: ${_currentLocation!.latitude.toStringAsFixed(6)}, Lng: ${_currentLocation!.longitude.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 16),
                  if (!connectivity)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off,
                              size: 16, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Working offline. Attendance will sync when online.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: attendanceState?.hasCheckedInToday == true
                        ? 'Check Out Now'
                        : 'Check In Now',
                    isLoading: attendanceState?.isLoading ?? false,
                    onPressed: handleCheckInOut,
                    color: connectivity ? null : AppColors.warning,
                    width: double.infinity,
                  ),
                  if (attendanceState?.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Error: ${attendanceState!.error}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;
    final attendanceState = user != null
        ? ref.watch(attendanceUpsertNotifierProvider(user.id))
        : null;
    final connectivity = ref.watch(connectivityNotifierProvider);

    if (connectivity != _isOnline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _isOnline = connectivity);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Tracker'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: const [
          ConnectivityStatus(),
          ThemeToggleButton(),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _isOnline ? _buildOnlineMap() : _buildOfflineMap(),
          if (user != null) _buildUserCard(user, attendanceState, connectivity),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
