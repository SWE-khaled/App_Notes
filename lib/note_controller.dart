import 'package:flutter/foundation.dart';
import 'package:notes/note_model.dart';
import 'package:notes/Network/hive_helper.dart';

class NotesController extends ChangeNotifier {
  final List<NoteModel> _notes = [];

  List<NoteModel> get notes => List.unmodifiable(_notes);

  String? validateNote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "You should add any content";
    }

    return null;
  }
  // when exit app and open again show old notes
  Future<void> loadNotes() async {
    await HiveHelper.getNotes();

    _notes.clear();

    for (final note in HiveHelper.myNotes) {
      _notes.add(NoteModel(content: note));
    }

    notifyListeners();
  }

  Future<void> addNote(String content) async {
    if (validateNote(content) != null) return;

    final note = content.trim();

    await HiveHelper.addNote(note);

    _notes.add(NoteModel(content: note));

    notifyListeners();
  }

  Future<void> updateNote(int index, String content) async {
  if (validateNote(content) != null) return;

  final note = content.trim();

  await HiveHelper.updateNote(index, note);

  _notes[index] = _notes[index].copyWith(
    content: note,
  );

  notifyListeners();
}

  Future<void> deleteNote(int index) async {
  await HiveHelper.deleteNote(index);

  _notes.removeAt(index);

  notifyListeners();
}

Future<void> clearAll() async {
  await HiveHelper.deleteAllNotes();

  _notes.clear();

  notifyListeners();
}
}
