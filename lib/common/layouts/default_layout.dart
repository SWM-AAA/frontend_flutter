import 'package:flutter/material.dart';
// 모든 페이지에 일괄적으로 공통적으로 적용하고 싶을 때 view를 layout으로
// 감싸주면 좋습니다.

// 나중에 모든 view에 특정 기능, (initstate후 api요청) 을 넣고 싶을 때
// default_layout에 넣고 view를 감싸면 됩니다.

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;
  final DecorationImage? backgroundDecorationImage;

  const DefaultLayout({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.backgroundDecorationImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: backgroundDecorationImage,
        ),
        child: child,
      ),
      //Scaffold에서 bottomNavigationBar속성을 지정하면 아래 네비게이션 바를 만들 수 있음
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        // elevation은 Appbar가 앞으로 튀어나온 듯한 효과를 줌
        elevation: 0,
        title: Text(
          title!,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        // AppBar위에 올라가는 위젯들의 색상을 지정
        foregroundColor: Colors.black,
      );
    }
  }
}
