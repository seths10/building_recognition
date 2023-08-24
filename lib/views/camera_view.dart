// Import necessary packages
import 'package:building_recognition/controller/scan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Define a widget class named CameraView
class CameraView extends StatelessWidget {
  // Constructor for the CameraView widget
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    // Build the UI using the Scaffold widget
    return Scaffold(
      // Extend body behind the app bar
      extendBodyBehindAppBar: true,
      // Customize the app bar
      appBar: AppBar(
        title: const Text(
          "UCC Buildings",
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(75)),
        ),
      ),
      // Build the body of the Scaffold using GetBuilder widget from the Get package
      body: GetBuilder<ScanController>(
        // Initialize the controller for the GetBuilder widget
        init: ScanController(),
        // Build the UI based on the controller's state
        builder: (controller) {
          // Check if the camera is initialized
          return controller.isCameraInitialized.value
              ? Column(
                  children: [
                    // Create a camera preview area within a Stack
                    Expanded(
                      child: Stack(
                        children: [
                          // Display the camera preview
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: CameraPreview(controller.cameraController),
                          ),
                          // Display a message to get closer to a building for accurate results
                          const Center(
                            child: Text(
                              "kindly get closer to a building for accurate results.",
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Display a container with building label
                    Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 33, 41, 54),
                      ),
                      child: Center(
                        child: Text(
                          controller.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              // Display a loading message if the camera is not initialized
              : const Center(
                  child: Text("Loading Camera..."),
                );
        },
      ),
    );
  }
}
