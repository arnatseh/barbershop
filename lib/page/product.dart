import 'package:barber_shop/page/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  List<Product> productSelect = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection("product")
        .get()
        .then((snapshot) {
      setState(() {
        products = snapshot.docs.map((doc) {
          var data = doc.data();
          print("---------------");
          print(data);
          return Product(
              name: data['product_name'],
              price: data['product_price'],
              checked: false);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เมนูสินค้า"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              // addDataSection(),
              // showOnetimeRead(),
              showRealtimeChange(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("รวมราคา"),
                  Text("$totalPrice"),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderPage(
                              products: productSelect, totalPrice: totalPrice),
                        ));
                  },
                  child: const Text("สั่งซื้อสินค้า"))
            ],
          ),
        ),
      ),
    );
  }

  Widget showRealtimeChange() {
    return Column(
      children: [
        const Text("รายการเมนูสินค้า"),
        Column(
          children: createDataList(products),
        ),
      ],
    );
  }

  List<Widget> createDataList(List<Product> products) {
    List<Widget> widgets = [];
    widgets = products.map((prod) {
      // print(data['product_name']);
      return CheckboxListTile(
        title: Text("${prod.name}, ${prod.price} บาท"),
        value: prod.checked,
        onChanged: (bool? value) {
          setState(() {
            prod.checked = value!;
            // print(prod.checked);
            // print(prod.name);
            if (prod.checked) {
              productSelect.add(prod);
              totalPrice += prod.price;
            } else {
              productSelect.remove(prod);
              totalPrice -= prod.price;
            }
          });

          // for (var element in productSelect) {
          //   totalPrice = 0;
          //   setState(() {
          //     totalPrice += element.price;
          //   });
          // }

          print(productSelect);
        },

        // trailing: IconButton(
        //     onPressed: () {
        //       print("Delete");
        //       showConfirmDialog(doc.id);
        //     },
        //     icon: const Icon(
        //       Icons.delete,
        //       color: Colors.red,
        //     )),
      );
    }).toList();

    return widgets;
  }

  // void showConfirmDialog(String id) {
  //   var dialog = AlertDialog(
  //     title: const Text("ลบข้อมูล"),
  //     content: Text("ต้องการลบข้อมูลเอกสารรหัส $id"),
  //     actions: [
  //       ElevatedButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text("Back")),
  //       ElevatedButton(
  //           style: ButtonStyle(
  //               backgroundColor: MaterialStatePropertyAll(Colors.red[300]),
  //               foregroundColor: const MaterialStatePropertyAll(Colors.white)),
  //           onPressed: () {
  //             FirebaseFirestore.instance.collection("product").doc(id).delete();
  //             Navigator.of(context).pop();
  //           },
  //           child: Text("Delete")),
  //     ],
  //   );
  //   showDialog(
  //     context: context,
  //     builder: (context) => dialog,
  //   );
  // }
}

class Product {
  final String name;
  final int price;
  bool checked;

  Product({required this.name, required this.price, required this.checked});
}
