import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _MyAppState(),
    );
  }
}

class _MyAppState extends StatefulWidget {
  @override
  __MyAppStateState createState() => __MyAppStateState();
}

class __MyAppStateState extends State<_MyAppState> {
  final String apiUrl = "https://newsapi.org/v2/everything?q=tesla&from=2024-02-22&sortBy=publishedAt&apiKey=1c3ca2a0052b46f5a7ae912d0fc7ec5e";
  List<dynamic> _articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      var result = await http.get(Uri.parse(apiUrl));
      setState(() {
        _articles = json.decode(result.body)["articles"];
      });
    } catch (error) {
      print("Error fetching articles: $error");
    }
  }

  void _launchURL(String? url) async {
    if (url != null) {
      try {
        var uri = Uri.parse(url);
        await canLaunch(uri.toString())
            ? await launch(uri.toString())
            : throw 'Could not launch $url';
      } catch (error) {
        print("Error launching URL: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Creator", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  content: Text("นายดนุสรณ์ สุวรรณประสิทธิ์\nนายกฤษณ จันทร์อ้าย\n\nCredit Api: https://newsapi.org/"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.menu,
            color: Color.fromARGB(255, 215, 206, 206),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage('https://i.pinimg.com/564x/16/8e/7b/168e7b6eb325cf2d9bd944ae255121f8.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 80,
                  left: 80,
                  child: Text(
                    'NEWS',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70,
                  left: 85,
                  child: Text(
                    'Breaking news from news\nsources and blogs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 90,
                  child: Text(
                    '[Read news from around the world from here]',
                    style: TextStyle(
                      color: Color.fromARGB(255, 170, 170, 170),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'News to day  ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('  more -->', style: TextStyle(fontSize: 15)),
            ],
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                _articles.length,
                (index) {
                  var article = _articles[index];
                  return GestureDetector(
                    onTap: () {
                      _launchURL(article["url"]);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                       vertical: 10,
                        horizontal: 10,
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Card(
                        color: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              if (article["urlToImage"] != null)
                              Image.network(
                                article["urlToImage"],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Text(
                                article["title"],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              if (article["description"] != null)
                              Text(
                                article["description"],
                                style: TextStyle(fontSize: 14),
                                maxLines: 7,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}