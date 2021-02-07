import 'package:flutter/material.dart';
import 'package:gsheets_db/feedback_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FeedbackModel> feedbacks = List<FeedbackModel>();

  getFeedbackFromSheet () async {
    var raw = await http.get("https://script.google.com/macros/s/AKfycbxmdvTQLSb5P5bkL_hwmLLLO7gxSfkKmuKl6Re8LpWT43CcyDo/exec");
    var jsonFeedback = convert.jsonDecode(raw.body);

    jsonFeedback.forEach((element) {
      FeedbackModel feedbackModel = FeedbackModel();

      feedbackModel.profilePicture = element['profile_picture'];
      feedbackModel.name = element['name'];
      feedbackModel.manga = element['manga'];
      feedbackModel.details = element['details'];
      feedbackModel.url = element['url'];

      feedbacks.add(feedbackModel);
    });
  }

  @override
  void initState() {
    getFeedbackFromSheet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inner Kara Members"),
        elevation: 0,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: feedbacks.length,
          itemBuilder: (context, index) {
            return FeedbackTile(
              profilePicture: feedbacks[index].profilePicture,
              name: feedbacks[index].name,
              manga: feedbacks[index].manga,
              details: feedbacks[index].details,
              url: feedbacks[index].url,
            );
          },
        ),
      ),
    );
  }
}

class FeedbackTile extends StatelessWidget {
  final String profilePicture, name, manga, details, url;

  FeedbackTile({this.profilePicture, this.name, this.manga, this.details, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Image.network(profilePicture);
                      });
                },
                child: Container(
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Image.network(profilePicture, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                    style: TextStyle(fontSize: 15),
                  ),
                  Text("Debut: $manga",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              await operUrl(url, forceWebView: true, enableJavaScript: true);
            },
            child: Text(details,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> operUrl(String url, {bool forceWebView = false,
  bool enableJavaScript = false}) async {
  if(await canLaunch(url)) {
    await launch(url,
        forceWebView: forceWebView, enableJavaScript: enableJavaScript);
  }
}