class DirectoryNode {
  String? name;
  List<DirectoryNode>? subdirectories;
  List<String>? files;

  DirectoryNode(this.name) {
    subdirectories = [];
    files = [];
  }

  void addSubdirectory(DirectoryNode subdirectory) {
    subdirectories!.add(subdirectory);
  }

  void addFile(String file) {
    files!.add(file);
  }

  List<String> getAllFiles() {
    List<String> allFiles = [...?files];

    for (var subdirectory in subdirectories!) {
      allFiles.addAll(subdirectory.getAllFiles());
    }

    return allFiles;
  }

  @override
  String toString() {
    return name!;
  }
}
