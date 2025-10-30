import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:storekeeper_app/db/database_helper.dart';
import 'package:storekeeper_app/models/product.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setUp(() async {
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = '$dbPath/products.db';
    await databaseFactory.deleteDatabase(path);
  });

  test('Insert, fetch and edit product', () async {
    final db = DatabaseHelper();
    final product = Product(name: 'fish', quantity: 3, price: 100.3);
    await db.add(product);

    final products = await db.viewAllProducts();
    expect(products.isNotEmpty, true);

    final firstProduct = products.first;
    final editedProduct = Product(
      id: firstProduct.id,
      name: 'salmon',
      quantity: 5,
      price: 150.0,
    );
    await db.edit(editedProduct);

    final updatedProducts = await db.viewAllProducts();
    expect(updatedProducts.first, isA<Product>());
    print('Edited Product: ${updatedProducts.first}');
  });
}