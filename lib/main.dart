import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sap/provider/action.dart';
import 'package:sap/provider/app.dart';
import 'package:sap/provider/client.dart';
import 'package:sap/provider/invoice.dart';
import 'package:sap/provider/monitoring.dart';
import 'package:sap/provider/ship.dart';
import 'package:sap/provider/shipment.dart';
import 'provider/agent.dart';
import 'provider/clearance.dart';
import 'provider/notification.dart';
import 'provider/part.dart';
import 'provider/user.dart';
import 'screen/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCm5WGc257CJ65kle2ONsBkHWnLL9MmxxY",
      authDomain: "sap-app-45a75.firebaseapp.com",
      databaseURL: "https://sap-app-45a75-default-rtdb.firebaseio.com",
      projectId: "sap-app-45a75",
      storageBucket: "sap-app-45a75.appspot.com",
      messagingSenderId: "1078070960455",
      appId: "1:1078070960455:web:08af15623b4af06399ec62",
      measurementId: "G-KCWXXG3Y9X",
    ),
  );

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<AgentProvider>(
          create: (context) => AgentProvider(),
        ),
        ChangeNotifierProvider<ClearanceProvider>(
          create: (context) => ClearanceProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider<PartProvider>(
          create: (context) => PartProvider(),
        ),
        ChangeNotifierProvider<ClientProvider>(
          create: (context) => ClientProvider(),
        ),
        ChangeNotifierProvider<InvoiceProvider>(
          create: (context) => InvoiceProvider(),
        ),
        ChangeNotifierProvider<ActionProvider>(
          create: (context) => ActionProvider(),
        ),
        ChangeNotifierProvider<ShipmentProvider>(
          create: (context) => ShipmentProvider(),
        ),
        ChangeNotifierProvider<ShipProvider>(
          create: (context) => ShipProvider(),
        ),
        ChangeNotifierProvider<AppProvider>(
          create: (context) => AppProvider(),
        ),
        ChangeNotifierProvider<MonitoringProvider>(
          create: (context) => MonitoringProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sap',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: const Color(0xFF212121),
          iconTheme: IconThemeData(color: Colors.grey),
          dividerColor: Colors.black12,
        ),
        theme: ThemeData(
          primaryColor: Colors.black,
          primarySwatch: Colors.grey,
          brightness: Brightness.dark,
        ),
        home: SplashView(),
      ),
    ),
  );
}
