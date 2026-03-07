import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/data/cart_provider.dart';
import 'package:handicraft_online_store/data/delivery_address_provider.dart';
import 'package:handicraft_online_store/data/models/cart_item.dart';
import 'package:handicraft_online_store/data/models/delivery_address.dart';
import 'package:handicraft_online_store/data/order_provider.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

class CartScreen extends StatefulWidget {
  final VoidCallback? onContinueShopping;

  const CartScreen({super.key, this.onContinueShopping});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _openCheckoutModal() async {
    final items = CartProvider.instance.items;
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    String userEmail = '';
    try {
      final container = InjectionContainer();
      if (!container.isInitialized) await container.init();
      final user = await container.getCurrentUserUseCase.call();
      userEmail = user?.email ?? '';
    } catch (_) {}
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CheckoutModal(
        userEmail: userEmail,
        total: CartProvider.instance.total,
        itemCount: CartProvider.instance.itemCount,
        onPlaceOrder: _placeOrder,
        onContinueShopping: widget.onContinueShopping,
      ),
    );
  }

  Future<void> _placeOrder(String address) async {
    final items = CartProvider.instance.items;
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    String userEmail = '';
    try {
      final container = InjectionContainer();
      if (!container.isInitialized) await container.init();
      final user = await container.getCurrentUserUseCase.call();
      userEmail = user?.email ?? '';
    } catch (_) {}
    OrderProvider.instance.addOngoingOrder(items, address, userEmail: userEmail);
    CartProvider.instance.clear();

    if (mounted) {
      Navigator.pop(context); // close checkout modal
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _OrderAcceptedDialog(
          onDone: () {
            Navigator.pop(context);
            widget.onContinueShopping?.call();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListenableBuilder(
        listenable: CartProvider.instance,
        builder: (context, _) {
          final items = CartProvider.instance.items;
          final total = CartProvider.instance.total;
          final itemCount = CartProvider.instance.itemCount;

          if (items.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  '$itemCount items in your cart',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCartItems(items),
                      _buildOrderSummary(total, itemCount),
                    ],
                  ),
                ),
              ),
              _buildProceedToCheckoutBar(total),
            ],
          );
        },
      ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListenableBuilder(
        listenable: CartProvider.instance,
        builder: (_, __) {
          final count = CartProvider.instance.itemCount;
          final total = CartProvider.instance.total;
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, color: _primaryPurple, size: 26),
                    if (count > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: _primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Cart',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87),
                    ),
                    Text(
                      count > 0 ? '\$ ${total.toStringAsFixed(2)} total' : 'Add items to get started',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

Widget _buildEmptyState() {
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
              child: Icon(Icons.shopping_cart_outlined, size: 64, color: _primaryPurple.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'open sans bold',
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items from the shop to get started',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.onContinueShopping,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold'),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCartItems(List<CartItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildCartItemRow(items[i], i),
            if (i < items.length - 1)
              Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.shade200),
          ],
        ],
      ),
    );
  }

Widget _buildCartItemRow(CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildImage(item.imagePath),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'open sans bold',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$ ${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryPurple),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _qtyButton(() => CartProvider.instance.updateQuantity(index, -1), Icons.remove),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${item.quantity}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    _qtyButton(() => CartProvider.instance.updateQuantity(index, 1), Icons.add),
                    const Spacer(),
                    IconButton(
                      onPressed: () => CartProvider.instance.removeItem(index),
                      icon: Icon(Icons.delete_outline, size: 22, color: Colors.red.shade400),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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

Widget _buildImage(String path) {
    final errorWidget = Container(
      width: 72,
      height: 72,
      color: Colors.grey.shade200,
      child: Icon(Icons.image_not_supported, color: Colors.grey.shade500),
    );
    if (path.startsWith('assets/')) {
      return Image.asset(path, width: 72, height: 72, fit: BoxFit.cover, errorBuilder: (_, __, ___) => errorWidget);
    }
    try {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(file, width: 72, height: 72, fit: BoxFit.cover, errorBuilder: (_, __, ___) => errorWidget);
      }
    } catch (_) {}
    return errorWidget;
  }

Widget _qtyButton(VoidCallback onTap, IconData icon) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: _primaryPurple),
      ),
    );
  }

