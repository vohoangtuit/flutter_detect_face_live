import 'package:flutter_face_live/module/face_model.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
//import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetetorController {
  FaceDetector? _faceDetector;

  Future<List<FaceModel>?> processImage(inputImage) async {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );

    final faces = await _faceDetector?.processImage(inputImage);
    return extractFaceInfo(faces);
  }

  List<FaceModel>? extractFaceInfo(List<Face>? faces) {
    List<FaceModel>? response = [];
    double? smilingProbability;
    double? headAngleX;
    double? headAngleY;
    double? headAngleZ;
    double? leftEyeOpenProbability;
    double? rightEyeOpenProbability;

    for (Face face in faces!) {
      final rect = face.boundingBox;

      if (face.smilingProbability != null) {
        smilingProbability = face.smilingProbability;
      }

      headAngleX = face.headEulerAngleX;
      headAngleY = face.headEulerAngleY;
      headAngleZ = face.headEulerAngleZ;
      leftEyeOpenProbability = face.leftEyeOpenProbability;
      rightEyeOpenProbability = face.rightEyeOpenProbability;
      final FaceLandmark leftEar = face.landmarks[FaceLandmarkType.leftEar]!;
      final FaceLandmark rightEar = face.landmarks[FaceLandmarkType.rightEar]!;
      final faceModel = FaceModel(
        smilingProbability: smilingProbability,
        headEulerAngleX: headAngleX,
        headEulerAngleY: headAngleY,
        headEulerAngleZ: headAngleZ,
        leftEyeOpenProbability: leftEyeOpenProbability,
        rightEyeOpenProbability: rightEyeOpenProbability,
        leftEar: leftEar,
        rightEar: rightEar,
      );

      response.add(faceModel);
    }

    return response;
  }
}
