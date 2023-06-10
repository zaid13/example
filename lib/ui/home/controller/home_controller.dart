import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<int> currentLoadingFile = Rx(1);
  Rx<bool> isMainFolderSeleceted = Rx(false);
  Rx<int> mainSelectedFolder = Rx(1);
  Rx<bool> isSubFolderSelected = Rx(false);
  Rx<int> subSelectedFolder = Rx(1);
}
