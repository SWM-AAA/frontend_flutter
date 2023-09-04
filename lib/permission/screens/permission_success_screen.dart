import 'package:flutter/material.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/permission/components/bottom/bottom_pinned_position_explain.dart';
import 'package:geolocator/geolocator.dart';

class PermissionSuccessScreen extends StatelessWidget {
  const PermissionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundDecorationImage: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(
          'assets/images/backgrounds/splash_background.png',
        ),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: SizedBox(
                height: 0,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
