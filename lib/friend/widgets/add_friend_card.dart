import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddFreindCard extends StatelessWidget {
  final SvgPicture icon;
  final String name;
  final Color iconBackGroundColor;
  final void Function() clickHandler;

  const AddFreindCard(
      {super.key,
      required this.icon,
      required this.name,
      required this.iconBackGroundColor,
      required this.clickHandler});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickHandler,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffE6E8EC),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(56),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: iconBackGroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: icon,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('Add'),
              SvgPicture.asset('assets/svg/direction-right.svg')
            ],
          ),
        ),
      ),
    );
  }
}
