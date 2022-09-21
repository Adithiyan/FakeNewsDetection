import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sb_hack8_iei/Utilities/constants.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url;
  var output;
  var data;
  bool show = false;
  fetchdata(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Fake News Detection",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 40.0),
                TextField(
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    url = 'http://127.0.0.1:5000/predict?query=' +
                        value.toString();
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter News Text'),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              show = true;
                            });
                            data = await fetchdata(url);
                            setState(() {
                              if (data == "[0]") {
                                setState(() {
                                  output = "FAKE";
                                });
                              } else if (data == "[1]") {
                                setState(() {
                                  output = "REAL";
                                });
                              }
                            });
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                    color: Color(0xff757575),
                                    child: Container(
                                      padding: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(child: SizedBox()),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.blue,
                                                        size: 28),
                                                    onPressed: () {
                                                      setState(() {
                                                        show = false;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(height: 30.0),
                                                Center(
                                                  child: Text("This news",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 36)),
                                                ),
                                                Center(
                                                  child: Text("is most likely",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 48)),
                                                ),
                                                Center(
                                                  child: Text("TO BE..",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 72)),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 60),
                                            Text(output,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 100,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 100),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                show ? CircularProgressIndicator(color: Colors.white) : Text("")
              ],
            ),
          )
        ],
      ),
    );
  }
}
