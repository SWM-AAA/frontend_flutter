import 'package:flutter/material.dart';

class AddFreindCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final void Function() clickHandler;

  const AddFreindCard(
      {super.key,
      required this.icon,
      required this.name,
      required this.clickHandler});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickHandler,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.2)),
              child: Icon(
                icon,
                size: 40,
              ),
            ),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
