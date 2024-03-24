import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Danh sách sản phẩm",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Sử dụng Material 3
        useMaterial3: true,
      ),
      home: ProductListScreen(),
    );
  }
}

class Product {
  String sreach_image;
  int styleid;
  String brands_filter_facet;
  int price;
  String product_additional_info;

  Product({
    required this.sreach_image,
    required this.styleid,
    required this.brands_filter_facet,
    required this.price,
    required this.product_additional_info,
  });
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> products;

  @override
  void initState() {
    super.initState();
    products = [];
    fetchProducts();
  }

  List<Product> convertMapToList(Map<String, dynamic> data) {
    List<Product> productList = [];
    for (int i = 0; i < data['products'].length; i++) {
      dynamic value = data['products'][i];
      Product product = Product(
        sreach_image: value['search_image'] ?? '',
        styleid: value['styleid'] ?? 0,
        brands_filter_facet: value['brands_filter_facet'] ?? '',
        price: value['price'] ?? 0,
        product_additional_info: value['product_additional_info'] ?? '',
      );
      productList.add(product);
    }
    return productList;
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse("https://hungnttg.github.io/shopgiay.json"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        products = convertMapToList(data);
      });
    } else {
      throw Exception("khong co du lieu");
    }
  }

  void navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Danh sách sản phẩm",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Sử dụng Material 3
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("danh sach san pham"),
        ),
        body: products.isNotEmpty
            ? ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(products[index].brands_filter_facet),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: ${products[index].price}'),
                ],
              ),
              leading: Image.network(
                products[index].sreach_image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              onTap: () {
                navigateToProductDetail(products[index]);
              },
            );
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              product.sreach_image,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              product.brands_filter_facet,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Price: ${product.price}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              product.product_additional_info,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
