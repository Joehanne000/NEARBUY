import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import 'login_screen.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────
final _stores = [
  {'name': 'Mama Rosa\'s Kitchen', 'category': 'Filipino Food', 'rating': '4.9', 'eta': '15 min', 'distance': '0.3 km', 'open': true},
  {'name': 'Sunrise Bakery', 'category': 'Bread & Pastries', 'rating': '4.7', 'eta': '20 min', 'distance': '0.5 km', 'open': true},
  {'name': 'FreshMart Grocery', 'category': 'Grocery', 'rating': '4.5', 'eta': '30 min', 'distance': '0.8 km', 'open': true},
  {'name': 'Takoyaki Express', 'category': 'Japanese Snacks', 'rating': '4.8', 'eta': '12 min', 'distance': '0.4 km', 'open': false},
];

final _products = [
  {'name': 'Adobo Rice Bowl', 'store': 'Mama Rosa\'s', 'price': '₱89', 'tag': 'Best Seller'},
  {'name': 'Pan de Sal (6 pcs)', 'store': 'Sunrise Bakery', 'price': '₱35', 'tag': 'Popular'},
  {'name': 'Milk Tea Large', 'store': 'Brew & Co.', 'price': '₱120', 'tag': 'New'},
  {'name': 'Takoyaki 6 pcs', 'store': 'Takoyaki Express', 'price': '₱75', 'tag': 'Popular'},
  {'name': 'Sinigang na Baboy', 'store': 'Mama Rosa\'s', 'price': '₱149', 'tag': 'Best Seller'},
  {'name': 'Fresh Ensaymada', 'store': 'Sunrise Bakery', 'price': '₱55', 'tag': ''},
];

final _orders = [
  {'id': '#2041', 'store': 'Mama Rosa\'s Kitchen', 'total': '₱267', 'status': 'PREPARING', 'items': '3 items'},
  {'id': '#2038', 'store': 'Sunrise Bakery', 'total': '₱105', 'status': 'COMPLETED', 'items': '2 items'},
  {'id': '#2035', 'store': 'FreshMart Grocery', 'total': '₱580', 'status': 'COMPLETED', 'items': '7 items'},
];

// ─────────────────────────────────────────────────────────────────────────────

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});
  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NbColors.bg,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _tab,
        children: const [_HomeTab(), _ProductsTab(), _OrdersTab(), _ProfileTab()],
      ),
      bottomNavigationBar: _buildNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: NbColors.surface,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF4F8EF7), Color(0xFF7B5EA7)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
        ),
      ),
      title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('NearBuy', style: TextStyle(
            color: NbColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
        Text('Quezon City, Metro Manila',
            style: TextStyle(color: NbColors.textSecondary, fontSize: 11)),
      ]),
      actions: [
        Stack(children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: NbColors.textSecondary),
            onPressed: () {},
          ),
          Positioned(top: 10, right: 10,
            child: Container(width: 8, height: 8,
              decoration: const BoxDecoration(
                  color: NbColors.danger, shape: BoxShape.circle)),
          ),
        ]),
        IconButton(
          icon: const CircleAvatar(
            radius: 14,
            backgroundColor: NbColors.card,
            child: Icon(Icons.person_outline_rounded,
                color: NbColors.textSecondary, size: 18),
          ),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const LoginScreen())),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: NbColors.border),
      ),
    );
  }

  Widget _buildNav() {
    return NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (i) => setState(() => _tab = i),
      backgroundColor: NbColors.surface,
      indicatorColor: NbColors.primary.withOpacity(.15),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: NbColors.textMuted),
          selectedIcon: Icon(Icons.home_rounded, color: NbColors.primary),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined, color: NbColors.textMuted),
          selectedIcon: Icon(Icons.grid_view_rounded, color: NbColors.primary),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined, color: NbColors.textMuted),
          selectedIcon: Icon(Icons.receipt_long_rounded, color: NbColors.primary),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded, color: NbColors.textMuted),
          selectedIcon: Icon(Icons.person_rounded, color: NbColors.primary),
          label: 'Profile',
        ),
      ],
    );
  }
}

