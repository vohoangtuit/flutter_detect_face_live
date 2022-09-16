import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceModel {
  double? smilingProbability;
  double? headEulerAngleX;// Head is tilted up and down rotX degrees
  double? headEulerAngleY;// Head is rotated to the right rotY degrees
  double? headEulerAngleZ;// Head is tilted sideways rotZ degrees
  double? leftEyeOpenProbability;
  double? rightEyeOpenProbability;
  FaceLandmark? leftEar;
  FaceLandmark? rightEar;

  FaceModel({
    this.smilingProbability,
    this.headEulerAngleX,
    this.headEulerAngleY,
    this.headEulerAngleZ,
    this.leftEyeOpenProbability,
    this.rightEyeOpenProbability,
    this.leftEar,
    this.rightEar,
  });

  @override
  String toString() {
    return 'FaceModel{smilingProbability: $smilingProbability, headEulerAngleX: $headEulerAngleX, headEulerAngleY: $headEulerAngleY, headEulerAngleZ: $headEulerAngleZ, leftEyeOpenProbability: $leftEyeOpenProbability, rightEyeOpenProbability: $rightEyeOpenProbability, leftEar: $leftEar, rightEar: $rightEar}';
  }
}
