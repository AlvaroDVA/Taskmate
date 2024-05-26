import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_config.dart';
import '../../../services/service_locator.dart';
import '../../../states/auth_state.dart';

class ErrorBox extends StatelessWidget {
  const ErrorBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = ServiceLocator.appConfig;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ChangeNotifierProvider<AuthState>(
        create: (_) => ServiceLocator.authState,
        child: Consumer<AuthState>(
          builder: (context, authState, _) {
            if (authState.errorMessage != null) {
              return Text(
                authState.errorMessage!,
                style: TextStyle(color: appConfig.theme.errorColor),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}