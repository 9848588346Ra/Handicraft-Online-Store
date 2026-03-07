import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/utils/image_storage.dart';
import 'package:handicraft_online_store/data/models/product_model.dart';
import 'package:handicraft_online_store/data/product_provider.dart';
import 'package:image_picker/image_picker.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

class AdminProductScreen extends StatelessWidget {
  const AdminProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: _primaryPurple.withOpacity(0.1),
              foregroundColor: _primaryPurple,
            ),
          ),
          title: const Text('Manage Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold')),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: _primaryPurple,
            labelColor: _primaryPurple,
            unselectedLabelColor: Colors.grey.shade600,
            tabs: const [
              Tab(text: 'Add'),
              Tab(text: 'Edit'),
              Tab(text: 'Remove'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AddProductTab(),
            _EditProductTab(),
            _RemoveProductTab(),
          ],
        ),
      ),
    );
  }
}

class _AddProductTab extends StatefulWidget {
  @override
  State<_AddProductTab> createState() => _AddProductTabState();
}

class _AddProductTabState extends State<_AddProductTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  String? _pickedImagePath;
  String _selectedCategory = 'General';
  static const List<String> _categories = ['General', 'Felt Toys', 'Decorations', 'Accessories', 'Home Decor'];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);
    if (picked != null && mounted) {
      setState(() => _pickedImagePath = picked.path);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImagePath == null || _pickedImagePath!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a product photo'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating),
      );
      return;
    }
    final title = _titleController.text.trim();
    final price = _priceController.text.trim();
    final category = _selectedCategory;
    final priceStr = price.startsWith('\$') ? price : '\$$price';

    // Copy to permanent storage so image persists after app restart / admin logout
    final persistentPath = await copyToPersistentStorage(_pickedImagePath!);
    final imagePath = persistentPath ?? _pickedImagePath!;

    ProductProvider.instance.addProduct(ProductModel(
      id: '',
      title: title,
      price: priceStr,
      imagePath: imagePath,
      category: category,
    ));
    _titleController.clear();
    _priceController.clear();
    setState(() => _pickedImagePath = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration('Product title'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: _inputDecoration('Price (e.g. 10 or \$10)'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _buildImagePickerSection(),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _inputDecoration('Category'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v ?? 'General'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add Product', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _pickedImagePath != null ? Colors.green : Colors.grey.shade300, width: _pickedImagePath != null ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Product photo', style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          if (_pickedImagePath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(_pickedImagePath!),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => setState(() => _pickedImagePath = null),
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Remove photo'),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, size: 20),
                    label: const Text('Camera'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryPurple,
                      side: BorderSide(color: _primaryPurple.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library, size: 20),
                    label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryPurple,
                      side: BorderSide(color: _primaryPurple.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      );
}

class _EditProductTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ProductProvider.instance,
      builder: (context, _) {
        final products = ProductProvider.instance.products;
        if (products.isEmpty) {
          return Center(
            child: Text('No products to edit. Add products first.', style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return _ProductCard(
              product: p,
              onTap: () => _openEditSheet(context, p),
            );
          },
        );
      },
    );
  }

  void _openEditSheet(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditProductSheet(product: product),
    );
  }
}

class _EditProductSheet extends StatefulWidget {
  final ProductModel product;

  const _EditProductSheet({required this.product});

  @override
  State<_EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<_EditProductSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;
  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController = TextEditingController(text: widget.product.price);
    _categoryController = TextEditingController(text: widget.product.category);
    _pickedImagePath = widget.product.imagePath.isNotEmpty && !widget.product.imagePath.startsWith('assets/')
        ? widget.product.imagePath
        : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);
    if (picked != null && mounted) {
      setState(() => _pickedImagePath = picked.path);
    }
  }

  String get _effectiveImagePath {
    if (_pickedImagePath != null && _pickedImagePath!.isNotEmpty) return _pickedImagePath!;
    return widget.product.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final isAssetPath = widget.product.imagePath.startsWith('assets/');
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Edit: ${widget.product.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'open sans bold')),
              const SizedBox(height: 16),
              TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              _buildEditImageSection(isAssetPath),
              const SizedBox(height: 12),
              TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        var imagePath = _effectiveImagePath;
                        if (imagePath.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please add a product photo'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating),
                          );
                          return;
                        }
                        // Copy new picks to permanent storage (picked paths are temporary)
                        if (_pickedImagePath != null && !imagePath.startsWith('assets/')) {
                          final persistentPath = await copyToPersistentStorage(_pickedImagePath!);
                          if (persistentPath != null) imagePath = persistentPath;
                        }
                        ProductProvider.instance.updateProduct(widget.product.copyWith(
                          title: _titleController.text.trim(),
                          price: _priceController.text.trim(),
                          imagePath: imagePath,
                          category: _categoryController.text.trim().isEmpty ? 'General' : _categoryController.text.trim(),
                        ));
                        if (context.mounted) Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product updated'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: _primaryPurple, foregroundColor: Colors.white),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditImageSection(bool isAssetPath) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _effectiveImagePath.isNotEmpty ? Colors.green : Colors.grey.shade300, width: _effectiveImagePath.isNotEmpty ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Product photo', style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          if (_pickedImagePath != null && File(_pickedImagePath!).existsSync())
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(File(_pickedImagePath!), height: 100, width: double.infinity, fit: BoxFit.cover),
            )
          else if (isAssetPath)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(widget.product.imagePath, height: 100, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder()),
            )
          else
            _placeholder(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt, size: 18),
                  label: const Text('Camera'),
                  style: OutlinedButton.styleFrom(foregroundColor: _primaryPurple, side: BorderSide(color: _primaryPurple.withOpacity(0.5)), padding: const EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library, size: 18),
                  label: const Text('Gallery'),
                  style: OutlinedButton.styleFrom(foregroundColor: _primaryPurple, side: BorderSide(color: _primaryPurple.withOpacity(0.5)), padding: const EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        height: 100,
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade500),
      );
}

class _RemoveProductTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ProductProvider.instance,
      builder: (context, _) {
        final products = ProductProvider.instance.products;
        if (products.isEmpty) {
          return Center(
            child: Text('No products to remove. Add products first.', style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return _ProductCard(
              product: p,
              showDelete: true,
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Remove product?'),
                    content: Text('Remove "${p.title}"?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          ProductProvider.instance.removeProduct(p.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Product removed'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating),
                          );
                        },
                        child: Text('Remove', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

Widget _buildProductImage(String path, double width, double height) {
  final errorWidget = Container(
    width: width,
    height: height,
    color: Colors.grey.shade200,
    child: Icon(Icons.image_not_supported, color: Colors.grey.shade500),
  );
  if (path.startsWith('assets/')) {
    return Image.asset(path, width: width, height: height, fit: BoxFit.cover, errorBuilder: (_, __, ___) => errorWidget);
  }
  try {
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, width: width, height: height, fit: BoxFit.cover, errorBuilder: (_, __, ___) => errorWidget);
    }
  } catch (_) {}
  return errorWidget;
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    this.onTap,
    this.showDelete = false,
    this.onDelete,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final bool showDelete;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildProductImage(product.imagePath, 56, 56),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold')),
                      const SizedBox(height: 4),
                      Text(product.price, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                if (showDelete && onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  ),
                if (!showDelete && onTap != null)
                  Icon(Icons.edit_outlined, size: 22, color: _primaryPurple),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
