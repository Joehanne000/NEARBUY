import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import 'login_screen.dart';

final _mockOrders = [
  {'id': '#2041', 'buyer': 'Maria Santos', 'total': '₱267', 'status': 'PENDING', 'items': 'Adobo Rice Bowl x2, Lechon Kawali'},
  {'id': '#2040', 'buyer': 'Jose Reyes', 'total': '₱89', 'status': 'PREPARING', 'items': 'Adobo Rice Bowl x1'},
  {'id': '#2039', 'buyer': 'Ana Lim', 'total': '₱356', 'status': 'READY', 'items': 'Sinigang na Baboy x2, Rice x2'},
  {'id': '#2038', 'buyer': 'Pedro Cruz', 'total': '₱178', 'status': 'COMPLETED', 'items': 'Kare-Kare, Rice x1'},
];

final _mockProducts = [
  {'name': 'Adobo Rice Bowl', 'price': '₱89', 'stock': '24', 'status': 'ACTIVE'},
  {'name': 'Sinigang na Baboy', 'price': '₱149', 'stock': '12', 'status': 'ACTIVE'},
  {'name': 'Kare-Kare', 'price': '₱189', 'stock': '0', 'status': 'OUT_OF_STOCK'},
  {'name': 'Lechon Kawali', 'price': '₱129', 'stock': '8', 'status': 'ACTIVE'},
  {'name': 'Pancit Canton', 'price': '₱79', 'stock': '15', 'status': 'ACTIVE'},
];

class StoreOwnerDashboard extends StatefulWidget {
  const StoreOwnerDashboard({super.key});
  @override
  State<StoreOwnerDashboard> createState() => _StoreOwnerDashboardState();
}

class _StoreOwnerDashboardState extends State<StoreOwnerDashboard> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NbColors.bg,
      appBar: _appBar(),
      body: IndexedStack(
        index: _tab,
        children: const [_OverviewTab(), _OrdersTab(), _ProductsTab()],
      ),
      bottomNavigationBar: _nav(),
      floatingActionButton: _tab == 2
          ? FloatingActionButton(
              backgroundColor: NbColors.accent,
              child: const Icon(Icons.add_rounded, color: Colors.black),
              onPressed: () {},
            )
          : null,
    );
  }

  AppBar _appBar() => AppBar(
    backgroundColor: NbColors.surface,
    leading: Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: NbColors.accent.withOpacity(.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.store_rounded, color: NbColors.accent, size: 20),
      ),
    ),
    title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Mama Rosa\'s Kitchen', style: TextStyle(
          color: NbColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
      Text('Store Dashboard', style: TextStyle(color: NbColors.textSecondary, fontSize: 11)),
    ]),
    actions: [
      IconButton(
        icon: const Icon(Icons.logout_rounded, color: NbColors.textSecondary),
        onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const LoginScreen())),
      ),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(height: 1, color: NbColors.border),
    ),
  );

  Widget _nav() => NavigationBar(
    selectedIndex: _tab,
    onDestinationSelected: (i) => setState(() => _tab = i),
    backgroundColor: NbColors.surface,
    indicatorColor: NbColors.accent.withOpacity(.12),
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined, color: NbColors.textMuted),
        selectedIcon: Icon(Icons.dashboard_rounded, color: NbColors.accent),
        label: 'Overview',
      ),
      NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined, color: NbColors.textMuted),
        selectedIcon: Icon(Icons.receipt_long_rounded, color: NbColors.accent),
        label: 'Orders',
      ),
      NavigationDestination(
        icon: Icon(Icons.inventory_2_outlined, color: NbColors.textMuted),
        selectedIcon: Icon(Icons.inventory_2_rounded, color: NbColors.accent),
        label: 'Products',
      ),
    ],
  );
}

// ── Overview ──────────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  const _OverviewTab();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Store status toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: NbColors.accent.withOpacity(.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NbColors.accent.withOpacity(.25)),
          ),
          child: Row(children: [
            Container(
              width: 10, height: 10,
              decoration: const BoxDecoration(color: NbColors.accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            const Expanded(child: Text('Store is Open',
                style: TextStyle(color: NbColors.accent, fontWeight: FontWeight.w700))),
            Switch(value: true, onChanged: (_) {},
                activeColor: NbColors.accent, activeTrackColor: NbColors.accent.withOpacity(.3)),
          ]),
        ),
        const SizedBox(height: 20),

        // Stats
        Row(children: const [
          Expanded(child: NbStatCard(label: 'Pending', value: '2', icon: Icons.hourglass_empty_rounded, color: NbColors.warning)),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Preparing', value: '1', icon: Icons.restaurant_rounded, color: NbColors.primary)),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Today\'s Sales', value: '₱890', icon: Icons.payments_rounded, color: NbColors.accent)),
        ]),
        const SizedBox(height: 20),
        Row(children: const [
          Expanded(child: NbStatCard(label: 'Products', value: '5', icon: Icons.inventory_2_rounded, color: Color(0xFF818CF8))),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Total Orders', value: '41', icon: Icons.receipt_long_rounded, color: Color(0xFFF472B6))),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Avg Rating', value: '4.9', icon: Icons.star_rounded, color: NbColors.warning)),
        ]),
        const SizedBox(height: 24),

        // Recent orders preview
        const NbSectionHeader(title: 'Recent Orders'),
        const SizedBox(height: 12),
        ..._mockOrders.take(3).map((o) => _OrderRow(order: o)),
      ]),
    );
  }
}

