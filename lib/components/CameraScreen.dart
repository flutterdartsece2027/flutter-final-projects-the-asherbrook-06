// packages
import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';

// models
import 'package:buzz/models/Chat.dart';

// screens
import 'package:buzz/screens/PreviewPage.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.chat});

  final Chat chat;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  FlashMode _flashMode = FlashMode.off;
  late Future<void> cameraValue;
  int cameraIndex = 0;

  void takePicture(BuildContext context) async {
    final String path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    final XFile picture = await _cameraController.takePicture();

    await picture.saveTo(path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPreviewPage(path: path, chat: widget.chat),
      ),
    );
  }

  void toggleFlash() async {
    setState(() {
      switch (_flashMode) {
        case FlashMode.off:
          _flashMode = FlashMode.auto;
          break;
        case FlashMode.auto:
          _flashMode = FlashMode.always;
          break;
        case FlashMode.always:
          _flashMode = FlashMode.torch;
          break;
        case FlashMode.torch:
          _flashMode = FlashMode.off;
          break;
      }
    });

    await _cameraController.setFlashMode(_flashMode);
  }

  void flipCamera() async {
    await _cameraController.dispose();
    cameraIndex = (cameraIndex + 1) % cameras.length;
    _cameraController = CameraController(cameras[cameraIndex], ResolutionPreset.ultraHigh);

    setState(() {
      cameraValue = _cameraController.initialize();
    });
    await _cameraController.setFlashMode(_flashMode);
  }

  @override
  void initState() {
    super.initState();
    try {
      _cameraController = CameraController(cameras[cameraIndex], ResolutionPreset.ultraHigh);
      cameraValue = _cameraController.initialize();
    } catch (e) {
      log('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.black,
        title: Text("Camera", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FutureBuilder(
                  future: cameraValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_cameraController);
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(
                                _flashMode == FlashMode.off
                                    ? Icons.flash_off
                                    : _flashMode == FlashMode.auto
                                    ? Icons.flash_auto
                                    : _flashMode == FlashMode.always
                                    ? Icons.flash_on
                                    : Icons.flashlight_on,
                                size: 32,
                                color: Colors.white,
                              ),
                              onPressed: toggleFlash,
                            ),
                            GestureDetector(
                              child: Icon(
                                HugeIcons.strokeRoundedCircle,
                                size: 72,
                                color: Colors.white,
                              ),
                              onTap: () {
                                takePicture(context);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                HugeIcons.strokeRoundedFlipLeft,
                                size: 32,
                                color: Colors.white,
                              ),
                              onPressed: flipCamera,
                            ),
                          ],
                        ),
                        Text(
                          "Tap for Photo",
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
