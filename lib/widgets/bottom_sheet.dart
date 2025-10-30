import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:storekeeper_app/models/product.dart';
import 'package:storekeeper_app/providers/product_provider.dart';

void showInventorySummary(BuildContext context) {
  final productProvider = context.read<ProductProvider>();
  final products = productProvider.products;

  final int totalProducts = products.length;
  final int totalUnits = products.fold(0, (sum, item) => sum + item.quantity);
  final double totalValue = products.fold(
    0.0,
    (sum, item) => sum + (item.price * item.quantity),
  );
  final List<Product> lowStockItems = products
      .where((p) => p.quantity < 5)
      .toList();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              children: [
                Center(
                  child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Inventory Summary',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildSummaryTile(
                  context,
                  icon: Icons.inventory_2_outlined,
                  color: Colors.blue,
                  title: 'Total Products',
                  value: totalProducts.toString(),
                ),
                _buildSummaryTile(
                  context,
                  icon: Icons.all_inbox_outlined,
                  color: Colors.orange,
                  title: 'Total Units in Stock',
                  value: totalUnits.toString(),
                ),
                _buildSummaryTile(
                  context,
                  icon: Icons.attach_money_outlined,
                  color: Colors.green,
                  title: 'Total Inventory Value',
                  value: '₦${totalValue.toStringAsFixed(2)}',
                ),
                Divider(height: 32.h),
                Text(
                  'Low Stock Items (Less than 5)',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),

                _buildLowStockList(lowStockItems),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildSummaryTile(
  BuildContext context, {
  required IconData icon,
  required Color color,
  required String title,
  required String value,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      foregroundColor: color,
      child: Icon(icon),
    ),
    title: Text(
      title,
      style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
    ),
    trailing: Text(
      value,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

Widget _buildLowStockList(List<Product> lowStockItems) {
  if (lowStockItems.isEmpty) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Text(
          'All items are well-stocked!',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
        ),
      ),
    );
  }

  return Column(
    children: lowStockItems.map((item) {
      return Card(
        elevation: 1,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        child: ListTile(
          title: Text(item.name, style: TextStyle(fontWeight: FontWeight.w600)),
          trailing: Text(
            'Only ${item.quantity} left',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }).toList(),
  );
}
