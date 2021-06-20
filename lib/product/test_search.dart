import 'package:flutter/material.dart';
import 'package:satyamflutter/product/product.dart';

import 'item_card.dart';



class test_search extends StatefulWidget {
  List<Product> list;
  String subcategory;

  test_search(this.subcategory, this.list);

  @override
  StorageUploadState createState() => StorageUploadState(subcategory, list);
}

class StorageUploadState extends State<test_search> {
  List<Product> results = [];

  List<Product> rows = [];
  String query = '';
  TextEditingController tc;
  String subcategory;
  StorageUploadState(this.subcategory, this.rows);


  @override
  void initState() {
    super.initState();
    tc = TextEditingController();
//    rows = [
//      {
//        'contact_name': 'Test User 1',
//        'contact_phone': '066 560 4900',
//      },
//      {
//        'contact_name': 'Test User 2',
//        'contact_phone': '066 560 7865',
//      },
//      {
//        'contact_name': 'Test User 3',
//        'contact_phone': '906 500 4334',
//      }
//    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Delivero Contacts",
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: tc,
                    decoration: InputDecoration(hintText: 'Search...'),
                    onChanged: (v) {
                      setState(() {
                        query = v;
                        setResults(query);
                      });
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: query.isEmpty
                      ?
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: rows.length,
                    itemBuilder: (con, ind) {
                      return ListTile(
                        title: Text(rows[ind].title),
//                        subtitle: Text(rows[ind]['contact_phone']),
                        onTap: () {
                          setState(() {
                            tc.text = rows[ind].title;
//                            query = rows[ind]['contact_name'];
                            setResults(query);
                          });
                        },
                      );
                    },
                  )

//                  GridView.builder(
//                      itemCount: rows.length,
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                        crossAxisCount: 2,
//                        mainAxisSpacing: 20.0,
//                        crossAxisSpacing: 20.0,
//                        childAspectRatio: 0.75,
//                      ),
//                      itemBuilder: (context, index) => ItemCard(
//                        product: rows[index],
//                        press: () {
//                          setState(() {
//                            tc.text = rows[index].title;
////                            query = rows[ind]['contact_name'];
//                            setResults(query);
//                          });
//                        },
////                        Navigator.push(
////                            context,
////                            MaterialPageRoute(
////                              builder: (context) => details_screen(
////                                product: list[index],
////                              ),
////                            )),
//                      ))
                      : ListView.builder(
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (con, ind) {
                      return ListTile(
                        title: Text(results[ind].title),
//                        subtitle: Text(results[ind]['contact_phone']),
                        onTap: () {
                          setState(() {
                            tc.text = results[ind].title;
//                            query = results[ind]['contact_name'];
                            setResults(query);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setResults(String query) {
    results = rows
        .where((elem) =>
    elem.title
        .toString()
        .toLowerCase()
        .contains(query.toLowerCase()) ||
        elem.title
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }
}