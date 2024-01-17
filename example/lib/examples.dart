import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onedrive/flutter_onedrive.dart';

class OneDriveButton extends StatefulWidget {
  const OneDriveButton({Key? key}) : super(key: key);

  @override
  OneDriveButtonState createState() => OneDriveButtonState();
}

class OneDriveButtonState extends State<OneDriveButton>
    with WidgetsBindingObserver {
  late TextEditingController redirectController;
  late TextEditingController clientIDController;
  late TextEditingController pathController;
  late OneDrive onedrive;
  List<OneDriveItem>? driveItems;

  @override
  void initState() {
    super.initState();
    redirectController = TextEditingController();
    clientIDController = TextEditingController();
    pathController = TextEditingController(text: "/");
    onedrive = OneDrive(
      redirectURL: redirectController.text,
      clientID: clientIDController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: onedrive.isConnected(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data ?? false) {
          // Has connected
          return Column(
            children: [
              MaterialButton(
                child: const Text("Disconnect"),
                onPressed: () async {
                  // Disconnect
                  await onedrive.disconnect();
                  setState(() {});
                },
              ),
              MaterialButton(
                child: const Text("Test"),
                onPressed: () async {
                  const str = "Hello, World!";
                  var data = Uint8List.fromList(utf8.encode(str));

                  // Upload files
                  var response = await onedrive.push(data, "/test/hello.txt");
                  if (!response.isSuccess) {
                    debugPrint(response.message);
                    return;
                  }

                  // Download files
                  response = await onedrive.pull("/test/hello.txt");
                  if (!response.isSuccess) {
                    debugPrint(response.message);
                    return;
                  }

                  debugPrint(response.body);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextField(
                  controller: pathController,
                  decoration: const InputDecoration(labelText: 'Path'),
                ),
              ),
              MaterialButton(
                child: const Text("GetChildren"),
                onPressed: () async {
                  if (pathController.text.isNotEmpty) {
                    final collectionPage =
                        await onedrive.getChildren(pathController.text);
                    driveItems = collectionPage?.value;
                    if (driveItems != null) {
                      setState(() {});
                    }
                  }
                },
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: driveItems?.length ?? 0,
                  itemBuilder: (context, index) {
                    final driveItem = driveItems![index];
                    return ListTile(
                      leading: Icon(driveItem.folder != null
                          ? Icons.folder_outlined
                          : Icons.text_snippet_outlined),
                      title: Text(driveItem.name),
                      trailing: InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: driveItem.name));
                        },
                        child: const Icon(Icons.copy),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ),
              ),
            ],
          );
        } else {
          // Hasn't connected
          return Column(
            children: [
              TextField(
                controller: redirectController,
                decoration: const InputDecoration(labelText: 'Redirect URL'),
                onChanged: (value) {
                  onedrive = OneDrive(
                    redirectURL: value,
                    clientID: clientIDController.text,
                  );
                },
              ),
              TextField(
                controller: clientIDController,
                decoration: const InputDecoration(labelText: 'Client ID'),
                onChanged: (value) {
                  onedrive = OneDrive(
                    redirectURL: redirectController.text,
                    clientID: value,
                  );
                },
              ),
              MaterialButton(
                child: const Text("Connect"),
                onPressed: () async {
                  bool success = await onedrive.connect(context);
                  if (success) {
                    setState(() {});
                  }
                },
              ),
            ],
          );
        }
      },
    );
  }
}
