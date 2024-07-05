import 'package:flutter/material.dart';
import 'package:supabase_auth/utils/colors.dart';

class MultiSelectChipWidget extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectChipWidget({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  _MultiSelectChipWidgetState createState() => _MultiSelectChipWidgetState();
}

class _MultiSelectChipWidgetState extends State<MultiSelectChipWidget> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text(
              item,
              style: TextStyle(color: Colors.white),
            ),
            checkmarkColor: AppColors.mainColor,
            selectedColor: Colors.grey[850],
            backgroundColor:
                Colors.grey[850], // Lighter background for unselected chips
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: _selectedItems.contains(item)
                    ? AppColors.mainColor
                    : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            selected: _selectedItems.contains(item),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  if (!_selectedItems.contains(item)) {
                    _selectedItems.add(item);
                  }
                } else {
                  _selectedItems.remove(item);
                }
                widget.onSelectionChanged(_selectedItems);
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
