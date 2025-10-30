import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storekeeper_app/models/product.dart';
import 'package:storekeeper_app/providers/image_provider.dart';
import 'package:storekeeper_app/providers/product_provider.dart';
import 'package:storekeeper_app/widgets/custom_button.dart';
import 'package:storekeeper_app/widgets/custom_textfield.dart';

import '../widgets/snack_bar.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      isEditing = true;
      final imageProvider = Provider.of<MyImageProvider>(
        context,
        listen: false,
      );

      imageProvider.nameController.text = widget.product!.name;
      imageProvider.quantityController.text = widget.product!.quantity
          .toString();
      imageProvider.priceController.text = widget.product!.price
          .toStringAsFixed(2);
      imageProvider.setImagePath(widget.product!.imagePath);
    } else {
      isEditing = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<MyImageProvider>(context, listen: false).clearAll();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'Add Product')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<MyImageProvider>(
                  builder: (context, imageProvider, child) {
                    String? currentImagePath = imageProvider.imagePath;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              imageProvider.showImageSourceBottomSheet(context),
                          child: Container(
                            width: double.infinity,
                            height: 250.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: currentImagePath == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 60.w,
                                        color: Colors.grey[500],
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'Tap to add an image',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Hero(
                                      tag: isEditing
                                          ? 'product_image_${widget.product!.id}'
                                          : 'new_product_image',

                                      child: Image.file(
                                        File(currentImagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        if (currentImagePath != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () => imageProvider.deleteImage(),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 24.h),

                CustomTextfield(
                  hintText: 'Product Name',
                  controller: context.read<MyImageProvider>().nameController,
                  prefixIcon: Icons.shopping_bag_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        hintText: 'Quantity',
                        controller: context
                            .read<MyImageProvider>()
                            .quantityController,
                        prefixIcon: Icons.inventory_2_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextfield(
                        hintText: 'Price',
                        controller: context
                            .read<MyImageProvider>()
                            .priceController,
                        prefixIcon: FontAwesomeIcons.nairaSign,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.tryParse(value) == null) {
                            return 'Enter a valid price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<MyImageProvider>(
                    builder: (context, imageProvider, child) {
                      return CustomButton(
                        label: isEditing ? 'Update Product' : 'Add Product',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final navigator = Navigator.of(context);
                            if (isEditing) {
                              Product updatedProduct = Product(
                                id: widget.product!.id,
                                name: imageProvider.nameController.text,
                                quantity: int.parse(
                                  imageProvider.quantityController.text,
                                ),
                                price: double.parse(
                                  imageProvider.priceController.text,
                                ),
                                imagePath: imageProvider.imagePath,
                              );
                              await productProvider.editProduct(updatedProduct);
                            } else {
                              Product newProduct = Product(
                                name: imageProvider.nameController.text,
                                quantity: int.parse(
                                  imageProvider.quantityController.text,
                                ),
                                price: double.parse(
                                  imageProvider.priceController.text,
                                ),
                                imagePath: imageProvider.imagePath,
                              );
                              await productProvider.addProduct(newProduct);
                            }
                            if (mounted) {
                              showStyledSnackBar(
                                context,
                                isEditing
                                    ? 'Product updated successfully!'
                                    : 'Product added successfully!',
                              );
                              navigator.pop();
                            }
                          }
                        },
                        bgColor: Colors.blue,
                        fgColor: Colors.white,
                      );
                    },
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
