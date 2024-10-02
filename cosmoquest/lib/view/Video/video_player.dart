import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/view/Game_2/Screens/GameScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final LevelModel level;

  const VideoPlayerScreen({super.key, required this.level, required this.videoPath});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _isPlaying = false;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // link = getVideoUrl().toString();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    String link = await getVideoUrl();
    // Initialize the video player with the video URL
    _initializeVideoPlayerFuture = _controller?.initialize().then((_) {
      setState(() {}); // Ensure the first frame is shown
    });
    _controller = VideoPlayerController.networkUrl(Uri.parse(link))
      ..addListener(() {
        setState(() {}); // Update the UI
      })
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

    // Auto-play the video if desired
    _controller?.play();
    _isPlaying = true;
  }

  Future<String> getVideoUrl() async {
    try {
      String downloadURL = await FirebaseStorage.instance.ref(widget.videoPath).getDownloadURL();
      // print(downloadURL);
      return downloadURL;
    } catch (e) {
      print("Error fetching video URL: $e");
      return '';
    }
  }

  @override
  void dispose() {
    // Restore the orientation to portrait when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller?.dispose();
    super.dispose();
  }

  // Switch to landscape
  void _enterFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  // Switch back to portrait
  void _exitFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: Lottie.asset(width: 100, height: 100,
          'assets/Animations/videoLoaing.json')) :
      Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller!),
                ClosedCaption(
                  text: _controller?.value.caption.text,
                  textStyle: TextStyle(fontSize: 20, color: Colors.white, backgroundColor: Colors.black12.withOpacity(0.1)),
                ),
                _ControlsOverlay(controller: _controller!, onFullScreenToggle: () {
                  if (_controller!.value.isPlaying) {
                    _enterFullScreen();
                  } else {
                    _exitFullScreen();
                  }
                },),
                VideoProgressIndicator(_controller!, allowScrubbing: true),
                // _PlayPauseOverlay(controller: _controller!),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildVideoControls() {
    return Column(
      children: [
        IconButton(onPressed: (){
          setState(() {
            _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
            _isPlaying = !_isPlaying;
          });
        }, icon: Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow)

        ),
        VideoProgressIndicator(
            _controller!,
            allowScrubbing: true,
          colors: const VideoProgressColors(
            playedColor: Colors.red,
            bufferedColor: Colors.grey,
            backgroundColor: Colors.black,
          ),
        ),
        IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenVideoPlayer(controller: _controller!)));
        }, icon: const Icon(Icons.fullscreen))
      ],
    );
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller),),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: const Icon(Icons.fullscreen_exit),),
    );
  }}

class _ControlsOverlay extends StatelessWidget {
  final VoidCallback onFullScreenToggle;
  const _ControlsOverlay({required this.controller, required this.onFullScreenToggle});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: onFullScreenToggle,
          ),
        ),
      ],
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
        ),
      ],
    );
  }
}
