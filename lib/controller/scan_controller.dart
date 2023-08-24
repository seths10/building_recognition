import 'dart:developer'; // Import the developer logging library
import 'package:camera/camera.dart'; // Import the camera package
import 'package:flutter_tflite/flutter_tflite.dart'; // Import the TensorFlow Lite package
import 'package:get/get.dart'; // Import the Get package for state management
import 'package:permission_handler/permission_handler.dart'; // Import the permission handling package

// Define a GetxController class named ScanController
class ScanController extends GetxController {
  @override
  void onInit() {
    initCamera(); // Initialize the camera
    initTfLite(); // Initialize TensorFlow Lite model
    super.onInit();
  }

  @override
  void dispose() {
    cameraController.dispose(); // Dispose of the camera controller
    Tflite.close(); // Close TensorFlow Lite
    super.dispose();
  }

  late CameraController cameraController; // Controller for camera
  late List<CameraDescription> cameras; // List of available cameras

  var isCameraInitialized = false.obs; // Observable for camera initialization status
  var cameraCount = 0; // Counter for camera frames processed
  var label = ""; // Detected object label

  // Function to initialize the camera
  initCamera() async {
    // Request camera permission
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras(); // Get available cameras
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await cameraController.initialize().then((value) {
        // Start processing camera frames
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 50 == 0) {
            cameraCount = 0;
            objectDetector(image); // Run object detection on the frame
          }
          update(); // Update UI
        });
      });
      isCameraInitialized(true); // Update camera initialization status
      update(); // Update UI
    } else {
      print("Permission Denied"); // Log permission denial
    }
  }

  // Function to initialize TensorFlow Lite model
  initTfLite() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite", // Model file path
      labels: "assets/labels.txt", // Labels file path
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  // Function to perform object detection on a camera image
  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.1,
      asynch: true,
    );

    if (detector != null) {
      log("Result is $detector"); // Log the detection result
      var detectedObject = detector.first;
      if (detectedObject['confidence'] * 100 > 99) {
        label = detectedObject['label'].toString(); // Set the detected label
      } else {
        label = "Scan a building"; // Set label if confidence is low
      }
      update(); // Update UI
    }
  }
}
