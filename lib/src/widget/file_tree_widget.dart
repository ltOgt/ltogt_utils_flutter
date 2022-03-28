import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

enum FileTreeSorting {
  descending,
  ascending,
  none,
}

/// Style for a row inside [FileTreeWidget].
class FileTreeEntryStyle {
  /// Background color across the entire row.
  final Color? colorBg;

  /// TextStyle of the rows text.
  final TextStyle? textStyle;

  /// Hover color across the entries row.
  final Color? hoverColor;

  /// Color for all scope indicator lines across the entire row.
  final Color? scopeIndicatorColor;

  /// Color for the rows icon
  final Color? iconColor;

  const FileTreeEntryStyle({
    this.colorBg,
    this.textStyle,
    this.hoverColor,
    this.scopeIndicatorColor,
    this.iconColor,
  });
}

class FileTreeWidgetStyle {
  /// The space that each rows content is moved right in relation to its parent
  final double childInsetLeft;

  /// The height of each row
  final double rowHeight;

  /// The width to which file and directory icons are [BoxFit.contain]ed in combination with [rowHeight].
  final double iconWidth;

  /// The space between the file/directory-icon and the file/directory-name
  final double iconToTextGapWidth;

  /// Additional padding applied around the icon inside of [iconWidth] and [rowHeight].
  final EdgeInsets iconPadding;

  /// Additional padding applied around file/directory-name inside [rowHeight]
  final EdgeInsets textPadding;

  // --------------------------------------------------------------------------- File Style

  /// Style for [FileTreeWidget.openFiles]
  final FileTreeEntryStyle openFileRowStyle;

  /// Style for non [FileTreeWidget.openFiles].
  ///
  /// Its values are also used as fallback for `null` values inside [openFileRowStyle].
  final FileTreeEntryStyle fileRowStyle;

  // --------------------------------------------------------------------------- Directory Style
  /// Style for [FileTreeWidget.openFiles]
  final FileTreeEntryStyle expandedDirectoryRowStyle;

  /// Style for non [FileTreeWidget.openFiles].
  ///
  /// Its values are also used as fallback for `null` values inside [expandedDirectoryRowStyle].
  final FileTreeEntryStyle directoryRowStyle;

  const FileTreeWidgetStyle({
    this.childInsetLeft = 14,
    this.rowHeight = 20,
    this.iconWidth = 14,
    this.iconToTextGapWidth = 4,
    this.iconPadding = const EdgeInsets.symmetric(vertical: 2),
    this.textPadding = const EdgeInsets.symmetric(vertical: 2),
    this.openFileRowStyle = const FileTreeEntryStyle(),
    this.fileRowStyle = const FileTreeEntryStyle(),
    this.expandedDirectoryRowStyle = const FileTreeEntryStyle(),
    this.directoryRowStyle = const FileTreeEntryStyle(),
  });

  // --------------------------------------------------------------------------- Resolve actual style to be used
  // ........................................................................... background
  Color _resolveBgColor(bool isOpen, FileTreeEntryStyle active, FileTreeEntryStyle inactive) => (isOpen) //
      ? active.colorBg ?? inactive.colorBg ?? Colors.transparent
      : inactive.colorBg ?? Colors.transparent;

  Color resolveFileColorBg(bool isOpen) => _resolveBgColor(isOpen, openFileRowStyle, fileRowStyle);
  Color resolveDirColorBg(bool isOpen) => _resolveBgColor(isOpen, expandedDirectoryRowStyle, directoryRowStyle);

  // ........................................................................... text
  TextStyle? _resolveTextStyle(bool isOpen, FileTreeEntryStyle active, FileTreeEntryStyle inactive) => (isOpen) //
      ? active.textStyle ?? inactive.textStyle
      : inactive.textStyle;

  TextStyle? resolveFileTextStyle(bool isOpen) => _resolveTextStyle(isOpen, openFileRowStyle, fileRowStyle);
  TextStyle? resolveDirTextStyle(bool isOpen) =>
      _resolveTextStyle(isOpen, expandedDirectoryRowStyle, directoryRowStyle);

