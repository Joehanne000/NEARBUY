import 'package:flutter/material.dart';
import 'order.dart';
import 'order_screen.dart';

class ReceiveScreen extends StatefulWidget {
  final Order order;
  const ReceiveScreen({super.key, required this.order});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen>
    with SingleTickerProviderStateMixin {
  bool _confirmed = false;
  late AnimationController _checkController;
  late Animation<double> _checkAnim;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkAnim = CurvedAnimation(parent: _checkController, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  void _confirmReceipt() {
    setState(() => _confirmed = true);
    _checkController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = widget.order.selectedItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📦 Confirm Receipt'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // Top icon
            if (_confirmed)
              ScaleTransition(
                scale: _checkAnim,
                child: Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 3),
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 56),
                ),
              )
            else
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3EE),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF6B35), width: 3),
                ),
                child: const Center(child: Text('📦', style: TextStyle(fontSize: 44))),
              ),

            const SizedBox(height: 16),
            Text(
              _confirmed ? 'Order Received! 🎉' : 'Your order has arrived!',
              style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold,
                color: _confirmed ? Colors.green : const Color(0xFFFF6B35),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _confirmed
                  ? 'Thank you for using NearBuy!'
                  : 'Please check your items and confirm receipt.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Receipt card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.receipt_long, color: Color(0xFFFF6B35)),
                      const SizedBox(width: 8),
                      const Text('Order Summary',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('#${widget.order.placedAt.millisecondsSinceEpoch % 100000}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ]),
                    const Divider(height: 20),
                    ...selectedItems.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(children: [
                        Text(item.emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(item.name, style: const TextStyle(fontSize: 15))),
                        Text('x${item.quantity}',
                            style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(width: 12),
                        Text('₱${(item.price * item.quantity).toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ]),
                    )),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Paid',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('₱${widget.order.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B35))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text(widget.order.deliveryAddress,
                          style: const TextStyle(color: Colors.grey, fontSize: 12))),
                    ]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Star rating after confirm
            if (_confirmed) ...[
              const Text('Rate your experience',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5,
                    (i) => const Icon(Icons.star, color: Color(0xFFFFB800), size: 36)),
              ),
              const SizedBox(height: 24),
            ],

            // Action button
            SizedBox(
              width: double.infinity,
              child: _confirmed
                  ? ElevatedButton.icon(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const OrderScreen()),
                        (_) => false,
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Order Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: _confirmReceipt,
                      icon: const Icon(Icons.check),
                      label: const Text('I Received My Order ✓'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
            ),

            if (!_confirmed) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('📞 Support notified. We\'ll resolve this shortly.'),
                    backgroundColor: Colors.orange,
                  ),
                ),
                child: const Text('Report an issue', style: TextStyle(color: Colors.grey)),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}