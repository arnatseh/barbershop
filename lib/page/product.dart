import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  List product_select = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
   await FirebaseFirestore.instance.collection("product").get().then((snapshot) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เมนูสินค้า"),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget showRealtimeChange() {
    return Column(
      children: [
        const Text("Real Time Change"),
        Column(
          children: createDataList(),
        )
        ,
        const Divider(),
      ],
    );
  }

  // Widget createRealTimeData() {

    // return FutureBuilder(
    //   future: FirebaseFirestore.instance.collection("product").get(),
    //   builder: (context, snapshot) {
    //     print("Realtime Change");
    //     print(snapshot.connectionState);
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const CircularProgressIndicator();
    //     } else {
    //       // print(snapshot.data!.size);
    //       // print(snapshot.data!.docs);
    //       // products = snapshot.data!.docs.map((doc) {
    //       //   var data = doc.data();
    //       //   print("---------------");
    //       //   print(data);
    //       //   return Product(
    //       //       name: data['product_name'],
    //       //       price: data['product_price'],
    //       //       checked: false);
    //       // }).toList();

    //       print(products);

    //       return Column(
    //         children: createDataList(products),
    //       );
    //     }
    //   },
    // );
  // }

  List<Widget> createDataList() {
    List<Widget> widgets = [];
    widgets = products.map((prod) {
      // print(data['product_name']);
      return CheckboxListTile(
        title: Text(prod.name + ", " + prod.price.toString() + " บาท"),
        value: prod.checked,
        onChanged: (bool? value) {
          setState(() {
            prod.checked = value!;
            print(prod.checked);
            print(prod.name);
            if (prod.checked) {
              product_select.add(prod.name);
            } else {
              product_select.remove(prod.name);
            }
          });
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