// ── Orders Tab ────────────────────────────────────────────────────────────────
class _OrdersTab extends StatelessWidget {
  const _OrdersTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const NbSectionHeader(title: 'All Orders'),
        const SizedBox(height: 16),
        ..._mockOrders.map((o) => _OrderCard(order: o)),
      ],
    );
  }
}

class _OrderRow extends StatelessWidget {
  final Map order;
  const _OrderRow({required this.order});

  Color _color(String s) {
    switch (s) {
      case 'PENDING': return NbColors.warning;
      case 'PREPARING': return NbColors.primary;
      case 'READY': return NbColors.accent;
      case 'COMPLETED': return NbColors.textSecondary;
      default: return NbColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NbColors.border),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${order['id']} · ${order['buyer']}',
              style: const TextStyle(color: NbColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 3),
          Text(order['total'] as String,
              style: const TextStyle(color: NbColors.accent, fontWeight: FontWeight.w800)),
        ])),
        NbBadge(label: status, color: _color(status)),
      ]),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final Map order;
  const _OrderCard({required this.order});
  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.order['status'] as String;
  }

  Color _color(String s) {
    switch (s) {
      case 'PENDING': return NbColors.warning;
      case 'PREPARING': return NbColors.primary;
      case 'READY': return NbColors.accent;
      case 'COMPLETED': return NbColors.textSecondary;
      default: return NbColors.danger;
    }
  }

  String? get _nextStatus {
    switch (_status) {
      case 'PENDING': return 'PREPARING';
      case 'PREPARING': return 'READY';
      case 'READY': return 'COMPLETED';
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(_status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NbColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Order ${widget.order['id']}',
                style: const TextStyle(color: NbColors.textPrimary,
                    fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 2),
            Text(widget.order['buyer'] as String,
                style: const TextStyle(color: NbColors.textSecondary, fontSize: 13)),
          ])),
          NbBadge(label: _status, color: color),
        ]),
        const SizedBox(height: 10),
        Text(widget.order['items'] as String,
            style: const TextStyle(color: NbColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 10),
        Container(height: 1, color: NbColors.border),
        const SizedBox(height: 10),
        Row(children: [
          Text(widget.order['total'] as String,
              style: const TextStyle(color: NbColors.accent,
                  fontWeight: FontWeight.w800, fontSize: 16)),
          const Spacer(),
          if (_status == 'PENDING')
            TextButton(
              onPressed: () => setState(() => _status = 'CANCELLED'),
              style: TextButton.styleFrom(foregroundColor: NbColors.danger),
              child: const Text('Cancel'),
            ),
          if (_nextStatus != null)
            ElevatedButton(
              onPressed: () => setState(() => _status = _nextStatus!),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(_status == 'PENDING'
                  ? 'Confirm'
                  : _status == 'PREPARING'
                      ? 'Mark Ready'
                      : 'Complete',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
        ]),
      ]),
    );
  }
}

// ── Products Tab ──────────────────────────────────────────────────────────────
class _ProductsTab extends StatelessWidget {
  const _ProductsTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const NbSectionHeader(title: 'My Products'),
        const SizedBox(height: 16),
        ..._mockProducts.map((p) => _ProductRow(product: p)),
      ],
    );
  }
}

class _ProductRow extends StatelessWidget {
  final Map product;
  const _ProductRow({required this.product});
  @override
  Widget build(BuildContext context) {
    final outOfStock = product['status'] == 'OUT_OF_STOCK';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: outOfStock
            ? NbColors.danger.withOpacity(.3) : NbColors.border),
      ),
      child: Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: NbColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.fastfood_rounded, color: NbColors.textMuted, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product['name'] as String,
              style: const TextStyle(color: NbColors.textPrimary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text('${product['price']}  ·  Stock: ${product['stock']}',
              style: const TextStyle(color: NbColors.textSecondary, fontSize: 12)),
        ])),
        const SizedBox(width: 8),
        NbBadge(
          label: outOfStock ? 'OUT' : 'ACTIVE',
          color: outOfStock ? NbColors.danger : NbColors.accent,
        ),
        const SizedBox(width: 6),
        Icon(Icons.more_vert_rounded, color: NbColors.textMuted, size: 20),
      ]),
    );
  }
}