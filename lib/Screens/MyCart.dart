import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key, required this.items});

  final items;

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    var items = widget.items;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 234, 231),
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: GoogleFonts.poppins(fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
      ),
      body: items[0]['cart'] > 0
          ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return item['cart'] != null && item['cart'] > 0
                    ? ListTile(
                        title: Text("${item['name']}"),
                        subtitle: Text("\$ ${item['price']}"),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 235, 234, 231),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.amber.shade700),
                            ),
                          ),
                          child: Text(
                            "${item['cart']}",
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                      )
                    : Container();
              },
            )
          : SizedBox(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 120,
                    color: Colors.amber.shade700,
                  ),
                  Text(
                    "Your Cart is Empty",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 35),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Shop Something"))
                ],
              ),
            ),
    );
  }
}
