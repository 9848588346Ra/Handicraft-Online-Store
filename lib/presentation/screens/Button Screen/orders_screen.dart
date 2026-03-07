import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handicraft_online_store/data/models/order_item.dart';
import 'package:handicraft_online_store/data/order_provider.dart';

enum OrderStatus { ongoing, completed }

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({
    super.key,
    this.onStartShopping,
  });

  final VoidCallback? onStartShopping;

  static const Color _primaryPurple = Color(0xFF5E35B1);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildTabsCard(),
              Expanded(
                child: ListenableBuilder(
          listenable: OrderProvider.instance,
          builder: (context, _) {
            return TabBarView(
              children: [
                _OrdersList(
                  orders: OrderProvider.instance.ongoingOrders,
                  status: OrderStatus.ongoing,
                  onStartShopping: onStartShopping,
                ),
                _OrdersList(
                  orders: OrderProvider.instance.completedOrders,
                  status: OrderStatus.completed,
                  onStartShopping: onStartShopping,
                ),
              ],
            );
          },
        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_long_outlined, color: _primaryPurple, size: 26),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Orders',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87),
                ),
                Text('Track and manage your orders', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: _primaryPurple.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: _primaryPurple,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(fontFamily: 'open sans bold', fontSize: 15),
        tabs: const [
          Tab(text: 'Ongoing'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    required this.orders,
    required this.status,
    this.onStartShopping,
  });

  final List<OrderItem> orders;
  final OrderStatus status;
  final VoidCallback? onStartShopping;

  static const Color _primaryPurple = Color(0xFF5E35B1);

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return _EmptyState(onStartShopping: onStartShopping);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _OrderCard(order: orders[index]),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderItem order;

  static const Color _primaryPurple = Color(0xFF5E35B1);

  Widget _buildOrderImage(String path) {
    final errorWidget = Container(
      width: 72,
      height: 72,
      color: Colors.grey.shade200,
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => errorWidget,
      );
    }
    try {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => errorWidget,
        );
      }
    } catch (_) {}
    return errorWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildOrderImage(order.imagePath),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'open sans bold',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.price,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.address,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.onStartShopping});

  final VoidCallback? onStartShopping;

  static const Color _primaryPurple = Color(0xFF5E35B1);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _primaryPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: _primaryPurple.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'open sans bold',
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start shopping to see your orders here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onStartShopping,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Shopping',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'open sans bold',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