Widget _buildOrderSummary(double total, int itemCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal ($itemCount items)', style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
              Text('\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryPurple)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery', style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
              Text('Free', style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'open sans bold')),
              Text('\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryPurple)),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildProceedToCheckoutBar(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              Text('\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryPurple)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _openCheckoutModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutModal extends StatefulWidget {
  final String userEmail;
  final double total;
  final int itemCount;
  final void Function(String address) onPlaceOrder;
  final VoidCallback? onContinueShopping;

  const _CheckoutModal({
    required this.userEmail,
    required this.total,
    required this.itemCount,
    required this.onPlaceOrder,
    this.onContinueShopping,
  });

  @override
State<_CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<_CheckoutModal> {
  String _paymentMethod = 'COD';
  bool _paymentExpanded = false;
  bool _addressExpanded = false;
  bool _addressFilled = false;
  String _savedAddressSummary = '';
  DeliveryAddress? _selectedAddress;
  bool _showManualForm = false;

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DeliveryAddressProvider.instance.load(widget.userEmail);
  }
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _selectSavedAddress(DeliveryAddress addr) {
    setState(() {
      _selectedAddress = addr;
      _addressFilled = true;
      _savedAddressSummary = '${addr.type.label}: ${addr.shortSummary}';
      _addressExpanded = false;
      _showManualForm = false;
    });
  }

  void _saveAddress() {
    final name = _nameController.text.trim();
    final street = _streetController.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final zip = _zipController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || street.isEmpty || city.isEmpty || state.isEmpty || zip.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating),
      );
      return;
    }
    setState(() {
      _selectedAddress = null;
      _addressFilled = true;
      _savedAddressSummary = '$street, $city';
      _addressExpanded = false;
      _showManualForm = false;
    });
  }

  String get _addressStringForOrder {
    if (_selectedAddress != null) return _selectedAddress!.orderAddressString;
    return '${_nameController.text.trim()}, ${_streetController.text.trim()}, ${_cityController.text.trim()}, ${_stateController.text.trim()} ${_zipController.text.trim()}, ${_phoneController.text.trim()}';
  }

  void _doPlaceOrder() {
    if (!_addressFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add a delivery address'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => _addressExpanded = true);
      return;
    }
    widget.onPlaceOrder(_addressStringForOrder);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
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
                    const Text('Checkout', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'open sans bold')),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection('Payment', _paymentExpanded ? 'COD' : _paymentMethod, () => setState(() => _paymentExpanded = !_paymentExpanded)),
                      if (_paymentExpanded) _buildPaymentOptions(),
                      _buildSection('Address', _addressFilled ? _savedAddressSummary : 'Select delivery address', () => setState(() => _addressExpanded = !_addressExpanded)),
                      if (_addressExpanded) _buildAddressSection(),
                      _buildSection('Total Cost', '\$ ${widget.total.toStringAsFixed(2)}', null),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          children: [
                            const TextSpan(text: 'By placing an order you agree to our '),
                            TextSpan(text: 'Terms And Conditions', style: TextStyle(color: _primaryPurple, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _doPlaceOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Place Order', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

Widget _buildSection(String label, String value, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            if (onTap != null) Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }

Widget _buildPaymentOptions() {
    final options = [
      ('COD', 'Cash on Delivery (COD)', Icons.money),
      ('Card', 'Credit / Debit Card', Icons.credit_card),
      ('PayPal', 'PayPal', Icons.payment),
      ('E-Wallet', 'E-Wallet', Icons.account_balance_wallet),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: options.map((o) {
          final selected = _paymentMethod == o.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _paymentMethod = o.$1),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected ? _primaryPurple.withOpacity(0.1) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? _primaryPurple : Colors.grey.shade200),
                ),
                child: Row(
                  children: [
Icon(o.$3, color: selected ? _primaryPurple : Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(child: Text(o.$2, style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.normal))),
                    if (selected) Icon(Icons.check_circle, color: _primaryPurple, size: 22),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

Widget _buildAddressSection() {
    return ListenableBuilder(
      listenable: DeliveryAddressProvider.instance,
      builder: (context, _) {
        final addrs = DeliveryAddressProvider.instance.addresses;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (addrs.isNotEmpty) ...[
                Text('Saved addresses', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                ...addrs.map((addr) => _buildSavedAddressOption(addr)),
                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 16),
              ],
              InkWell(
                onTap: () => setState(() => _showManualForm = !_showManualForm),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _showManualForm ? _primaryPurple.withOpacity(0.08) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _showManualForm ? _primaryPurple : Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
Icon(Icons.add_location_alt_outlined, size: 22, color: _primaryPurple),
                      const SizedBox(width: 12),
                      Text(_showManualForm ? 'Hide new address form' : 'Add new address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _primaryPurple)),
                    ],
                  ),
                ),
              ),
              if (_showManualForm) ...[
                const SizedBox(height: 20),
                _buildAddressForm(),
              ],
            ],
          ),
        );
      },
    );
  }

Widget _buildSavedAddressOption(DeliveryAddress addr) {
    final typeColor = addr.type.color;
    final isSelected = _selectedAddress?.id == addr.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectSavedAddress(addr),
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

Widget _buildAddressForm() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          _buildField(_nameController, 'Full Name', Icons.person),
          _buildField(_streetController, 'Street Address', Icons.home),
          Row(
            children: [
              Expanded(child: _buildField(_cityController, 'City', Icons.location_city)),
              const SizedBox(width: 12),
              Expanded(child: _buildField(_stateController, 'State/Province', Icons.map)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _buildField(_zipController, 'ZIP/Postal Code', Icons.markunread_mailbox)),
              const SizedBox(width: 12),
              Expanded(child: _buildField(_phoneController, 'Phone', Icons.phone)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Use this address'),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildField(TextEditingController c, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryPurple, width: 2)),
        ),
      ),
    );
  }
}

class _OrderAcceptedDialog extends StatelessWidget {
  final VoidCallback onDone;

  const _OrderAcceptedDialog({required this.onDone});

  @override
Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onDone,
                icon: Icon(Icons.close, color: Colors.grey.shade700, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(height: 8),
            _buildSuccessGraphic(),
            const SizedBox(height: 28),
            const Text(
              'Your Order has been accepted',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              "Your items have been placed and are on their way to being processed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildSuccessGraphic() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: _primaryPurple,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: _primaryPurple.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)],
      ),
      child: const Icon(Icons.check, size: 56, color: Colors.white),
    );
  }
}
