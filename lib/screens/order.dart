class OrderItem {
  final String name;
  final double price;
  final String emoji;
  int quantity;

  OrderItem({
    required this.name,
    required this.price,
    required this.emoji,
    this.quantity = 0,
  });
}

class Order {
  final List<OrderItem> items;
  final String deliveryAddress;
  final DateTime placedAt;

  Order({
    required this.items,
    required this.deliveryAddress,
    required this.placedAt,
  });

  double get total =>
      items.fold(0.0, (double sum, item) => sum + item.price * item.quantity);

  List<OrderItem> get selectedItems =>
      items.where((i) => i.quantity > 0).toList();
}