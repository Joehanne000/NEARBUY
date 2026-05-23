import 'package:flutter/material.dart';
import 'buyer_dashboard.dart';

// For design preview we go straight to Buyer dashboard.
// Swap with StoreOwnerDashboard or AdminDashboard to preview those.
class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});
  @override
  Widget build(BuildContext context) => const BuyerDashboard();
}