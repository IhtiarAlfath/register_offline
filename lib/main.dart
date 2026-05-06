import 'package:flutter/material.dart';
import 'package:register_offline/core/dependency_injection/injection_container.dart'
    as di;
import 'package:register_offline/core/router/app_router.dart';
import 'package:register_offline/core/utils/app_theme.dart';
import 'package:register_offline/core/utils/connectivity_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Register Offline',
      theme: AppTheme.theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ConnectivityWidget(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
