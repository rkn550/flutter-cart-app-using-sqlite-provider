import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/db_helper.dart';
import "package:shopping_cart/cart_model.dart";

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DBHelper _dbHelper = DBHelper();

  List<String> productName = [
    'Orange',
    'Banana',
    'Guava',
    'Cherry',
    'Grapes',
    'Apple'
  ];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'KG', 'KG', 'KG'];
  List<int> productPrice = [10, 20, 10, 15, 20, 30];
  List<String> productImage = [
    'https://as2.ftcdn.net/jpg/00/61/19/53/1000_F_61195341_rR4lMptEspj16GvOdmy0MaMznSRveh2M.webp',
    'https://as2.ftcdn.net/jpg/02/99/29/05/1000_F_299290543_D7Hg1njhj3SZc2JiYp2hsT3HWk9WIFrL.webp',
    'https://as1.ftcdn.net/jpg/05/01/74/18/1000_F_501741838_acewybkCXwzyG0SGAAY0p1sQh30hUqWA.jpg',
    'https://as2.ftcdn.net/jpg/00/74/22/49/1000_F_74224960_NdKkkU8tjpw9TNKDfDJtTnIMuCNUIGRV.jpg',
    'https://as2.ftcdn.net/jpg/01/33/02/55/1000_F_133025567_GYRS1rRzIhn9eSVDB2qiSMYP8NUmrSKy.jpg',
    'https://as2.ftcdn.net/jpg/00/59/96/75/1000_F_59967553_9g2bvhTZf18zCmEVWcKigEoevGzFqXzq.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (ctx, value, child) {
                  return Text(value.getCounter().toString(),
                      style: const TextStyle(color: Colors.white));
                },
              ),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: productName.length,
            itemBuilder: (context, index) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image(
                          height: 100,
                          width: 100,
                          image: NetworkImage(productImage[index].toString()),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName[index].toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                productUnit[index].toString() +
                                    " " +
                                    r"$" +
                                    productPrice[index].toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    print(index);
                                    print(index);
                                    print(productName[index].toString());
                                    print(productPrice[index].toString());
                                    print(productPrice[index]);
                                    print('1');
                                    print(productUnit[index].toString());
                                    print(productImage[index].toString());
                                    _dbHelper
                                        .insert(CartModel(
                                            id: index,
                                            productId: index.toString(),
                                            productName:
                                                productName[index].toString(),
                                            initialPrice: productPrice[index],
                                            productPrice: productPrice[index],
                                            quantity: 1,
                                            unitTag:
                                                productUnit[index].toString(),
                                            image:
                                                productImage[index].toString()))
                                        .then((value) {
                                      print('product is added to the cart');
                                      cart.addTotalPrice(double.parse(
                                          productPrice[index].toString()));
                                      cart.addCounter();
                                      const snackBar = SnackBar(
                                        backgroundColor: Colors.green,
                                        content:
                                            Text('Product is added to cart'),
                                        duration: Duration(seconds: 1),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }).onError((error, stackTrace) {
                                      print(error.toString());
                                      const snackBar = SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              'Product is already added in cart'),
                                          duration: Duration(seconds: 1));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Text(
                                      'Add to cart',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
