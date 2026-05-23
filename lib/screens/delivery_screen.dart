import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'order.dart';
import 'receive_screen.dart';

enum DeliveryStatus { preparing, onTheWay, arrived }

class DeliveryScreen extends StatefulWidget {
  final Order order;
  const DeliveryScreen({super.key, required this.order});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen>
    with TickerProviderStateMixin {
  static const LatLng _storeLocation = LatLng(14.6507, 121.0480);
  static const LatLng _deliveryLocation = LatLng(14.6360, 121.0340);
  static const List<LatLng> _routeWaypoints = [
    LatLng(14.6507, 121.0480),
    LatLng(14.6490, 121.0460),
    LatLng(14.6470, 121.0440),
    LatLng(14.6450, 121.0420),
    LatLng(14.6430, 121.0400),
    LatLng(14.6410, 121.0380),
    LatLng(14.6390, 121.0365),
    LatLng(14.6370, 121.0350),
    LatLng(14.6360, 121.0340),
  ];

  final MapController _mapController = MapController();
  int _riderWaypointIndex = 0;
  LatLng _riderPosition = _storeLocation;
  Timer? _movementTimer;
  late AnimationController _pulseController;
  DeliveryStatus _status = DeliveryStatus.preparing;
  int _etaMinutes = 20;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _startDeliverySimulation();
  }

  void _startDeliverySimulation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _status = DeliveryStatus.onTheWay);

    _movementTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_riderWaypointIndex < _routeWaypoints.length - 1) {
        setState(() {
          _riderWaypointIndex++;
          _riderPosition = _routeWaypoints[_riderWaypointIndex];
          _etaMinutes = ((_routeWaypoints.length - 1 - _riderWaypointIndex) * 2.2)
              .round().clamp(0, 20);
        });
        try { _mapController.move(_riderPosition, 15.0); } catch (_) {}
      } else {
        timer.cancel();
        setState(() { _status = DeliveryStatus.arrived; _etaMinutes = 0; });
      }
    });
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String get _statusText {
    switch (_status) {
      case DeliveryStatus.preparing: return '🍳 Preparing your order...';
      case DeliveryStatus.onTheWay: return '🏍️ Rider is on the way!';
      case DeliveryStatus.arrived:  return '📦 Your order has arrived!';
    }
  }

  Color get _statusColor {
    switch (_status) {
      case DeliveryStatus.preparing: return Colors.orange;
      case DeliveryStatus.onTheWay:  return const Color(0xFFFF6B35);
      case DeliveryStatus.arrived:   return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏍️ Delivery Tracking'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Status banner
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: _statusColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(_statusText,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                if (_status == DeliveryStatus.onTheWay)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('ETA $_etaMinutes min',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                if (_status == DeliveryStatus.arrived)
                  const Icon(Icons.check_circle, color: Colors.white, size: 24),
              ],
            ),
          ),

          // Progress steps
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              children: [
                _Step(icon: Icons.receipt_long, label: 'Ordered', done: true),
                _StepConnector(active: _status != DeliveryStatus.preparing),
                _Step(
                  icon: Icons.delivery_dining,
                  label: 'On the Way',
                  done: _status == DeliveryStatus.onTheWay ||
                      _status == DeliveryStatus.arrived,
                ),
                _StepConnector(active: _status == DeliveryStatus.arrived),
                _Step(
                  icon: Icons.home,
                  label: 'Arrived',
                  done: _status == DeliveryStatus.arrived,
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(14.6435, 121.0410),
                initialZoom: 14.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.nearbuy.app',
                ),
                PolylineLayer(polylines: [
                  Polyline(
                    points: _routeWaypoints,
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    strokeWidth: 5.0,
                  ),
                  Polyline(
                    points: _routeWaypoints.sublist(0, _riderWaypointIndex + 1),
                    color: const Color(0xFFFF6B35),
                    strokeWidth: 5.0,
                  ),
                ]),
                MarkerLayer(markers: [
                  Marker(
                    point: _storeLocation,
                    width: 56, height: 56,
                    child: const _MapMarker(emoji: '🏪', label: 'Store', color: Colors.blue),
                  ),
                  Marker(
                    point: _deliveryLocation,
                    width: 56, height: 56,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, child) => Transform.scale(
                        scale: 0.9 + 0.1 * _pulseController.value, child: child),
                      child: const _MapMarker(emoji: '📍', label: 'You', color: Colors.green),
                    ),
                  ),
                  if (_status != DeliveryStatus.preparing)
                    Marker(
                      point: _riderPosition,
                      width: 52, height: 52,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (_, child) => Transform.scale(
                          scale: 1.0 + 0.08 * _pulseController.value, child: child),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                              color: const Color(0xFFFF6B35).withOpacity(0.5),
                              blurRadius: 10, spreadRadius: 3,
                            )],
                          ),
                          child: const Center(child: Text('🏍️', style: TextStyle(fontSize: 22))),
                        ),
                      ),
                    ),
                ]),
              ],
            ),
          ),

          // Bottom bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12, offset: const Offset(0, -3),
              )],
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.location_on, color: Color(0xFFFF6B35)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(widget.order.deliveryAddress,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _status == DeliveryStatus.arrived
                        ? () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => ReceiveScreen(order: widget.order)))
                        : null,
                    icon: const Icon(Icons.verified_outlined),
                    label: Text(_status == DeliveryStatus.arrived
                        ? 'Confirm Receipt →'
                        : 'Waiting for delivery...'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _status == DeliveryStatus.arrived
                          ? Colors.green : Colors.grey.shade300,
                      foregroundColor: _status == DeliveryStatus.arrived
                          ? Colors.white : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _Step extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool done;
  const _Step({required this.icon, required this.label, this.done = false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: done ? const Color(0xFFFF6B35) : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: done ? Colors.white : Colors.grey),
      ),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(
          fontSize: 10,
          fontWeight: done ? FontWeight.bold : FontWeight.normal,
          color: done ? const Color(0xFFFF6B35) : Colors.grey)),
    ]);
  }
}

class _StepConnector extends StatelessWidget {
  final bool active;
  const _StepConnector({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 16),
        color: active ? const Color(0xFFFF6B35) : Colors.grey.shade200,
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  const _MapMarker({required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)],
        ),
        padding: const EdgeInsets.all(4),
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
      const SizedBox(height: 2),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Text(label, style: const TextStyle(
            color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
      ),
    ]);
  }
}