// ── Home Tab ──────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Search
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: NbColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: NbColors.border),
          ),
          child: const Row(children: [
            SizedBox(width: 14),
            Icon(Icons.search_rounded, color: NbColors.textMuted, size: 20),
            SizedBox(width: 10),
            Text('Search stores or products...',
                style: TextStyle(color: NbColors.textMuted, fontSize: 14)),
          ]),
        ),
        const SizedBox(height: 24),

        // Categories
        const NbSectionHeader(title: 'Categories'),
        const SizedBox(height: 12),
        SizedBox(
          height: 82,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _CategoryChip(Icons.rice_bowl_outlined, 'Food', NbColors.warning),
              _CategoryChip(Icons.bakery_dining_outlined, 'Bakery', NbColors.accent),
              _CategoryChip(Icons.local_grocery_store_outlined, 'Grocery', NbColors.primary),
              _CategoryChip(Icons.local_drink_outlined, 'Drinks', const Color(0xFFF472B6)),
              _CategoryChip(Icons.medication_outlined, 'Pharmacy', const Color(0xFF818CF8)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Nearby stores
        NbSectionHeader(title: 'Nearby Stores', action: 'See all', onAction: () {}),
        const SizedBox(height: 12),
        ..._stores.map((s) => _StoreCard(store: s)),
      ]),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _CategoryChip(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 70,
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Map store;
  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    final open = store['open'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NbColors.border),
      ),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: NbColors.primary.withOpacity(.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.store_rounded, color: NbColors.primary, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(store['name'],
                style: const TextStyle(color: NbColors.textPrimary,
                    fontWeight: FontWeight.w700, fontSize: 14))),
            NbBadge(
              label: open ? 'OPEN' : 'CLOSED',
              color: open ? NbColors.accent : NbColors.textMuted,
            ),
          ]),
          const SizedBox(height: 4),
          Text(store['category'],
              style: const TextStyle(color: NbColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.star_rounded, color: NbColors.warning, size: 14),
            const SizedBox(width: 3),
            Text(store['rating'],
                style: const TextStyle(color: NbColors.textSecondary, fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 12),
            const Icon(Icons.schedule_rounded, color: NbColors.textMuted, size: 13),
            const SizedBox(width: 3),
            Text(store['eta'],
                style: const TextStyle(color: NbColors.textSecondary, fontSize: 12)),
            const SizedBox(width: 12),
            const Icon(Icons.location_on_outlined, color: NbColors.textMuted, size: 13),
            const SizedBox(width: 3),
            Text(store['distance'],
                style: const TextStyle(color: NbColors.textSecondary, fontSize: 12)),
          ]),
        ])),
      ]),
    );
  }
}

// ── Products Tab ──────────────────────────────────────────────────────────────
class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: NbColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: NbColors.border),
          ),
          child: const Row(children: [
            SizedBox(width: 14),
            Icon(Icons.search_rounded, color: NbColors.textMuted, size: 20),
            SizedBox(width: 10),
            Text('Search products...', style: TextStyle(color: NbColors.textMuted, fontSize: 14)),
          ]),
        ),
      ),
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: _products.length,
          itemBuilder: (_, i) => _ProductCard(product: _products[i]),
        ),
      ),
    ]);
  }
}