  // ........................................................................... hover
  Color? _resolveHoverColor(bool isOpen, FileTreeEntryStyle active, FileTreeEntryStyle inactive) => (isOpen) //
      ? active.hoverColor ?? inactive.hoverColor
      : inactive.hoverColor;

  Color? resolveFileHoverColor(bool isOpen) => _resolveHoverColor(isOpen, openFileRowStyle, fileRowStyle);
  Color? resolveDirHoverColor(bool isOpen) => _resolveHoverColor(isOpen, expandedDirectoryRowStyle, directoryRowStyle);

  // ........................................................................... scope color
  Color _resolveScopeColor(bool isOpen, FileTreeEntryStyle active, FileTreeEntryStyle inactive) => (isOpen) //
      ? active.scopeIndicatorColor ?? inactive.scopeIndicatorColor ?? Colors.black
      : inactive.scopeIndicatorColor ?? Colors.black;

  Color resolveFileScopeColor(bool isOpen) => _resolveScopeColor(isOpen, openFileRowStyle, fileRowStyle);
  Color resolveDirScopeColor(bool isOpen) => _resolveScopeColor(isOpen, expandedDirectoryRowStyle, directoryRowStyle);

  // ........................................................................... icon color
  Color? _resolveIconColor(bool isOpen, FileTreeEntryStyle active, FileTreeEntryStyle inactive) => (isOpen) //
      ? active.iconColor ?? inactive.iconColor
      : inactive.iconColor;

  Color? resolveFileIconColor(bool isOpen) => _resolveIconColor(isOpen, openFileRowStyle, fileRowStyle);
  Color? resolveDirIconColor(bool isOpen) => _resolveIconColor(isOpen, expandedDirectoryRowStyle, directoryRowStyle);
}

class FileTreeWidget extends StatelessWidget {
  const FileTreeWidget({
    Key? key,
    required this.fileTree,
    required this.onOpenFile,
    required this.expandedDirectories,
    required this.onToggleDirExpansion,
    this.openFiles = const {},
    this.style = const FileTreeWidgetStyle(),
    this.sorting = FileTreeSorting.none,
  }) : super(key: key);

  final FileTree fileTree;
  final void Function(FileTreePath) onOpenFile;

  /// Used to highlight open files
  final Set<FileTreePath> openFiles;

  /// All [FileTreeDir]s pointed to by the [FileTreePath] inside this set will be expanded,
  /// all others will be collapsed.
  ///
  /// Also see [onToggleDirExpansion].
  final Set<FileTreePath> expandedDirectories;

  /// Called when expansion / collapsing of a directory is requested by the user.
  ///
  /// The caller of this widget must update [expandedDirectories] accordingly.
  final void Function(FileTreePath path, bool expanded) onToggleDirExpansion;

  final FileTreeWidgetStyle style;

  final FileTreeSorting sorting;

  @override
  Widget build(BuildContext context) {
    return FileTreeDirStructureWidget(
      fileTreeDir: fileTree.rootDir,
      parentPath: const [],
      onOpenFile: onOpenFile,
      expandedDirectories: expandedDirectories,
      onToggleDirExpansion: onToggleDirExpansion,
      depth: 0,
      openFiles: openFiles,
      style: style,
      sorting: sorting,
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
    required this.depth,
    required this.openFiles,
    required this.style,
    required this.sorting,
  }) : super(key: key);

  final FileTreeDir fileTreeDir;
  final List<String> parentPath;
  final void Function(FileTreePath) onOpenFile;
  final Set<FileTreePath> expandedDirectories;
  final void Function(FileTreePath path, bool expanded) onToggleDirExpansion;

  final int depth;
  final Set<FileTreePath> openFiles;
  final FileTreeWidgetStyle style;

  final FileTreeSorting sorting;

  int _desc(FileTreeEntity a, FileTreeEntity b) => a.name.toLowerCase().compareTo(b.name.toLowerCase());
  int _asc(FileTreeEntity a, FileTreeEntity b) => -1 * _desc(a, b);

