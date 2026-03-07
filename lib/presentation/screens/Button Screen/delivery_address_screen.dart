import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/data/delivery_address_provider.dart';
import 'package:handicraft_online_store/data/models/delivery_address.dart';
import 'package:handicraft_online_store/presentation/screens/login_screen.dart';
import 'package:handicraft_online_store/presentation/screens/signup_screen.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({super.key});

  Future<dynamic> _loadCurrentUser() async {
    try {
      final container = InjectionContainer();
      if (!container.isInitialized) await container.init();
      return await container.getCurrentUserUseCase.call();
    } catch (_) {
      return null;
    }
  }

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

        return _DeliveryAddressContent(userEmail: user!.email);
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 20, 20),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivery Addresses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87)),
                Text('Add home, work & study addresses', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
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
              decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.login, size: 64, color: _primaryPurple.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),
            Text(
              'Login or Sign up',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'Please login or sign up first to manage your delivery addresses',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
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
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
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
}

class _DeliveryAddressContent extends StatefulWidget {
  const _DeliveryAddressContent({required this.userEmail});

  final String userEmail;

  @override
  State<_DeliveryAddressContent> createState() => _DeliveryAddressContentState();
}

class _DeliveryAddressContentState extends State<_DeliveryAddressContent> {
  @override
  void initState() {
    super.initState();
    DeliveryAddressProvider.instance.load(widget.userEmail);
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
                listenable: DeliveryAddressProvider.instance,
                builder: (context, _) {
                  final addresses = DeliveryAddressProvider.instance.addresses;
                  if (addresses.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildAddressList(addresses);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddEditSheet(context),
        backgroundColor: _primaryPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 20, 20),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivery Addresses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87)),
                Text('Add home, work & study addresses', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
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
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: _primaryPurple.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_off_outlined, size: 64, color: _primaryPurple.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),
            const Text(
              'No addresses yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your home, work or study address for faster checkout',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => _openAddEditSheet(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add your first address'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryPurple,
                side: const BorderSide(color: _primaryPurple),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList(List<DeliveryAddress> addresses) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final addr = addresses[index];
        return _buildAddressCard(addr);
      },
    );
  }

  Widget _buildAddressCard(DeliveryAddress addr) {
    final typeColor = addr.type.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openAddEditSheet(context, address: addr),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(addr.type.icon, size: 18, color: typeColor),
                          const SizedBox(width: 6),
                          Text(
                            addr.type.label,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: typeColor),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _confirmDelete(context, addr),
                      icon: Icon(Icons.delete_outline, size: 22, color: Colors.red.shade400),
                      style: IconButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(36, 36)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  addr.fullName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold', color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  addr.fullAddress,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone_outlined, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(addr.phone, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openAddEditSheet(BuildContext context, {DeliveryAddress? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddEditAddressSheet(
        address: address,
        userEmail: widget.userEmail,
        onSaved: () {
          Navigator.pop(ctx);
          setState(() {});
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, DeliveryAddress addr) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete address?'),
        content: Text('Remove ${addr.type.label} address at ${addr.shortSummary}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              DeliveryAddressProvider.instance.remove(addr.id, widget.userEmail);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('Address removed'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _AddEditAddressSheet extends StatefulWidget {
  final DeliveryAddress? address;
  final String userEmail;
  final VoidCallback onSaved;

  const _AddEditAddressSheet({this.address, required this.userEmail, required this.onSaved});

  @override
  State<_AddEditAddressSheet> createState() => _AddEditAddressSheetState();
}

class _AddEditAddressSheetState extends State<_AddEditAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  AddressType _selectedType = AddressType.home;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      final a = widget.address!;
      _nameController.text = a.fullName;
      _streetController.text = a.street;
      _cityController.text = a.city;
      _stateController.text = a.state;
      _zipController.text = a.zip;
      _phoneController.text = a.phone;
      _selectedType = a.type;
    }
  }

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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final addr = DeliveryAddress(
      id: widget.address?.id ?? '',
      type: _selectedType,
      fullName: _nameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zip: _zipController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    if (widget.address != null) {
      DeliveryAddressProvider.instance.update(addr, widget.userEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address updated'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
      );
    } else {
      DeliveryAddressProvider.instance.add(addr, widget.userEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address added'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
      );
    }
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
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
                    Text(
                      widget.address != null ? 'Edit Address' : 'Add New Address',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'open sans bold'),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                        const SizedBox(height: 12),
                        Row(
                          children: AddressType.values.map((t) {
                            final selected = _selectedType == t;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: t != AddressType.study ? 12 : 0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => setState(() => _selectedType = t),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(
                                        color: selected ? t.color.withOpacity(0.15) : Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: selected ? t.color : Colors.grey.shade200, width: selected ? 2 : 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(t.icon, size: 28, color: selected ? t.color : Colors.grey.shade600),
                                          const SizedBox(height: 6),
                                          Text(t.label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: selected ? t.color : Colors.grey.shade700)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        _buildField(_nameController, 'Full Name', Icons.person_outline, TextInputType.name),
                        _buildField(_streetController, 'Street Address', Icons.home_outlined, TextInputType.streetAddress),
                        Row(
                          children: [
                            Expanded(child: _buildField(_cityController, 'City', Icons.location_city, TextInputType.text)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildField(_stateController, 'State / Province', Icons.map_outlined, TextInputType.text)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: _buildField(_zipController, 'ZIP / Postal Code', Icons.markunread_mailbox_outlined, TextInputType.number)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildField(_phoneController, 'Phone', Icons.phone_outlined, TextInputType.phone)),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(widget.address != null ? 'Save Changes' : 'Add Address', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildField(TextEditingController c, String label, IconData icon, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 22, color: Colors.grey.shade600),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryPurple, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red.shade400)),
        ),
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}
