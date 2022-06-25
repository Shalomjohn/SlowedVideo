// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slow_video_test/video_view.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({Key? key}) : super(key: key);

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  List<String> files = [];

  pickNewVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      if (result.files.isNotEmpty) {
        String path = result.files[0].path!;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoView(videoPath: path),
          ),
        );
      }
    }
  }

  setupPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? saves = prefs.getStringList('saves');
    if (saves == null) {
      prefs.setStringList('saves', <String>[]);
    } else {
      files = saves;
      setState(() {});
    }
  }

  @override
  void initState() {
    setupPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     'HOME',
      //   ),
      // ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 30),
            child: Text(
              'Recents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const VideoView(
                        videoPath: null,
                      ))),
              child: const Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    'V02-1.mp4',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pickNewVideo(),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
