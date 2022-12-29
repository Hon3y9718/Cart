import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'MyCart.dart';
import 'package:get_storage/get_storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    readDataFile();
    super.initState();
  }

  GetStorage db = GetStorage();
  var menuItems;
  List allItems = [];

  sorting() {
    allItems.sort((a, b) {
      if (a['cart'] == null) {
        a['cart'] = 0;
      } else if (b['cart'] == null) {
        b['cart'] = 0;
      }
      return b['cart'].compareTo(a['cart']);
    });
  }

  Future readDataFile() async {
    final String response =
        await rootBundle.loadString('assets/Data/menu.json');
    menuItems = await jsonDecode(response);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 234, 231),
      appBar: AppBar(
        title: Text(
          "Menu",
          style: GoogleFonts.poppins(fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent.shade700,
        child: const Icon(Icons.local_grocery_store),
        onPressed: () {
          Get.to(() => MyCart(
                items: allItems,
              ));
        },
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          "⭐️ means Bestseller",
          textAlign: TextAlign.center,
        ),
      ),
      body: menuItems != null
          ? ListView(children: [
              allItems.length > 1 && allItems[2]['cart'] > 0
                  ? ExpansionTile(
                      title: const Text("Popular Items"),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return allItems[index]['cart'] > 0
                                ? ListTile(
                                    title: index == 0
                                        ? Text("${allItems[index]['name']} ⭐️")
                                        : Text("${allItems[index]['name']}"),
                                    subtitle:
                                        Text("\$ ${allItems[index]['price']}"),
                                    trailing: allItems[index]["cart"] != null &&
                                            allItems[index]['cart'] > 0
                                        ? SizedBox(
                                            width: Get.width * 0.4,
                                            child: countRow(allItems[index]))
                                        : ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                allItems[index]["cart"] = 1;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.amber.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color:
                                                        Colors.amber.shade700),
                                              ),
                                            ),
                                            child: const Text("Add"),
                                          ),
                                  )
                                : Container();
                          },
                        )
                      ],
                    )
                  : Container(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: menuItems!.keys.length,
                itemBuilder: (context, index) {
                  var category = menuItems!.keys.toList()[index];
                  return ExpansionTile(
                    title: Text("$category"),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menuItems[category].length,
                        itemBuilder: (context, i) {
                          var item =
                              menuItems[menuItems!.keys.toList()[index]][i];
                          if (allItems.contains(item) == false) {
                            allItems.add(item);
                          }
                          return item['instock']
                              ? ListTile(
                                  title: Text("${item['name']}"),
                                  subtitle: Text("\$ ${item['price']}"),
                                  trailing: item["cart"] != null &&
                                          item['cart'] > 0
                                      ? SizedBox(
                                          width: Get.width * 0.4,
                                          child: countRow(item))
                                      : ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              item["cart"] = 1;
                                            });
                                            sorting();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.amber.shade700,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.amber.shade700),
                                            ),
                                          ),
                                          child: const Text("Add"),
                                        ),
                                )
                              : Container();
                        },
                      ),
                    ],
                  );
                },
              ),
            ])
          : Container(),
    );
  }

  Widget countRow(item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              item['cart']--;
              sorting();
            });
          },
          child: Container(
            height: 35,
            width: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Text("-",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 25)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${item['cart']}",
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              item['cart']++;
              sorting();
            });
          },
          child: Container(
            height: 35,
            width: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Text("+",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 24.5)),
          ),
        ),
      ],
    );
  }
}
