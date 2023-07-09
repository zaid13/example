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

  @override
  String toString() {
    return name!;
  }
}
