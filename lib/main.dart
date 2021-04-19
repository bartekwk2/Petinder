import 'package:Petinder/fcm.dart';
import 'package:Petinder/navigation/router.dart';
import 'package:Petinder/repository/location_repository.dart';
import 'package:Petinder/repository/loginStatus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'di/injection_container.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var documentDirectory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: documentDirectory,
  );
  Hive.init(documentDirectory.path);
  await init();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AppRouter _appRouter = inject<AppRouter>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    var myID = Hive.box("IsLogin").get("id");
    print(myID);
    if (myID.isNotEmpty) {
      if (state == AppLifecycleState.inactive) {
        Future.delayed(Duration.zero, () async {
          LoginStatus.changeStatus(false, id: myID)
              .then((value) => print(value));
        });
      } else if (state == AppLifecycleState.resumed) {
        Future.delayed(Duration.zero, () async {
          LoginStatus.changeStatus(true, id: myID)
              .then((value) => print(value));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Hive.openBox(
          'Location',
          compactionStrategy: (int total, int deleted) {
            return deleted > 20;
          },
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            LocationRepository()
              ..determinePosition().then((value) => print(value));
          }
          return FirebaseMyMessages(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              onGenerateRoute: _appRouter.generateRoute,
            ),
          );
        });
  }

  @override
  void dispose() {
    Hive.box('Location').compact();
    Hive.close();
    WidgetsBinding.instance.removeObserver(this);
    _appRouter.dispose();
    super.dispose();
  }
}
