import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  double shippingFee = 80;

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + (item["price"] * item["quantity"]));
  }

  double get total {
    return subtotal + shippingFee;
  }

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      var cartResponse = await Dio().get("https://fakestoreapi.com/carts/1");
      var cartData = cartResponse.data;

      List products = cartData["products"];

      List<Map<String, dynamic>> loadedItems = [];

      for (var item in products) {
        var productResponse = await Dio().get("https://fakestoreapi.com/products/${item["productId"]}");
        var productData = productResponse.data;

        loadedItems.add({
          "title": productData["title"],
          "price": productData["price"].toDouble(),
          "image": productData["image"],
          "quantity": item["quantity"],
        });
      }

      setState(() {
        cartItems = loadedItems;
        isLoading = false;
      });
    } catch (e) {
      print(" Error fetching cart: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Image.network(item["image"], width: 60, height: 60, fit: BoxFit.cover),
                    title: Text(item["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("\$ ${item["price"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              if (item["quantity"] > 0) {
                                item["quantity"]--;
                              }
                            });
                          },
                        ),

                        Text("${item["quantity"]}", style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              item["quantity"]++;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              cartItems.removeAt(index);
                            });
                          },
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _summaryRow("Sub-total", subtotal),
                _summaryRow("VAT (%)", 0),
                _summaryRow("Shipping fee", shippingFee),
                const Divider(),
                _summaryRow("Total", total, isBold: true),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Go To Checkout", style: TextStyle(fontSize: 18, color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _summaryRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 16)),
          Text(
            "\$ ${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
