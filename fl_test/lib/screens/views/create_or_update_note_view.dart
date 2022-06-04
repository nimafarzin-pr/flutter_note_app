import 'package:fl_test/services/auth/auth_service.dart';
import 'package:fl_test/services/crud/notes_service.dart';
import 'package:fl_test/utils/generics/get_argument.dart';
import 'package:flutter/material.dart';

class CreateOrUpdateNoteView extends StatefulWidget {
  const CreateOrUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateOrUpdateNoteView> createState() => _CreateOrUpdateNoteViewState();
}

class _CreateOrUpdateNoteViewState extends State<CreateOrUpdateNoteView> {
  DataBaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textEditingController;

  Future<DataBaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DataBaseNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }
    final exsitingNote = _note;
    if (exsitingNote != null) {
      return exsitingNote;
    }
    final currentUser = AuthService.fireBase().currentUser!;
    final email = currentUser.email;
    final owner = await _noteService.getUser(email: email);
    final newNote = await _noteService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    final text = _textEditingController.text;

    if (note != null && text.isEmpty) {
      _noteService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;

    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(note: note, text: text);
    }
  }

  void _textControllerListener() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note == null) {
      return;
    }
    await _noteService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _noteService = NoteService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your note'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textEditingController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintText: 'Strart typing your note here...'),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
