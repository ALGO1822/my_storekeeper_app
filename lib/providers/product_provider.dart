import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../db/database_helper.dart';
import '../util/random_color_util.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> loadProducts() async {
    final dbProducts = await _dbHelper.viewAllProducts();

    _products = dbProducts.map((product) {
      product.color = getRandomColor();
      return product;
    }).toList();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final newId = await _dbHelper.add(product);

    product.id = newId;
    product.color = getRandomColor();

    _products.add(product);

    notifyListeners();
  }

  Future<void> editProduct(Product product) async {
    await _dbHelper.edit(product);

    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      product.color = _products[index].color;

      _products[index] = product;
    }

    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    await _dbHelper.delete(id);

    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  Future<void> closeDatabase() async {
    await _dbHelper.close();
  }

  @override
  void dispose() {
    closeDatabase();
    super.dispose();
  }
}
