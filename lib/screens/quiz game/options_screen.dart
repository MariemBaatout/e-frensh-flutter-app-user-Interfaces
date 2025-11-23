// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/constants.dart';

class Options extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool isDisabled; // Add this to control if option is disabled
  final VoidCallback onTap;

  const Options({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap, // Disable if already selected
      child: Column(
        children: [
          Container(
            height: 48,
            width: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 3, color: primaryColor),
              color: isSelected
                  ? Colors.green.withOpacity(0.3)
                  : Colors.white, // Highlight if selected
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Radio(
                      value: true,
                      groupValue: isSelected,
                      onChanged: isDisabled
                          ? null
                          : (_) {
                              onTap(); // Trigger onTap when selected
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
