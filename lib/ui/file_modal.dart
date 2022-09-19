import 'package:decemvir/api/struct/data_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@immutable
class _FileElement {
  final dynamic element;
  final String name;

  const _FileElement(this.element, this.name);
}

class OpenFileModal extends HookWidget {
  final DataRoot root;
  final void Function(dynamic)? onSelect;
  const OpenFileModal(this.root, {super.key, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final queryController = useTextEditingController();
    final queryText = useState<String>('');
    useEffect(() {
      listener() => queryText.value = queryController.text.trim();
      queryController.addListener(listener);
      return () => queryController.removeListener(listener);
    }, const []);

    final elements = useMemoized(() {
      final q = queryText.value.toLowerCase();
      return root.allDatabases.where((db) {
        return db.name.toLowerCase().contains(q);
      }).map((db) {
        return _FileElement(db, db.name);
      }).toList();
    }, [queryText.value]);

    return AlertDialog(
      title: const Text('Element öffnen'),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              controller: queryController,
              decoration: const InputDecoration(labelText: 'Suchen...'),
            ),
            SizedBox(
              height: 400,
              width: double.maxFinite,
              child: ListView.separated(
                itemCount: elements.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(elements[index].name),
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
