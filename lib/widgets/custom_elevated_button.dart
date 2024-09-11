import 'package:flutter/material.dart';  
  
class CustomElevatedButton extends StatelessWidget {  
  final VoidCallback? onPressed;  
  final String buttonText;  
  final IconData? icon;  
  
  CustomElevatedButton({this.icon, this.onPressed, required this.buttonText});  
  
  @override  
  Widget build(BuildContext context) {  
    return ElevatedButton(  
      style: ElevatedButton.styleFrom(  
        elevation: 2,  
        backgroundColor: Colors.black,  
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),  
        shape: RoundedRectangleBorder(  
          borderRadius: BorderRadius.circular(28),  
        ),  
      ),  
      onPressed: onPressed,  
      child: Row(  
        mainAxisSize: MainAxisSize.min,  
        children: [  
          icon == null  
              ? const SizedBox(width: 30)  
              : Icon(  
                  icon,  
                  size: 30,  
                ),  
          Align(
            alignment: Alignment.center,
            child: Text(  
              buttonText,  
              style: const TextStyle(  
                color: Colors.white, 
                 
                fontWeight: FontWeight.bold,  
                fontSize: 30,
              ),  
            ),
          ),  
        ],  
      ),  
    );  
  }  
}