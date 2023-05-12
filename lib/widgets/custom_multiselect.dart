// import 'package:flutter/material.dart';
//
// class CustomMultiSelect extends StatefulWidget {
//   final List<String> items;
//
//   const CustomMultiSelect({super.key, required this.items});
//
//   @override
//   State<CustomMultiSelect> createState() => _CustomMultiSelectState();
// }
//
// class _CustomMultiSelectState extends State<CustomMultiSelect> {
//   final List<String> _selectedItems = [];
//
//   void _washItemChange(String itemValue, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//     });
//   }
//
//   void _cancel() {
//     Navigator.of(context).pop();
//   }
//
//   void _submit() {
//     Navigator.of(context).pop(_selectedItems);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Select Category'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: widget.items
//               .map(
//                 (item) => CheckboxListTile(
//                   value: _selectedItems.contains(item),
//                   title: Text(item),
//                   controlAffinity: ListTileControlAffinity.leading,
//                   onChanged: (isChecked) => _washItemChange(
//                     item,
//                     isChecked!,
//                   ),
//                 ),
//               )
//               .toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: _cancel,
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _submit,
//           child: const Text('Submit'),
//         ),
//       ],
//     );
//   }
// }
