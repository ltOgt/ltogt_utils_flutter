import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class FileTreeWidget extends StatelessWidget {
  const FileTreeWidget({
    Key? key,
    required this.fileTree,
    required this.onOpenFile,
    required this.expandedDirectories,
    required this.onToggleDirExpansion,
    this.childInsetLeft = 14,
    this.childHeight = 20,
    this.iconWidth = 14,
    this.iconSpace = 4,
    this.iconPadding = const EdgeInsets.symmetric(vertical: 2),
    this.childPadding = const EdgeInsets.symmetric(vertical: 2),
  }) : super(key: key);

  final FileTree fileTree;
  final void Function(FileTreePath) onOpenFile;
  final double childInsetLeft;
  final double childHeight;
  final double iconWidth;
  final double iconSpace;
  final EdgeInsets iconPadding;
  final EdgeInsets childPadding;

  /// All [FileTreeDir]s pointed to by the [FileTreePath] inside this set will be expanded,
  /// all others will be collapsed.
  ///
  /// Also see [onToggleDirExpansion].
  final Set<FileTreePath> expandedDirectories;

  /// Called when expansion / collapsing of a directory is requested by the user.
  ///
  /// The caller of this widget must update [expandedDirectories] accordingly.
  final void Function(FileTreePath path, bool expanded) onToggleDirExpansion;

  @override
  Widget build(BuildContext context) {
    return FileTreeDirStructureWidget(
      fileTreeDir: fileTree.rootDir,
      parentPath: const [],
      onOpenFile: onOpenFile,
      expandedDirectories: expandedDirectories,
      onToggleDirExpansion: onToggleDirExpansion,
      childInsetLeft: childInsetLeft,
      childHeight: childHeight,
      depth: 0,
      iconSpace: iconSpace,
      iconWidth: iconWidth,
      iconPadding: iconPadding,
      childPadding: childPadding,
    );
  }
}

class FileTreeDirStructureWidget extends StatelessWidget {
  const FileTreeDirStructureWidget({
    Key? key,
    required this.fileTreeDir,
    required this.parentPath,
    required this.expandedDirectories,
    required this.onToggleDirExpansion,
    required this.onOpenFile,
    required this.childInsetLeft,
    required this.childHeight,
    required this.depth,
    required this.iconWidth,
    required this.iconSpace,
    required this.iconPadding,
    required this.childPadding,
  }) : super(key: key);

  final FileTreeDir fileTreeDir;
  final List<String> parentPath;
  final void Function(FileTreePath) onOpenFile;
  final Set<FileTreePath> expandedDirectories;
  final void Function(FileTreePath path, bool expanded) onToggleDirExpansion;
  final double childInsetLeft;
  final double childHeight;
  final int depth;
  final double iconWidth;
  final double iconSpace;
  final EdgeInsets iconPadding;
  final EdgeInsets childPadding;

  @override
  Widget build(BuildContext context) {
    final dirPath = FileTreePath([...parentPath, fileTreeDir.name]);
    bool expanded = expandedDirectories.contains(dirPath);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // This dir
        InkWell(
          onTap: () => onToggleDirExpansion(dirPath, !expanded),
          child: FileTreeDirWidget(
            fileTreeDir: fileTreeDir,
            isExpanded: expanded,
            childHeight: childHeight,
            depth: depth,
            childInsetLeft: childInsetLeft,
            iconSpace: iconSpace,
            iconWidth: iconWidth,
            iconPadding: iconPadding,
            childPadding: childPadding,
          ),
        ),
        // Child Dirs and Files
        if (expanded)
          Column(
            children: [
              // Dirs
              ...List.generate(
                fileTreeDir.dirs.length,
                (index) => FileTreeDirStructureWidget(
                  fileTreeDir: fileTreeDir.dirs[index],
                  parentPath: List.of(parentPath)..add(fileTreeDir.name),
                  expandedDirectories: expandedDirectories,
                  onToggleDirExpansion: onToggleDirExpansion,
                  onOpenFile: onOpenFile,
                  childInsetLeft: childInsetLeft,
                  childHeight: childHeight,
                  depth: depth + 1,
                  iconSpace: iconSpace,
                  iconWidth: iconWidth,
                  iconPadding: iconPadding,
                  childPadding: childPadding,
                ),
              ),
              // Files
              ...List.generate(
                fileTreeDir.files.length,
                (index) => FileTreeFileWidget(
                  parentPath: List.of(parentPath)..add(fileTreeDir.name),
                  fileTreeFile: fileTreeDir.files[index],
                  onOpen: onOpenFile,
                  childHeight: childHeight,
                  depth: depth + 1,
                  childInsetLeft: childInsetLeft,
                  iconSpace: iconSpace,
                  iconWidth: iconWidth,
                  iconPadding: iconPadding,
                  childPadding: childPadding,
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
    required this.iconPadding,
    required this.childPadding,
  }) : super(key: key);

  final FileTreeDir fileTreeDir;
  final bool isExpanded;
  final double childHeight;
  final double childInsetLeft;
  final int depth;
  final double iconWidth;
  final double iconSpace;
  final EdgeInsets iconPadding;
  final EdgeInsets childPadding;

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
            child: Padding(
              padding: iconPadding,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                ),
              ),
            ),
          ),
          SizedBox(
            width: iconSpace,
          ),
          Flexible(
            child: Padding(
              padding: childPadding,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  fileTreeDir.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
    required this.parentPath,
    required this.onOpen,
    required this.childHeight,
    required this.childInsetLeft,
    required this.depth,
    required this.iconWidth,
    required this.iconSpace,
    required this.iconPadding,
    required this.childPadding,
  }) : super(key: key);

  final FileTreeFile fileTreeFile;
  final List<String> parentPath;
  final void Function(FileTreePath) onOpen;
  final double childHeight;
  final double childInsetLeft;
  final int depth;
  final double iconWidth;
  final double iconSpace;
  final EdgeInsets iconPadding;
  final EdgeInsets childPadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onOpen(FileTreePath([...parentPath, fileTreeFile.name])),
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
              child: Padding(
                padding: iconPadding,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(Icons.text_snippet_outlined),
                ),
              ),
            ),
            SizedBox(
              width: iconSpace,
            ),
            Flexible(
              child: Padding(
                padding: childPadding,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    fileTreeFile.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
