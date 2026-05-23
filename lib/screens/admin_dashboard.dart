import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import 'login_screen.dart';

final _mockUsers = [
  {'name': 'Maria Santos', 'email': 'maria@email.com', 'role': 'BUYER', 'banned': false},
  {'name': 'Jose Reyes', 'email': 'jose@email.com', 'role': 'STORE_OWNER', 'banned': false},
  {'name': 'Ana Lim', 'email': 'ana@email.com', 'role': 'BUYER', 'banned': true},
  {'name': 'Pedro Cruz', 'email': 'pedro@email.com', 'role': 'STORE_OWNER', 'banned': false},
  {'name': 'Rosa Garcia', 'email': 'rosa@email.com', 'role': 'BUYER', 'banned': false},
];

final _mockStores = [
  {'name': 'Mama Rosa\'s Kitchen', 'owner': 'Jose Reyes', 'status': 'ACTIVE', 'orders': '41'},
  {'name': 'Sunrise Bakery', 'owner': 'Pedro Cruz', 'status': 'ACTIVE', 'orders': '28'},
  {'name': 'FreshMart Grocery', 'owner': 'Ana Lim', 'status': 'SUSPENDED', 'orders': '15'},
];

final _mockFeedback = [
  {'user': 'Maria Santos', 'subject': 'Delivery was too slow', 'msg': 'My order took over an hour to arrive.', 'date': 'May 22'},
  {'user': 'Pedro Cruz', 'subject': 'App crashes on checkout', 'msg': 'The app crashes when I try to confirm order.', 'date': 'May 21'},
  {'user': 'Rosa Garcia', 'subject': 'Love the app!', 'msg': 'Very convenient, keep up the great work!', 'date': 'May 20'},
];

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _tab = 0;
  late List _users;

  @override
  void initState() {
    super.initState();
    _users = List.from(_mockUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NbColors.bg,
      appBar: _appBar(),
      body: IndexedStack(
        index: _tab,
        children: [_overviewTab(), _usersTab(), _feedbackTab()],
      ),
      bottomNavigationBar: _nav(),
    );
  }

  AppBar _appBar() => AppBar(
    backgroundColor: NbColors.surface,
    leading: Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: NbColors.danger.withOpacity(.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.admin_panel_settings_rounded,
            color: NbColors.danger, size: 20),
      ),
    ),
    title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Admin Panel', style: TextStyle(
          color: NbColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
      Text('NearBuy System', style: TextStyle(color: NbColors.textSecondary, fontSize: 11)),
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
    indicatorColor: NbColors.danger.withOpacity(.12),
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined, color: NbColors.textMuted),
        selectedIcon: Icon(Icons.dashboard_rounded, color: NbColors.danger),
        label: 'Overview',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_outlined, color: NbColors.textMuted),
        selectedIcon: Icon(Icons.people_rounded, color: NbColors.danger),
        label: 'Users',
      ),
      NavigationDestination(
        icon: Icon(Icons.feedback_outlined, color: NbColors.textMuted),
        selectedIcon: Icon(Icons.feedback_rounded, color: NbColors.danger),
        label: 'Feedback',
      ),
    ],
  );

  // ── Overview ────────────────────────────────────────────────────────────────
  Widget _overviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Expanded(child: NbStatCard(label: 'Total Users', value: '5', icon: Icons.people_rounded, color: NbColors.primary)),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Stores', value: '3', icon: Icons.store_rounded, color: NbColors.accent)),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Feedback', value: '3', icon: Icons.feedback_rounded, color: NbColors.warning)),
        ]),
        const SizedBox(height: 20),
        Row(children: const [
          Expanded(child: NbStatCard(label: 'Revenue', value: '₱12k', icon: Icons.payments_rounded, color: Color(0xFF10B981))),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Banned', value: '1', icon: Icons.block_rounded, color: NbColors.danger)),
          SizedBox(width: 12),
          Expanded(child: NbStatCard(label: 'Active', value: '2', icon: Icons.store_rounded, color: Color(0xFF818CF8))),
        ]),
        const SizedBox(height: 24),

        const NbSectionHeader(title: 'Stores'),
        const SizedBox(height: 12),
        ..._mockStores.map((s) {
          final suspended = s['status'] == 'SUSPENDED';
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NbColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NbColors.border),
            ),
            child: Row(children: [
              const Icon(Icons.store_rounded, color: NbColors.textMuted, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s['name']!, style: const TextStyle(color: NbColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                Text('${s['orders']} orders', style: const TextStyle(color: NbColors.textSecondary, fontSize: 11)),
              ])),
              NbBadge(
                label: s['status']!,
                color: suspended ? NbColors.danger : NbColors.accent,
              ),
            ]),
          );
        }),
      ]),
    );
  }

  // ── Users Tab ────────────────────────────────────────────────────────────────
  Widget _usersTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const NbSectionHeader(title: 'All Users'),
        const SizedBox(height: 16),
        ..._users.asMap().entries.map((e) {
          final i = e.key;
          final u = e.value;
          final banned = u['banned'] as bool;
          final role = u['role'] as String;

          Color roleColor;
          switch (role) {
            case 'ADMIN': roleColor = NbColors.danger; break;
            case 'STORE_OWNER': roleColor = NbColors.accent; break;
            default: roleColor = NbColors.primary;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NbColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: banned ? NbColors.danger.withOpacity(.3) : NbColors.border),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: roleColor.withOpacity(.12),
                child: Text((u['name'] as String)[0],
                    style: TextStyle(color: roleColor, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(u['name'] as String,
                    style: const TextStyle(color: NbColors.textPrimary,
                        fontWeight: FontWeight.w700, fontSize: 13)),
                Text(u['email'] as String,
                    style: const TextStyle(color: NbColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 4),
                NbBadge(label: role, color: roleColor),
              ])),
              const SizedBox(width: 8),
              if (role != 'ADMIN')
                GestureDetector(
                  onTap: () => setState(() => _users[i]['banned'] = !banned),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: banned
                          ? NbColors.accent.withOpacity(.1)
                          : NbColors.danger.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      banned ? Icons.lock_open_rounded : Icons.block_rounded,
                      color: banned ? NbColors.accent : NbColors.danger,
                      size: 18,
                    ),
                  ),
                ),
            ]),
          );
        }),
      ],
    );
  }

  // ── Feedback Tab ─────────────────────────────────────────────────────────────
  Widget _feedbackTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const NbSectionHeader(title: 'User Feedback'),
        const SizedBox(height: 16),
        ..._mockFeedback.map((f) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NbColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NbColors.border),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.feedback_rounded, color: NbColors.warning, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(f['subject']!,
                  style: const TextStyle(color: NbColors.textPrimary,
                      fontWeight: FontWeight.w700, fontSize: 14))),
              Text(f['date']!,
                  style: const TextStyle(color: NbColors.textMuted, fontSize: 11)),
            ]),
            const SizedBox(height: 8),
            Text(f['msg']!,
                style: const TextStyle(color: NbColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            Text('— ${f['user']}',
                style: const TextStyle(color: NbColors.textMuted, fontSize: 11,
                    fontStyle: FontStyle.italic)),
          ]),
        )),
      ],
    );
  }
}