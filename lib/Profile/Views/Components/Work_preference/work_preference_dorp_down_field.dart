import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildSelectableListWithChips<T>({
  required List<T> options,
  required List<T> selectedOptions,
  required String Function(T) labelBuilder,
  required void Function(List<T>) onSelectionChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListView.builder(
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final selected = selectedOptions.contains(option);
          return ListTile(
            title: Text(
              labelBuilder(option),
              style: GoogleFonts.inter(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: selected
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              final updatedSelections = [...selectedOptions];
              if (selected) {
                updatedSelections.remove(option);
              } else {
                updatedSelections.add(option);
              }
              onSelectionChanged(updatedSelections);
            },
          );
        },
      ),
      if (selectedOptions.isNotEmpty) ...[
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: selectedOptions
              .map(
                (item) => Chip(
                  label: Text(labelBuilder(item)),
                  deleteIcon: const Icon(Icons.close, color: Colors.black),
                  onDeleted: () {
                    final updatedSelections = [...selectedOptions];
                    updatedSelections.remove(item);
                    onSelectionChanged(updatedSelections);
                  },
                ),
              )
              .toList(),
        ),
      ],
    ],
  );
}
