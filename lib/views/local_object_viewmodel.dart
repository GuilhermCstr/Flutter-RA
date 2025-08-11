import 'package:ar_flutter_plugin_updated/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_updated/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalObjectViewModel {
  final String fileName;

  LocalObjectViewModel(this.fileName);

  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  Future<void> initAR(
    ARSessionManager session,
    ARObjectManager object,
    ARAnchorManager anchor,
  ) async {
    arSessionManager = session;
    arObjectManager = object;
    arAnchorManager = anchor;

    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "triangle.png",
      showWorldOrigin: true,
      handleTaps: true,
    );

    arObjectManager!.onInitialize();
    arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    arObjectManager!.onNodeTap = onNodeTapped;
  }

  Future<void> onRemoveEverything() async {
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    arSessionManager!.onError!("Tapped $number node(s)");
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    var hit = hitTestResults.firstWhere(
      (result) => result.type == ARHitTestResultType.plane,
      orElse: () => throw Exception("Nenhum plano detectado"),
    );

    var newAnchor = ARPlaneAnchor(transformation: hit.worldTransform);
    bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);

    if (didAddAnchor == true) {
      anchors.add(newAnchor);

      var newNode = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        uri: fileName,
        scale: Vector3(0.6, 0.6, 0.6),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );

      bool? didAddNode = await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
      if (didAddNode == true) {
        nodes.add(newNode);
      } else {
        arSessionManager!.onError!("Falha ao adicionar objeto ao anchor");
      }
    } else {
      arSessionManager!.onError!("Falha ao criar anchor");
    }
  }
}
