import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:totp_new_version/injector.dart' as psjector;
import 'package:totp_new_version/password_manager/src/presentation/blocs/add_password_bloc/add_password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/retrieve_icon_bloc/retrieve_icon_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/search_password_bloc/search_password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_bloc.dart';

import 'config/routes/app_routes.dart';
import 'config/themes/app_themes.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await psjector.initializeDependencies();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => psjector.injector<PasswordBloc>()
        ),
        BlocProvider(
            create: (_) => psjector.injector<AddPasswordBloc>()
        ),
        BlocProvider(
            create: (_) => psjector.injector<SearchPasswordBloc>()
        ),
        BlocProvider(
            create: (_) => psjector.injector<RetrieveIconBloc>()
        ),
        BlocProvider(
            create: (_) => psjector.injector<AddPinBloc>()
        ),
        BlocProvider(
            create: (_) => psjector.injector<CheckPinBloc>()
        ),
        BlocProvider(
            create: (_) => psjector.injector<VerifyPinBloc>()
        ),
        BlocProvider(
            create: (_) => psjector.injector<ShowPasswordBloc>()
        ),
      ],
      child: MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password manager',
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
    );
  }
}

