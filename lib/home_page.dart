import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'profile.dart';
import 'cartscreen.dart';
import 'detailsscreen.dart';

class HomePage extends StatefulWidget {
  final String? token;

  const HomePage({super.key, this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List products = [];
  List filteredProducts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var response = await Dio().get("https://fakestoreapi.com/products");
      setState(() {
        products = response.data;
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      print(" Error fetching products: $e");
      setState(() => isLoading = false);
    }
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() => filteredProducts = products);
    } else {
      setState(() {
        filteredProducts = products
            .where((item) =>
            item["title"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void filterByCategory(String category) {
    if (category == "All") {
      setState(() => filteredProducts = products);
    } else {
      setState(() {
        filteredProducts = products
            .where((item) => item["category"]
            .toString()
            .toLowerCase()
            .contains(category.toLowerCase()))
            .toList();
      });
    }
  }

  List<Widget> _pages() => [
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search for products...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: filterSearch,
          ),
        ),

        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              var item = filteredProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsPage(product: item),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            item["image"],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text("\$${item["price"]}",
                                style: const TextStyle(
                                    color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),

    CartPage(),
    AccountPage(),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        title: const Text("Discover",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: _selectedIndex == 0
            ? TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,

          controller: _tabController,
          onTap: (index) {
            switch (index) {
              case 0:
                filterByCategory("All");
                break;
              case 1:
                filterByCategory("men's clothing");
                break;
              case 2:
                filterByCategory("jewelery");
                break;
              case 3:
                filterByCategory("electronics");
                break;
            }
          },
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Men"),
            Tab(text: "Jewelry"),
            Tab(text: "Electronics"),
          ],
        )
            : null,
      ),

      body: _pages()[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
          backgroundColor:Colors.white,
          selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
