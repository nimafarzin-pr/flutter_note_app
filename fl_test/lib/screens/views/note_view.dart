import 'package:fl_test/constant/consts.dart';
import 'package:fl_test/enums/menu_actions.dart';
import 'package:fl_test/screens/views/nots_list_views.dart';
import 'package:fl_test/services/auth/auth_service.dart';
import 'package:fl_test/services/crud/notes_service.dart';
import 'package:fl_test/utils/dialog/logout_dialog.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NoteService _noteService;
  String get email => AuthService.fireBase().currentUser!.email;

  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteViewRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogoutDialog(
                    context,
                  );
                  if (shouldLogOut) {
                    await AuthService.fireBase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('logOut'),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: _noteService.getOrCreateUser(email: email),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _noteService.allNotes,
                    builder: (context, snapShot) {
                      switch (snapShot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapShot.hasData) {
                            final allNotes =
                                snapShot.data as List<DataBaseNote>;
                            print(allNotes);
                            return NoteListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _noteService.deleteNote(id: note.id);
                              },
                              onTap: (note) {
                                Navigator.of(context).pushNamed(
                                    createOrUpdateNoteViewRoute,
                                    arguments: note);
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
