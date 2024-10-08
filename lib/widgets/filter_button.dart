import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const FilterButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  late bool isToggled;

  @override
  void initState() {
    super.initState();
    isToggled = widget.isSelected;
  }

  void _handlePress() {
    setState(() {
      isToggled = !isToggled;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0, // Set the desired height here
      child: OutlinedButton(
        onPressed: _handlePress,
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            BorderSide(
              color: isToggled ? Colors.blue : const Color(0xFF9C9C9C),
              width: 2.0, // Increase the border weight here
            ),
          ),
          foregroundColor: MaterialStateProperty.all(
            isToggled ? Colors.white : const Color(0xFF9C9C9C),
          ),
          backgroundColor: MaterialStateProperty.all(
            isToggled ? Colors.blue : Colors.transparent,
          ),
        ),
        child: Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Increase the text weight here
          ),
        ),
      ),
    );
  }
}
