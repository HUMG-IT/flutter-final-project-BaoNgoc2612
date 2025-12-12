import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // EmployeeProvider không thể thêm ở đây vì cần userId từ AuthProvider
        // Nó sẽ được tạo trong EmployeeListScreen
      ],
      child: MaterialApp(
        title: 'HR Management',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {'/register': (context) => const RegisterScreen()},
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            // TODO: Check auth state → HomeScreen or LoginScreen
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
