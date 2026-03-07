import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/data/delivery_address_provider.dart';
import 'package:handicraft_online_store/data/models/delivery_address.dart';
import 'package:handicraft_online_store/data/models/order_item.dart';
import 'package:handicraft_online_store/data/order_provider.dart';
import 'package:handicraft_online_store/presentation/screens/login_screen.dart';
import 'package:handicraft_online_store/presentation/screens/signup_screen.dart';

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
    return FutureBuilder(
      future: _loadCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final isLoggedIn = user != null && user.email.isNotEmpty;

        if (!isLoggedIn) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F6F8),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  Expanded(child: _buildLoginPrompt(context)),
                ],
              ),
            ),
          );
        }

        final userEmail = user!.email;
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
                          orders: OrderProvider.instance.getOngoingOrdersForUser(userEmail),
                          status: OrderStatus.ongoing,
                          userEmail: userEmail,
                          onStartShopping: onStartShopping,
                        ),
                        _OrdersList(
                          orders: OrderProvider.instance.getCompletedOrdersForUser(userEmail),
                          status: OrderStatus.completed,
                          userEmail: userEmail,
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
      },
    );
  }

  Future<dynamic> _loadCurrentUser() async {
    try {
      final container = InjectionContainer();
      if (!container.isInitialized) await container.init();
      return await container.getCurrentUserUseCase.call();
    } catch (_) {
      return null;
    }
  }

  Widget _buildLoginPrompt(BuildContext context) {
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
              child: Icon(Icons.login, size: 64, color: _primaryPurple.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),
            Text(
              'Login or Sign up',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'Please login or sign up first to view your orders',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                  if (context.mounted && result == true) {
                    // Login success - Navigator.pushReplacement in LoginScreen handles navigation
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryPurple,
                  side: BorderSide(color: _primaryPurple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
              ),
            ),
          ],
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
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: _primaryPurple.withOpacity(0.1),
              foregroundColor: _primaryPurple,
            ),
          ),
          const SizedBox(width: 16),
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
    required this.userEmail,
    this.onStartShopping,
  });

  final List<OrderItem> orders;
  final OrderStatus status;
  final String userEmail;
  final VoidCallback? onStartShopping;

  Map<String, List<OrderItem>> _groupByOrderId() {
    final map = <String, List<OrderItem>>{};
    for (final o in orders) {
      final id = o.orderId.isNotEmpty ? o.orderId : '${o.date}|${o.address}';
      map.putIfAbsent(id, () => []).add(o);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByOrderId();
    if (grouped.isEmpty) {
      return _EmptyState(onStartShopping: onStartShopping);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final orderId = grouped.keys.elementAt(index);
        final items = grouped[orderId]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _OrderGroupCard(
            orderId: orderId,
            items: items,
            status: status,
            userEmail: userEmail,
            onStartShopping: onStartShopping,
          ),
        );
      },
    );
  }
}

class _OrderGroupCard extends StatelessWidget {
  const _OrderGroupCard({
    required this.orderId,
    required this.items,
    required this.status,
    required this.userEmail,
    this.onStartShopping,
  });

  final String orderId;
  final List<OrderItem> items;
  final OrderStatus status;
  final String userEmail;
  final VoidCallback? onStartShopping;

  static const Color _primaryPurple = Color(0xFF5E35B1);

