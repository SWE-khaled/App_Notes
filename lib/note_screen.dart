import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Network/hive_helper.dart';
import 'package:notes/cubit/cubit/note_cubit.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  static const Color backgroundColor = Color(0xFFE0E0E0);
  static const Color titleColor = Colors.black;

  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String? _validateNote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Note cannot be empty';
    }
    return null;
  }

  void _showNoteDialog({
    required String title,
    required String actionText,
    String initialText = '',
    required void Function(String text) onSubmit,
  }) {
    _textController.text = initialText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(title),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _textController,
            validator: _validateNote,
            autofocus: true,
            maxLines: null,
            decoration: const InputDecoration(hintText: 'Write your note...'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                onSubmit(_textController.text.trim());
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(
              actionText,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    _showNoteDialog(
      title: 'Add Note',
      actionText: 'Add',
      onSubmit: (text) => context.read<NoteCubit>().addNote(text),
    );
  }

  void _showUpdateDialog(int index) {
    _showNoteDialog(
      title: 'Update Note',
      actionText: 'Update',
      initialText: HiveHelper.myNotes[index],
      onSubmit: (text) => context.read<NoteCubit>().updateNote(index, text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        final notes = HiveHelper.myNotes;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => context.read<NoteCubit>().clearAllNotes(),
                  child: const Text(
                    "Clear All",
                    style: TextStyle(color: titleColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(fontSize: 48, color: titleColor),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => Stack(
                      children: [
                        InkWell(
                          onTap: () => _showUpdateDialog(index),
                          child: Container(
                            height: 100,
                            width: 380,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 18,
                                right: 15,
                                top: 12,
                              ),
                              child: Center(child: Text(notes[index])),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              context.read<NoteCubit>().deleteNote(index),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: _showAddDialog,
            child: const Icon(Icons.add, color: Colors.black),
          ),
        );
      },
    );
  }
}