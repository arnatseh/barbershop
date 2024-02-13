import 'package:barber_shop/page/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage(
      {super.key, required this.products, required this.totalPrice});

  final List<Product> products;
  final double totalPrice;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  CollectionReference order = FirebaseFirestore.instance.collection('order');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการสั่งซื้อ"),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              children: buildOrderList(),
            ),
            ElevatedButton(
                onPressed: () {
                  addOrder();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductPage(),
                      ));
                },
                child: const Text("ยืนยันการสั่งซื้อสินค้า"))
          ],
        ),
      ),
    );
  }

  void addOrder() async {
    var product = [];
    for (var p in widget.products) {
      product.add({
        "product_name": p.name,
        "product_price": p.price,
      });
    }
    order
        .add({
          'user_id': FirebaseAuth.instance.currentUser!.uid,
          'order_product': product,
          'total_price': widget.totalPrice
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add order: $error"));
  }

  List<Widget> buildOrderList() {
    List<Widget> myWidget = [];

    // myWidget.add(Text("data"));
    // myWidget.add(Text("data2"));

    myWidget = widget.products.map<Widget>((prod) {
      return ListTile(
        title: Text(prod.name),
        trailing: Text(prod.price.toStringAsFixed(2)),
      );
    }).toList();

    myWidget.add(ListTile(
      tileColor: Colors.teal[100],
      title: const Text("รวมราคา"),
      trailing: Text(widget.totalPrice.toStringAsFixed(2)),
    ));

    return myWidget;
  }
}