  @override
  Widget build(BuildContext context) {
    final dirPath = FileTreePath([...parentPath, fileTreeDir.name]);
    bool expanded = expandedDirectories.contains(dirPath);

    final dirs = [...fileTreeDir.dirs];
    final files = [...fileTreeDir.files];
    switch (sorting) {
      case FileTreeSorting.descending:
        dirs.sort(_desc);
        files.sort(_desc);
        break;
      case FileTreeSorting.ascending:
        dirs.sort(_asc);
        files.sort(_asc);
        break;
      case FileTreeSorting.none:
        break;
    }

    final path = [...parentPath, fileTreeDir.name];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // This dir
        FileTreeDirWidget(
          onTap: () => onToggleDirExpansion(dirPath, !expanded),
          fileTreeDir: fileTreeDir,
          isExpanded: expanded,
          depth: depth,
          style: style,
        ),
        // Child Dirs and Files
        if (expanded)
          Column(
            children: [
              // Dirs
              ...List.generate(
                dirs.length,
                (index) => FileTreeDirStructureWidget(
                  fileTreeDir: dirs[index],
                  parentPath: path,
                  expandedDirectories: expandedDirectories,
                  onToggleDirExpansion: onToggleDirExpansion,
                  onOpenFile: onOpenFile,
                  depth: depth + 1,
                  openFiles: openFiles,
                  style: style,
                  sorting: sorting,
                ),
              ),
              // Files
              ...List.generate(
                files.length,
                (index) => FileTreeFileWidget(
                  parentPath: path,
                  fileTreeFile: files[index],
                  onOpen: onOpenFile,
                  depth: depth + 1,
                  openFiles: openFiles,
                  style: style,
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
    required this.depth,
    required this.style,
    required this.onTap,
  }) : super(key: key);

  final FileTreeDir fileTreeDir;
  final bool isExpanded;

  final int depth;
  final FileTreeWidgetStyle style;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: style.resolveDirColorBg(isExpanded),
      child: InkWell(
        onTap: onTap,
        hoverColor: style.resolveDirHoverColor(isExpanded),
        child: SizedBox(
          height: style.rowHeight,
          child: Row(
            children: [
              for (int i = 0; i < depth; i++) ...[
                SizedBox(width: style.childInsetLeft / 2 - 1),
                Container(
                  width: 1,
                  height: style.rowHeight,
                  color: style.resolveDirScopeColor(isExpanded),
                ),
                SizedBox(width: style.childInsetLeft / 2),
              ],
              SizedBox(
                width: style.iconWidth,
                height: style.rowHeight,
                child: Padding(
                  padding: style.iconPadding,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                      color: style.resolveDirIconColor(isExpanded),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: style.iconToTextGapWidth,
              ),
              Flexible(
                child: Padding(
                  padding: style.textPadding,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      fileTreeDir.name,
                      overflow: TextOverflow.ellipsis,
                      style: style.resolveDirTextStyle(isExpanded),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
    required this.depth,
    required this.openFiles,
    required this.style,
  }) : super(key: key);

  final FileTreeFile fileTreeFile;
  final List<String> parentPath;
  final void Function(FileTreePath) onOpen;

  final int depth;

  final Set<FileTreePath> openFiles;
  final FileTreeWidgetStyle style;

  @override
  Widget build(BuildContext context) {
    final path = FileTreePath([...parentPath, fileTreeFile.name]);
    final isOpen = openFiles.contains(path);

    return Material(
      color: style.resolveFileColorBg(isOpen),
      child: InkWell(
        onTap: () => onOpen(path),
        hoverColor: style.resolveFileHoverColor(isOpen),
        child: SizedBox(
          height: style.rowHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < depth; i++) ...[
                SizedBox(width: style.childInsetLeft / 2 - 1),
                Container(
                  width: 1,
                  height: style.rowHeight,
                  color: style.resolveFileScopeColor(isOpen),
                ),
                SizedBox(width: style.childInsetLeft / 2),
              ],
              SizedBox(
                width: style.iconWidth,
                height: style.rowHeight,
                child: Padding(
                  padding: style.iconPadding,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      Icons.text_snippet_outlined,
                      color: style.resolveFileIconColor(isOpen),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: style.iconToTextGapWidth,
              ),
              Flexible(
                child: Padding(
                  padding: style.textPadding,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      fileTreeFile.name,
                      overflow: TextOverflow.ellipsis,
                      style: style.resolveFileTextStyle(isOpen),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
