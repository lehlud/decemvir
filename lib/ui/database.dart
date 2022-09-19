import 'package:decemvir/api/struct/database.dart';
import 'package:decemvir/api/struct/type.dart';
import 'package:decemvir/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yaru_icons/yaru_icons.dart';

class DatabaseView extends HookWidget {
  final Database database;
  const DatabaseView(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    final expandProperties = useState(false);

    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      child: ListView(
        children: [
          ListTile(
            title: const Text('Eigenschaften'),
            trailing: IconButton(
              icon: const Icon(YaruIcons.plus),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddPropertyModal(database),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Column(
                children: database.props.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    trailing: Text(dbTypeToString(entry.value.type)),
                    onTap: () {},
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddPropertyModal extends HookWidget {
  final Database database;
  const AddPropertyModal(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    final selectedType = useState<DBType?>(null);
    final nameController = useTextEditingController();

    return AlertDialog(
      title: const Text('Eigenschaft hinzufügen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Bezeichnung',
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton(
            isExpanded: true,
            hint: const Text('Datentyp wählen'),
            value: selectedType.value,
            onChanged: (value) {
              selectedType.value = value;
            },
            items: DBType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(dbTypeToString(type)),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          child: const Text('Hinzufügen'),
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty || selectedType.value == null) {
              return;
            }

            database.addProp(name, Type(type: selectedType.value!));

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
