import 'package:ble/models/directory_node.dart';

void printDirectoryHierarchy(DirectoryNode node, String indent) {
  print(indent + node.name!);
  for (var file in node.files!) {
    print(indent + '-- ' + file);
  }
  for (var subdir in node.subdirectories!) {
    printDirectoryHierarchy(subdir, indent + '-- ');
  }
}
