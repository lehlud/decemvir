import 'package:decemvir/api/struct/data_root.dart';
import 'package:decemvir/api/struct/database.dart';
import 'package:decemvir/api/struct/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yaru_icons/yaru_icons.dart';

class ElementExplorer extends StatelessWidget {
  final DataRoot root;
  final bool withInDrawer;
  final Function(Database)? onSelect;

  const ElementExplorer(
    this.root, {
    super.key,
    this.onSelect,
    this.withInDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Explorer', style: TextStyle(fontSize: 17)),
          trailing: Tooltip(
            message: 'Neue Datenbank',
            child: IconButton(
              icon: const Icon(YaruIcons.document_open),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CreateDatabaseDialog(
                    parent: root,
                  ),
                );
              },
            ),
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: ListView(
            children: root.directDatabases.map((db) {
              return ListTile(
                title: Text(db.name),
                onTap: () {
                  if (withInDrawer) Navigator.pop(context);
                  onSelect?.call(db);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class CreateDatabaseDialog extends HookWidget {
  final dynamic parent;
  const CreateDatabaseDialog({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    assert(parent is DataRoot || parent is Document);

    final nameController = useTextEditingController();

    void createDatabase() {
      final name = nameController.text.trim();
      if (name.isEmpty) return;

      if (parent is DataRoot) {
        (parent as DataRoot).createDatabase(name);
      }

      Navigator.pop(context);
    }

    return AlertDialog(
      title: const Text('Datenbank erstellen'),
      content: TextField(
        autofocus: true,
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Bezeichnung',
        ),
        onSubmitted: (_) => createDatabase(),
      ),
      actions: [
        OutlinedButton(
          onPressed: createDatabase,
          child: const Text('Erstellen'),
        ),
      ],
    );
  }
}
