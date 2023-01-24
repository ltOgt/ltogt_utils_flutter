// import 'package:flutter/material.dart';
// import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

// typedef FormQuickElementId = String;

// class FormQuickElement<T> {
//   final T value;
//   final void Function(T) onChange;
//   final T? min;
//   final T? max;

//   final List<T>? options;

//   FormQuickElement({
//     required this.value,
//     required this.onChange,
//     this.min,
//     this.max,
//     this.options,
//   });

//   bool get isEnum => options != null;
//   bool get isString => T is String;
//   bool get isInt => T is int;
//   bool get isDouble => T is double;

//   Type get type => T;
// }

// /// A quick and ugly form to prototype uis or apis.
// class FormQuick extends StatefulWidget {
//   FormQuick({
//     super.key,
//     required this.formQuickElements,
//   });

//   final Map<FormQuickElementId, FormQuickElement> formQuickElements;

//   @override
//   State<FormQuick> createState() => _FormQuickState();
// }

// class _FormQuickState extends ComponentState<FormQuick> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: ListGenerator.seperated(
//         list: widget.formQuickElements.entries.toList(),
//         seperator: SizedBox(height: 10),
//         builder: (MapEntry<String, FormQuickElement> entry, int i) {
//           if (entry.value.isEnum) {
//             return DropdownButton(
//               items: entry.value.options!.map((e) => DropdownMenuItem(child: Text(e.toString()))).toList(),
//               onChanged: entry.value.onChange,
//             );
//           }

//           if (entry.value.isString) {
//             return _TextInput(
//               text: entry.value as String,
//               onChange: entry.value.onChange,
//             );
//           }

//           if (entry.value.isInt) {
//             return Slider(
//               value: (entry.value.value as int).toDouble(),
//               onChanged: (d) => entry.value.onChange(d.round()),
//               min: entry.value.min,
//               max: entry.value.max,
//             );
//           }

//           if (entry.value.isDouble) {
//             return Slider(
//               value: (entry.value.value as double),
//               onChanged: entry.value.onChange,
//               min: entry.value.min,
//               max: entry.value.max,
//             );
//           }

//           return Text("Unsupported Type: ${entry.value.type}");
//         },
//       ),
//     );
//   }
// }

// class _TextInput extends StatefulWidget {
//   _TextInput({
//     required this.text,
//     required this.onChange,
//   });

//   final String text;
//   final void Function(String text) onChange;

//   @override
//   State<_TextInput> createState() => __TextInputState();
// }

// class __TextInputState extends ComponentState<_TextInput> {
//   late final StateComponentText ctrl = StateComponentText(
//     state: this,
//     onInit: () => TextEditingController(text: widget.text),
//     onDidUpdateWidget: (oldWidget) {
//       oldWidget as _TextInput;
//       if (oldWidget.text != widget.text) {
//         ctrl.obj.text = widget.text;
//       }
//       return null;
//     },
//   );

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged: (value) => widget.onChange(value),
//     );
//   }
// }
