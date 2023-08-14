import 'package:building_recognition/controller/scan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: CameraPreview(controller.cameraController),
                          ),
                          // CameraPreview(controller.cameraController),
                          Positioned(
                            top: controller.y * 700,
                            right: controller.x * 500,
                            child: Container(
                              width: controller.w * 100 * context.width / 100,
                              height: controller.h * 100 * context.height / 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.white, width: 4.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                // children: [
                                //   Container(
                                //     color: Colors.white,
                                //     child: Text(controller.label),
                                //   )
                                // ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        // width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 33, 41, 54),
                          
                        ),
                        child: Center(
                            child: Text(
                          controller.label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )))
                  ],
                )
              : const Center(
                  child: Text("Loading Camera..."),
                );
        },
      ),
    );
  }
}
