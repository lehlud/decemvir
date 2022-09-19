import 'package:decemvir/api/struct/data_root.dart';
import 'package:decemvir/api/struct/database.dart';
import 'package:decemvir/api/struct/document.dart';
import 'package:decemvir/ui/database.dart';
import 'package:decemvir/ui/document.dart';
import 'package:decemvir/ui/explorer.dart';
import 'package:decemvir/ui/file_modal.dart';
import 'package:decemvir/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yaru_icons/yaru_icons.dart';

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final root = useFuture(DataRoot.load());
    final selectedElement = useState<dynamic>(null);

    if (root.data == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Datenbank wird geöffnet...'),
            ],
          ),
        ),
      );
    }

    final element = selectedElement.value;
    final useModalDrawer = MediaQuery.of(context).size.width < 700;

    void onSelect(dynamic value) => selectedElement.value = value;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyO, control: true): () {
          showInstantDialog(
            context: context,
            builder: (context) => OpenFileModal(root.data!),
          );
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text('Decemvir')),
          drawer: useModalDrawer
              ? Drawer(
                  child: ElementExplorer(
                    root.data!,
                    onSelect: onSelect,
                    withInDrawer: true,
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!useModalDrawer) ...[
                SizedBox(
                  width: 250,
                  child: ElementExplorer(root.data!, onSelect: onSelect),
                ),
                const VerticalDivider(width: 0),
              ],
              Expanded(
                child: element != null
                    ? (element is Document
                        ? DocumentView(element)
                        : DatabaseView(element))
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
