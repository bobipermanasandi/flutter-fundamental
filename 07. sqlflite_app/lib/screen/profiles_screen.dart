import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlflite_app/model/profile.dart';
import 'package:sqlflite_app/provider/local_database_provider.dart';
import 'package:sqlflite_app/screen/form_screen.dart';
import 'package:sqlflite_app/static/action_page_enum.dart';
import 'package:sqlflite_app/widgets/profile_card_widget.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({
    super.key,
  });

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<LocalDatabaseProvider>().loadAllProfileValue();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProfileCardWidget(
                profile: Profile(
                  name: "Ilham",
                  email: "ilham@dicoding.com",
                  phoneNumber: "81234567890",
                  maritalStatus: true,
                ),
              ),
              Consumer<LocalDatabaseProvider>(
                builder: (context, value, child) {
                  if (value.profileList == null) {
                    return const SizedBox();
                  }

                  final profileList = value.profileList!;
                  return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: profileList.length,
                    itemBuilder: (context, index) {
                      final profile = profileList[index];
                      return ProfileCardWidget(
                        profile: profile,
                        onTapRemove: () async {
                          if (profile.id != null) {
                            final localDatabaseProvider =
                                context.read<LocalDatabaseProvider>();
                            await localDatabaseProvider
                                .removeProfileValueById(profile.id!);
                            await localDatabaseProvider.loadAllProfileValue();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("This item cannot be deleted"),
                              ),
                            );
                          }
                        },
                        onTapEdit: () {
                          if (profile.id != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormScreen(
                                  actionPageEnum: ActionPageEnum.edit,
                                  profile: profile,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "This item cannot be deleted",
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormScreen(
                actionPageEnum: ActionPageEnum.add,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