  Widget _buildOrderImage(String path) {
    final errorWidget = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      child: Icon(Icons.image_not_supported, color: Colors.grey.shade500, size: 24),
    );
    if (path.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(path, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => errorWidget),
      );
    }
    try {
      final file = File(path);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(file, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => errorWidget),
        );
      }
    } catch (_) {}
    return errorWidget;
  }

  double _totalPrice() {
    double sum = 0;
    for (final item in items) {
      final match = RegExp(r'\$?\s*([\d.]+)').firstMatch(item.price);
      if (match != null) sum += double.tryParse(match.group(1) ?? '0') ?? 0;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final first = items.first;
    final isOngoing = status == OrderStatus.ongoing;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOngoing ? Colors.orange.withOpacity(0.15) : Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isOngoing ? 'Processing' : 'Completed',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isOngoing ? Colors.orange.shade700 : Colors.green.shade700),
                  ),
                ),
                const Spacer(),
                Text(first.date, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...items.take(3).map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderImage(item.imagePath),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'open sans bold'), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(item.price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _primaryPurple)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                if (items.length > 3) Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('+ ${items.length - 3} more item(s)', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, size: 20, color: Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Expanded(child: Text(first.address, style: TextStyle(fontSize: 13, color: Colors.grey.shade700), maxLines: 3, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: \$ ${_totalPrice().toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: _primaryPurple)),
                    if (isOngoing)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ActionButton(icon: Icons.edit_outlined, label: 'Edit', onTap: () => _showEditOrder(context)),
                          const SizedBox(width: 8),
                          _ActionButton(icon: Icons.delete_outline, label: 'Delete', color: Colors.red.shade400, onTap: () => _confirmDelete(context)),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditOrder(BuildContext context) {
    DeliveryAddressProvider.instance.load(userEmail);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditOrderSheet(
        orderId: orderId,
        currentAddress: items.first.address,
        onSaved: () => Navigator.pop(ctx),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel order?'),
        content: const Text('This will remove this order from your ongoing orders. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep')),
          TextButton(
            onPressed: () {
              OrderProvider.instance.removeOrder(orderId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order removed'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, this.color, required this.onTap});

  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  static const Color _primaryPurple = Color(0xFF5E35B1);

  @override
  Widget build(BuildContext context) {
    final c = color ?? _primaryPurple;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: c.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: c),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditOrderSheet extends StatefulWidget {
  const _EditOrderSheet({
    required this.orderId,
    required this.currentAddress,
    required this.onSaved,
  });

  final String orderId;
  final String currentAddress;
  final VoidCallback onSaved;

  @override
  State<_EditOrderSheet> createState() => _EditOrderSheetState();
}

class _EditOrderSheetState extends State<_EditOrderSheet> {
  final _addressController = TextEditingController();
  DeliveryAddress? _selectedAddress;
  bool _showManualInput = false;

  static const Color _primaryPurple = Color(0xFF5E35B1);

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.currentAddress;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    final address = _selectedAddress != null ? _selectedAddress!.orderAddressString : _addressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or select an address'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating),
      );
      return;
    }
    OrderProvider.instance.updateOrderAddress(widget.orderId, address);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address updated'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
    );
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit delivery address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold')),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListenableBuilder(
                    listenable: DeliveryAddressProvider.instance,
                    builder: (context, _) {
                      final addrs = DeliveryAddressProvider.instance.addresses;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (addrs.isNotEmpty) ...[
                            Text('Saved addresses', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                            const SizedBox(height: 12),
                            ...addrs.map((addr) => _buildAddressOption(addr)),
                            const SizedBox(height: 20),
                            Divider(color: Colors.grey.shade200),
                            const SizedBox(height: 16),
                          ],
                          InkWell(
                            onTap: () => setState(() {
                              _showManualInput = !_showManualInput;
                              if (_showManualInput) _selectedAddress = null;
                            }),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: _showManualInput ? _primaryPurple.withOpacity(0.08) : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _showManualInput ? _primaryPurple : Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.edit_note, size: 22, color: _primaryPurple),
                                  const SizedBox(width: 12),
                                  Text(_showManualInput ? 'Hide manual input' : 'Enter address manually', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _primaryPurple)),
                                ],
                              ),
                            ),
                          ),
                          if (_showManualInput) ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller: _addressController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Delivery address',
                                hintText: 'Full name, street, city, state, ZIP, phone',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryPurple, width: 2)),
                              ),
                              onChanged: (_) => setState(() => _selectedAddress = null),
                            ),
                          ],
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Save changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressOption(DeliveryAddress addr) {
    final typeColor = addr.type.color;
    final isSelected = _selectedAddress?.id == addr.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedAddress = addr;
              _addressController.text = addr.orderAddressString;
              _showManualInput = false;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected ? _primaryPurple.withOpacity(0.08) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? _primaryPurple : Colors.grey.shade200, width: isSelected ? 2 : 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: typeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Icon(addr.type.icon, size: 22, color: typeColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(addr.type.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: typeColor)),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.check_circle, size: 16, color: _primaryPurple),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(addr.fullName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
                      Text(addr.shortSummary, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
              child: Icon(Icons.shopping_bag_outlined, size: 64, color: _primaryPurple.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'Start shopping to see your orders here',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onStartShopping,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Start Shopping', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
            ),
          ],
        ),
      ),
    );
  }
}