class _ProductCard extends StatelessWidget {
  final Map product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final tag = product['tag'] as String;
    return Container(
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NbColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image area
        Expanded(
          child: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                color: NbColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: const Center(
                child: Icon(Icons.fastfood_rounded, color: NbColors.textMuted, size: 44)),
            ),
            if (tag.isNotEmpty)
              Positioned(top: 10, left: 10,
                child: NbBadge(label: tag,
                  color: tag == 'New' ? NbColors.accent : NbColors.warning)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product['name'],
                style: const TextStyle(color: NbColors.textPrimary,
                    fontWeight: FontWeight.w700, fontSize: 13),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(product['store'],
                style: const TextStyle(color: NbColors.textSecondary, fontSize: 11),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(children: [
              Text(product['price'],
                  style: const TextStyle(color: NbColors.primary,
                      fontWeight: FontWeight.w800, fontSize: 15)),
              const Spacer(),
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: NbColors.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_rounded, color: NbColors.primary, size: 18),
              ),
            ]),
          ]),
        ),
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
        const NbSectionHeader(title: 'My Orders'),
        const SizedBox(height: 16),
        ..._orders.map((o) => _OrderCard(order: o)),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map order;
  const _OrderCard({required this.order});

  Color _statusColor(String s) {
    switch (s) {
      case 'PREPARING': return NbColors.warning;
      case 'COMPLETED': return NbColors.accent;
      case 'CANCELLED': return NbColors.danger;
      default: return NbColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String;
    final color = _statusColor(status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NbColors.border),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.receipt_long_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Order ${order['id']}',
                style: const TextStyle(color: NbColors.textPrimary,
                    fontWeight: FontWeight.w700, fontSize: 14)),
            Text(order['store'],
                style: const TextStyle(color: NbColors.textSecondary, fontSize: 12)),
          ])),
          NbBadge(label: status, color: color),
        ]),
        const SizedBox(height: 12),
        Container(height: 1, color: NbColors.border),
        const SizedBox(height: 12),
        Row(children: [
          Text(order['items'],
              style: const TextStyle(color: NbColors.textSecondary, fontSize: 13)),
          const Spacer(),
          Text(order['total'],
              style: const TextStyle(color: NbColors.primary,
                  fontWeight: FontWeight.w800, fontSize: 16)),
        ]),
      ]),
    );
  }
}

// ── Profile Tab ───────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        // Avatar
        Container(
          width: 88, height: 88,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF4F8EF7), Color(0xFF7B5EA7)]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(
                color: NbColors.primary.withOpacity(.3),
                blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 14),
        const Text('Juan dela Cruz', style: TextStyle(
            color: NbColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('juan@email.com', style: TextStyle(color: NbColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        const NbBadge(label: 'BUYER', color: NbColors.primary),
        const SizedBox(height: 28),

        // Stats
        Row(children: const [
          Expanded(child: NbStatCard(label: 'Orders', value: '12', icon: Icons.receipt_long_rounded, color: NbColors.primary)),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Favorites', value: '5', icon: Icons.favorite_rounded, color: Color(0xFFF472B6))),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Reviews', value: '8', icon: Icons.star_rounded, color: NbColors.warning)),
        ]),
        const SizedBox(height: 24),

        // Menu items
        _MenuItem(Icons.person_outline_rounded, 'Edit Profile', NbColors.primary),
        _MenuItem(Icons.location_on_outlined, 'Saved Addresses', NbColors.accent),
        _MenuItem(Icons.notifications_outlined, 'Notifications', NbColors.warning),
        _MenuItem(Icons.feedback_outlined, 'Send Feedback', const Color(0xFF818CF8)),
        _MenuItem(Icons.help_outline_rounded, 'Help & Support', NbColors.textSecondary),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const LoginScreen())),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NbColors.danger.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: NbColors.danger.withOpacity(.2)),
            ),
            child: const Row(children: [
              Icon(Icons.logout_rounded, color: NbColors.danger, size: 20),
              SizedBox(width: 14),
              Text('Sign Out', style: TextStyle(
                  color: NbColors.danger, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MenuItem(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NbColors.border),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 14),
        Expanded(child: Text(label,
            style: const TextStyle(color: NbColors.textPrimary,
                fontWeight: FontWeight.w500, fontSize: 14))),
        const Icon(Icons.chevron_right_rounded, color: NbColors.textMuted, size: 20),
      ]),
    );
  }
}