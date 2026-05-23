import 'package:flutter/material.dart';
import 'order.dart';
import 'delivery_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<OrderItem> _items = [
    OrderItem(name: 'Burger', price: 149.0, emoji: '🍔'),
    OrderItem(name: 'Pizza', price: 299.0, emoji: '🍕'),
    OrderItem(name: 'Fries', price: 79.0, emoji: '🍟'),
    OrderItem(name: 'Soda', price: 49.0, emoji: '🥤'),
    OrderItem(name: 'Salad', price: 129.0, emoji: '🥗'),
    OrderItem(name: 'Chicken Wings', price: 199.0, emoji: '🍗'),
    OrderItem(name: 'Ice Cream', price: 89.0, emoji: '🍦'),
    OrderItem(name: 'Coffee', price: 99.0, emoji: '☕'),
  ];

  final _addressController =
      TextEditingController(text: '123 Quezon Ave, Quezon City');

  double get _total =>
      _items.fold(0.0, (double sum, i) => sum + i.price * i.quantity);
  int get _totalItems => _items.fold(0, (int sum, i) => sum + i.quantity);

  void _placeOrder() {
    if (_totalItems == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Add at least one item!'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a delivery address!'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    final order = Order(
      items: _items
          .map((i) => OrderItem(
                name: i.name,
                price: i.price,
                emoji: i.emoji,
                quantity: i.quantity,
              ))
          .toList(),
      deliveryAddress: _addressController.text.trim(),
      placedAt: DateTime.now(),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DeliveryScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Place Order'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Address bar
          Container(
            color: const Color(0xFFFFF3EE),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFFF6B35)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Deliver to',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Item list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _ItemCard(
                  item: item,
                  onAdd: () => setState(() => item.quantity++),
                  onRemove: () => setState(
                      () => item.quantity = (item.quantity - 1).clamp(0, 99)),
                );
              },
            ),
          ),

          // Bottom summary
          if (_totalItems > 0)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$_totalItems item${_totalItems > 1 ? 's' : ''}',
                          style: const TextStyle(color: Colors.grey)),
                      Text('₱${_total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B35))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _placeOrder,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Place Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}

class _ItemCard extends StatelessWidget {
  final OrderItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const _ItemCard(
      {required this.item, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: item.quantity > 0 ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: item.quantity > 0
            ? const BorderSide(color: Color(0xFFFF6B35), width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('₱${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14)),
                  ]),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: item.quantity > 0 ? onRemove : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: const Color(0xFFFF6B35),
                ),
                Text('${item.quantity}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_circle_outline),
                  color: const Color(0xFFFF6B35),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}