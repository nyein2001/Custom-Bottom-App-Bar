import 'dart:math' as math;
import 'package:custom_app_bar/cubit/loading_cubit.dart';
import 'package:custom_app_bar/cubit/menu_cubit.dart';
import 'package:custom_app_bar/screens/drive_screen.dart';
import 'package:custom_app_bar/screens/earning_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AppMenuCubit>(
          create: (BuildContext context) => AppMenuCubit(),
        ),
        BlocProvider<LoadingCubit>(
          create: (BuildContext context) => LoadingCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true),
        home: const AppMenu(),
      ),
    );
  }
}

class AppMenu extends StatefulWidget {
  const AppMenu({super.key});
  @override
  AppMenuState createState() => AppMenuState();
}

class AppMenuState extends State<AppMenu> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  static const _itemCount = 12;

  @override
  void initState() {
    super.initState();
    _controller = (AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200)))
      ..repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppMenuCubit, int>(builder: (context, state) {
      final isOnline = state == 1;
      return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [DriveScreen(), EarningScreen()],
            ),
          ],
        ),
        bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomAppBar(
                elevation: 7,
                notchMargin: 7,
                clipBehavior: Clip.antiAlias,
                shape: const CustomCircularNotchedRectangle(),
                child: NavBar(state))),
        floatingActionButton:
            BlocBuilder<LoadingCubit, int>(builder: (context, state) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: state == 2 ? 75 : 100,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isOnline ? Colors.green : Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      offset: const Offset(0.0, 5.0),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: state == 1 ? Colors.red : Colors.green,
                  onPressed: () {
                    context.read<LoadingCubit>().handleGoOnlineOffline();
                  },
                  child: state == 2
                      ? Center(
                          child: SizedBox.fromSize(
                            size: const Size.square(50),
                            child: Stack(
                              children: List.generate(_itemCount, (i) {
                                const position = 50 * .5;
                                return Positioned.fill(
                                  left: position,
                                  top: position,
                                  child: Transform(
                                    transform:
                                        Matrix4.rotationZ(30.0 * i * 0.0174533),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: FadeTransition(
                                        opacity: DelayTween(
                                                begin: 0.0,
                                                end: 1.0,
                                                delay: i / _itemCount)
                                            .animate(_controller),
                                        child: SizedBox.fromSize(
                                            size: const Size.square(40 * 0.15),
                                            child: _itemBuilder(i)),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      : Text(
                          state == 1 ? "Go Offline" : "Go Online",
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
              ));
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    }, listener: (context, state) {
      navItemSelected(state);
    });
  }

  navItemSelected(int index) {
    _pageController.jumpToPage(index);
  }

  Widget _itemBuilder(int index) => const DecoratedBox(
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle));
}

class NavBar extends StatelessWidget {
  final int state;
  const NavBar(this.state, {super.key});
  @override
  Widget build(
    BuildContext context,
  ) {
    var themeHandler = Theme.of(context);
    return NavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      indicatorColor: themeHandler.primaryColor,
      selectedIndex: state,
      onDestinationSelected: (index) {
        context.read<AppMenuCubit>().changeSelectedMenu(index);
      },
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(
            Icons.drive_eta,
            size: 20,
            color: Colors.white,
          ),
          icon: Icon(
            Icons.drive_eta,
            size: 20,
            color: Colors.blue,
          ),
          label: 'Drive',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.attach_money,
            size: 20,
            color: Colors.white,
          ),
          icon: Icon(
            Icons.attach_money,
            size: 20,
            color: Colors.blue,
          ),
          label: 'Earning',
        ),
      ],
    );
  }
}

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class CustomCircularNotchedRectangle extends NotchedShape {
  const CustomCircularNotchedRectangle();
  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    final double notchRadius = guest.width / 2.0;

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset?> p = List<Offset?>.filled(6, null);

    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    p[3] = Offset(-1.0 * p[2]!.dx, p[2]!.dy);
    p[4] = Offset(-1.0 * p[1]!.dx, p[1]!.dy);
    p[5] = Offset(-1.0 * p[0]!.dx, p[0]!.dy);

    for (int i = 0; i < p.length; i += 1) {
      p[i] = p[i]! + guest.center;
    }

    final Path path = Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p[0]!.dx, p[0]!.dy)
      ..quadraticBezierTo(p[1]!.dx, p[1]!.dy, p[2]!.dx, p[2]!.dy);
    if (guest.height == guest.width) {
      path.arcToPoint(
        p[3]!,
        radius: Radius.circular(notchRadius),
        clockwise: false,
      );
    } else {
      path
        ..arcToPoint(
          guest.bottomLeft + Offset(guest.height / 2, 0),
          radius: Radius.circular(guest.height / 2),
          clockwise: false,
        )
        ..lineTo(guest.right - guest.height / 2, guest.bottom)
        ..arcToPoint(
          p[3]!,
          radius: Radius.circular(guest.height / 2),
          clockwise: false,
        );
    }
    path
      ..quadraticBezierTo(p[4]!.dx, p[4]!.dy, p[5]!.dx, p[5]!.dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
    return path;
  }
}
