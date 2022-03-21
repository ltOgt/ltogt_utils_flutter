import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class FileTreeWidget extends StatelessWidget {
  const FileTreeWidget({
    Key? key,
    required this.fileTree,
    required this.onOpenFile,
    this.allExpanded = false,
    this.childInsetLeft = 14,
    this.childHeight = 20,
    this.iconWidth = 14,
    this.iconSpace = 4,
  }) : super(key: key);

  final FileTree fileTree;
  final bool allExpanded;
  final void Function(FileTreePath) onOpenFile;
  final double childInsetLeft;
  final double childHeight;
  final double iconWidth;
  final double iconSpace;

  @override
  Widget build(BuildContext context) {
    return FileTreeDirStructureWidget(
      fileTreeDir: fileTree.rootDir,
      filePath: const [],
      allExpanded: allExpanded,
      onOpenFile: onOpenFile,
      childInsetLeft: childInsetLeft,
      childHeight: childHeight,
      depth: 0,
      iconSpace: iconSpace,
      iconWidth: iconWidth,
    );
  }
}

class FileTreeDirStructureWidget extends StatefulWidget {
  const FileTreeDirStructureWidget({
    Key? key,
    required this.fileTreeDir,
    required this.filePath,
    this.allExpanded = false,
    required this.onOpenFile,
    required this.childInsetLeft,
    required this.childHeight,
    required this.depth,
    required this.iconWidth,
    required this.iconSpace,
  }) : super(key: key);

  final FileTreeDir fileTreeDir;
  final List<String> filePath;
  final bool allExpanded;
  final void Function(FileTreePath) onOpenFile;
  final double childInsetLeft;
  final double childHeight;
  final int depth;
  final double iconWidth;
  final double iconSpace;

  @override
  _FileTreeDirStructureWidgetState createState() => _FileTreeDirStructureWidgetState();
}

class _FileTreeDirStructureWidgetState extends State<FileTreeDirStructureWidget> {
  late bool expanded = widget.allExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // This dir
        InkWell(
          onTap: () => setState(() {
            expanded = !expanded;
          }),
          child: FileTreeDirWidget(
            fileTreeDir: widget.fileTreeDir,
            isExpanded: expanded,
            childHeight: widget.childHeight,
            depth: widget.depth,
            childInsetLeft: widget.childInsetLeft,
            iconSpace: widget.iconSpace,
            iconWidth: widget.iconWidth,
          ),
        ),
        // Child Dirs and Files
        if (expanded)
          Column(
            children: [
              // Dirs
              ...List.generate(
                widget.fileTreeDir.dirs.length,
                (index) => FileTreeDirStructureWidget(
                  fileTreeDir: widget.fileTreeDir.dirs[index],
                  filePath: List.of(widget.filePath)..add(widget.fileTreeDir.name),
                  allExpanded: widget.allExpanded,
                  onOpenFile: widget.onOpenFile,
                  childInsetLeft: widget.childInsetLeft,
                  childHeight: widget.childHeight,
                  depth: widget.depth + 1,
                  iconSpace: widget.iconSpace,
                  iconWidth: widget.iconWidth,
                ),
              ),
              // Files
              ...List.generate(
                widget.fileTreeDir.files.length,
                (index) => FileTreeFileWidget(
                  filePath: List.of(widget.filePath)..add(widget.fileTreeDir.name),
                  fileTreeFile: widget.fileTreeDir.files[index],
                  onOpen: widget.onOpenFile,
                  childHeight: widget.childHeight,
                  depth: widget.depth + 1,
                  childInsetLeft: widget.childInsetLeft,
                  iconSpace: widget.iconSpace,
                  iconWidth: widget.iconWidth,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class FileTreeDirWidget extends StatelessWidget {
  const FileTreeDirWidget({
    Key? key,
    required this.fileTreeDir,
    required this.isExpanded,
    required this.childHeight,
    required this.childInsetLeft,
    required this.depth,
    required this.iconWidth,
    required this.iconSpace,
  }) : super(key: key);

  final FileTreeDir fileTreeDir;
  final bool isExpanded;
  final double childHeight;
  final double childInsetLeft;
  final int depth;
  final double iconWidth;
  final double iconSpace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: childHeight,
      child: Row(
        children: [
          for (int i = 0; i < depth; i++) ...[
            SizedBox(width: childInsetLeft / 2 - 1),
            Container(
              width: 1,
              height: childHeight,
              color: Colors.white,
            ),
            SizedBox(width: childInsetLeft / 2),
          ],
          SizedBox(
            width: iconWidth,
            height: childHeight,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
              ),
            ),
          ),
          SizedBox(
            width: iconSpace,
          ),
          Flexible(
            child: Text(
              fileTreeDir.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class FileTreeFileWidget extends StatelessWidget {
  const FileTreeFileWidget({
    Key? key,
    required this.fileTreeFile,
    required this.filePath,
    required this.onOpen,
    required this.childHeight,
    required this.childInsetLeft,
    required this.depth,
    required this.iconWidth,
    required this.iconSpace,
  }) : super(key: key);

  final FileTreeFile fileTreeFile;
  final List<String> filePath;
  final void Function(FileTreePath) onOpen;
  final double childHeight;
  final double childInsetLeft;
  final int depth;
  final double iconWidth;
  final double iconSpace;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onOpen(FileTreePath([...filePath, fileTreeFile.name])),
      child: SizedBox(
        height: childHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < depth; i++) ...[
              SizedBox(width: childInsetLeft / 2 - 1),
              Container(
                width: 1,
                height: childHeight,
                color: Colors.white,
              ),
              SizedBox(width: childInsetLeft / 2),
            ],
            SizedBox(
              width: iconWidth,
              height: childHeight,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(Icons.text_snippet_outlined),
              ),
            ),
            SizedBox(
              width: iconSpace,
            ),
            Flexible(
              child: Text(
                fileTreeFile.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
