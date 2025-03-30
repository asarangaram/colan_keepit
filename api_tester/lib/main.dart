import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(Solid(
      providers: [
        Provider<Signal<ThemeMode>>(create: () => Signal(ThemeMode.light)),
      ],
      builder: (context) {
        final themeMode = context.observe<ThemeMode>();
        return ShadApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadZincColorScheme.light(),
          ),
          darkTheme: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: const ShadZincColorScheme.dark(),
          ),
          home: DebugScreen(),
        );
      }));
}

String prettyJson(dynamic json) {
  var spaces = ' ' * 4;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  DebugScreenState createState() => DebugScreenState();
}

class DebugScreenState extends State<DebugScreen> {
  VideoPlayerController? videoPlayerController;
  final popoverController = ShadPopoverController();
  final TextEditingController _urlController = TextEditingController();
  final serverURI = 'http://192.168.0.225:5000';
  final List<String> endPoints = [
    '/entity',
    '/entity/<id>',
    '/entity/<id>/download',
    '/entity/<id>/preview',
    '/entity/<id>/stream/m3u8'
  ];
  String? responseData;
  String? imageUrl;
  String? videoUrl;
  String? errorMessage;

  Future<void> fetchData() async {
    setState(() {
      responseData = null;
      imageUrl = null;
      videoUrl = null;
      errorMessage = null;
      videoPlayerController?.dispose();
    });
    Future.delayed(Duration(seconds: 2));

    try {
      final header =
          await http.head(Uri.parse("$serverURI${_urlController.text}"));
      final contentType = header.headers['content-type'] ?? '';
      final contentLength = header.headers['content-length'] ?? '';
      print(contentType);

      if (contentType.contains('application/json')) {
        final response =
            await http.get(Uri.parse("$serverURI${_urlController.text}"));
        setState(() => responseData = prettyJson(jsonDecode(response.body)));
      } else if (contentType.startsWith('image/')) {
        setState(() => imageUrl = "$serverURI${_urlController.text}");
      } else if (contentType.startsWith('application/vnd.apple.mpegurl')) {
        videoUrl = "$serverURI${_urlController.text}";

        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl!))
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {});
              });
        setState(() {
          videoPlayerController!.setLooping(true);
          videoPlayerController!.value.isPlaying
              ? videoPlayerController!.pause()
              : videoPlayerController!.play();
        });
      } else {
        setState(() {
          responseData = "$contentType | file size: $contentLength bytes";
        });
      }
    } catch (e) {
      try {
        final response =
            await http.get(Uri.parse("$serverURI${_urlController.text}"));
        setState(() => responseData = prettyJson(jsonDecode(response.body)));
      } catch (e) {
        /* */
      }

      //setState(() => errorMessage = 'Request failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _urlController.dispose();
    popoverController.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final textTheme = ShadTheme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('API Debugger')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                    child: ShadInput(
                  controller: _urlController,
                  onSubmitted: (value) => fetchData(),
                  prefix: ShadPopover(
                    controller: popoverController,
                    popover: (_) => SizedBox(
                      width: 300,
                      height: 200,
                      child: ListView(
                        children: [
                          ...endPoints.map(
                            (e) => ListTile(
                              title: Text(e),
                              onTap: () {
                                _urlController.text = e;
                                popoverController.hide();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: GestureDetector(
                      onTap: popoverController.toggle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(serverURI),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                  suffix: ShadButton.ghost(
                      onPressed: fetchData, child: Icon(Icons.refresh)),
                )),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
                child: [
              if (responseData != null)
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all()),
                    child: SingleChildScrollView(child: Text(responseData!)))
              else if (imageUrl != null)
                Center(
                  child: Image.network(
                      "${imageUrl!}?t=${DateTime.now().millisecondsSinceEpoch}",
                      fit: BoxFit.scaleDown),
                )
              else if (videoUrl != null)
                if (videoPlayerController != null)
                  Center(
                    child: videoPlayerController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio:
                                videoPlayerController!.value.aspectRatio,
                            child: GestureDetector(
                                onTap: () {
                                  videoPlayerController!.value.isPlaying
                                      ? videoPlayerController!.pause()
                                      : videoPlayerController!.play();
                                },
                                child: VideoPlayer(videoPlayerController!)),
                          )
                        : Container(),
                  )
                else
                  Container()
              else if (errorMessage != null)
                Text(errorMessage!, style: TextStyle(color: Colors.red))
              else
                Text('Enter a URL and press Go.'),
            ][0])
          ],
        ),
      ),
    );
  }
}
