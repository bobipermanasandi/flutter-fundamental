import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preference/model/setting.dart';
import 'package:shared_preference/provider/notification_provider.dart';
import 'package:shared_preference/provider/setting_provider.dart';
import 'package:shared_preference/utils/notification_state.dart';
import 'package:shared_preference/utils/page_size_number.dart';
import 'package:shared_preference/widgets/maximum_page_size_field.dart';
import 'package:shared_preference/widgets/notification_field.dart';
import 'package:shared_preference/widgets/save_button.dart';
import 'package:shared_preference/widgets/signature_field.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    super.key,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final maximumPageSizeController = TextEditingController();
  final signatureController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final notificationStateProvider = context.read<NotificationStateProvider>();
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();

    Future.microtask(() async {
      sharedPreferencesProvider.getSettingValue();
      final setting = sharedPreferencesProvider.setting;

      if (setting != null) {
        maximumPageSizeController.text = setting.pageNumber.toString();
        signatureController.text = setting.signature;
        notificationStateProvider.notificationState = setting.notificationEnable
            ? NotificationState.enable
            : NotificationState.disable;
      }
    });
  }

  @override
  void dispose() {
    maximumPageSizeController.dispose();
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Setting Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const NotificationField(),
              MaximumPageSizeField(
                controller: maximumPageSizeController,
              ),
              SignatureField(
                controller: signatureController,
              ),
              SaveButton(
                onPressed: () => saveAction(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveAction() async {
    final notificationState =
        context.read<NotificationStateProvider>().notificationState;
    final isNotificationEnable = notificationState.isEnable;
    final maximumPageSize = int.tryParse(maximumPageSizeController.text) ??
        maximumPageSizeNumbers.first;
    final signature = signatureController.text;
    final Setting setting = Setting(
      notificationEnable: isNotificationEnable,
      pageNumber: maximumPageSize,
      signature: signature,
    );

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();
    await sharedPreferencesProvider.saveSettingValue(setting);

    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(sharedPreferencesProvider.message),
    ));
  }
}
