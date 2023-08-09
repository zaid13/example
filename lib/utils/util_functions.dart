import 'dart:io';

import 'package:ble/models/directory_node.dart';
import 'package:path_provider/path_provider.dart';

void printDirectoryHierarchy(DirectoryNode node, String indent) {
  print(indent + node.name!);
  for (var file in node.files!) {
    print(indent + '-- ' + file);
  }
  for (var subdir in node.subdirectories!) {
    printDirectoryHierarchy(subdir, indent + '-- ');
  }
}

Future<String> createFolderIfNotExists(String folderName) async {
  // Directory? appDir = Directory('/storage/emulated/0/Download');
  Directory? appDir = await getExternalStorageDirectory();
  String folderPath = '${appDir!.path}/$folderName';

  // Create the folder if it doesn't exist
  if (!(await Directory(folderPath).exists())) {
    await Directory(folderPath).create(recursive: true);
  }

  return folderPath;
}
