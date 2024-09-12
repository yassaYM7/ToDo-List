import 'package:flutter/material.dart';

Future<void> selectTime({
  required BuildContext context,
  required TimeOfDay selectedTime,
  required bool isTimeSelected,
  required Function(TimeOfDay, bool) onTimeSelected,
}) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );
  if (picked != null) {
    onTimeSelected(picked, true);
  }
}
