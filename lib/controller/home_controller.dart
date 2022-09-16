import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_live/controller/camera_controller.dart';
import 'package:flutter_face_live/controller/face_detention_controller.dart';
import 'package:flutter_face_live/module/face_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:google_ml_kit/google_ml_kit.dart';

class HomeController extends GetxController {
  CameraManager? _cameraManager;
  CameraController? cameraController;
  FaceDetetorController? _faceDetect;
  bool _isDetecting = false;
  List<FaceModel>? faces;
  String? faceAtMoment = 'normal_face.png';
  String? label = '';
  String? headRoteRight = '';
  FaceLandmark? leftEar;
  FaceLandmark? rightEar;
  FaceLandmark? faceLandmark;
  String? head = 'head: ';
  String? eulerAngle = '';
  String nameHead='';
  HomeController() {
    _cameraManager = CameraManager();
    _faceDetect = FaceDetetorController();
  }

  Future<void> loadCamera() async {
    cameraController = await _cameraManager?.load();
    update();
  }

  Future<void> startImageStream() async {
    CameraDescription camera = cameraController!.description;

    cameraController?.startImageStream((cameraImage) async {
      if (_isDetecting) return;

      _isDetecting = true;

      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
          Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

      //final InputImageRotation imageRotation = InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;
      const InputImageRotation imageRotation =  InputImageRotation.rotation0deg;

     // final InputImageFormat inputImageFormat = InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ?? InputImageFormat.nv21;
      const InputImageFormat inputImageFormat = InputImageFormat.nv21;

      final planeData = cameraImage.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        inputImageData: inputImageData,
      );

      processImage(inputImage);
    });
  }

  Future<void> processImage(inputImage) async {
    faces = await _faceDetect?.processImage(inputImage);

    if (faces != null && faces!.isNotEmpty) {
      //print('faces:: ${faces.toString()}');
      FaceModel? face = faces?.first;
      label = detectSmile(face?.smilingProbability);

      // print('headEulerAngleY ${face?.headEulerAngleY}');
      // print('headEulerAngleZ ${face?.headEulerAngleZ}');
      leftEar  =face?.leftEar;
      rightEar  =face?.rightEar;
      head =detectHeadRote(face?.headEulerAngleY,face?.headEulerAngleZ);
      eulerAngle=' ${face?.headEulerAngleY} : ${face?.headEulerAngleZ}';
    } else {
      faceAtMoment = 'normal_face.png';
      //label = 'Not face detected';
      label = '';
    }
    _isDetecting = false;
    update();
  }

  String detectSmile(smileProb) {
    if (smileProb > 0.86) {
      faceAtMoment = 'happy_face.png';
      return 'Bạn cười thấy răng';
    } else if (smileProb > 0.8) {
      faceAtMoment = 'happy_face.png';
      return 'Bạn cười to';
    } else if (smileProb > 0.3) {
      faceAtMoment = 'happy_face.png';
      return 'Bạn cười';
    } else {
      faceAtMoment = 'sady_face.png';
      return 'Bạn buồn';
    }
  }
  String detectHeadRote(headEulerAngleY,headEulerAngleZ) {
    print('headEulerAngle $headEulerAngleY : headEulerAngleZ $headEulerAngleZ');
    if(headEulerAngleY<-41&&headEulerAngleZ<0){
      return 'head: Xoay Phãi';
    }else if(headEulerAngleZ>41&&headEulerAngleY<0){
      return 'head: xoay trái';
    }
      return 'head:';
  }

}
