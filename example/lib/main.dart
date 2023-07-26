import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:example/src/api_model.dart';
import 'package:example/theme.dart';
import 'package:flutter/material.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TBIBFileUploader().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool hide = false;
  File? selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FormFieldState<Map<String, dynamic>?>? _formFieldState;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatefulBuilder(
                  // Listen to changes in the ValueNotifier

                  builder: (_, setState) => Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.blueAccent,
                            width: _formFieldState?.value != null &&
                                    _formFieldState!.value!['isHide'] == true
                                ? 0
                                : 1),
                        borderRadius: BorderRadius.circular(30)),
                    child: TBIBUploaderFormField(
                      state: ({required state}) {
                        _formFieldState = state;
                      },
                      maxFileSize: 5,

                      validator: _formFieldState == null ||
                              _formFieldState?.value != null &&
                                  _formFieldState!.value!['isHide'] == true
                          ? null
                          : (value) {
                              if (selectedFile == null) {
                                return 'Please select file';
                              }

                              return null;
                            },
                      selectedFile: ({name, path}) {
                        if (path != null) {
                          selectedFile = File(path);
                        } else {
                          selectedFile = null;
                        }
                        setState(() {});
                      },
                      style: const TBIBUploaderStyle(
                          labelText: 'Please select file'),
                      showFileName: true,
                      imageQuality: 50,
                      canDownloadFile: true,
                      hide: true,
                      // hideBorder: true,
                      //changeFileNameTo: 'doc_1',
                      allowedExtensions: const [
                        'png',
                        'jpg',
                        'pdf',
                        'xls',
                        'xlsx',
                      ],

                      displayNote:
                          "Note: File size should be less than 5 MB and can select image png , jpg and pdf",

                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: TextEditingController(),
                          validator: _formFieldState == null ||
                                  _formFieldState?.value == "hide"
                              ? null
                              : (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: TextEditingController(),
                            validator: _formFieldState == null ||
                                    _formFieldState?.value == "hide"
                                ? null
                                : (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter name';
                                    }
                                    return null;
                                  },
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState?.reset();

                      await TBIBUploaderFormField.hideOrShowWidget(
                          _formFieldState!);
                      setState(() {});
                    },
                    child: const Text('Hide')),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () async {
                        log("form valid ${_formKey.currentState!.validate().toString()} - ${_formFieldState?.value}");
                        var valid = TBIBUploaderFormField.validation(
                            [_formFieldState!]);
                        if (valid) {
                          if (_formKey.currentState!.validate()) {
                            if (_formFieldState?.value != null &&
                                _formFieldState!.value!['isHide'] == true) {
                              return;
                            }

                            Map<String, dynamic> dataApi =
                                await TBIBFileUploader()
                                    .startUploadFileWithResponse(
                              dio: Dio(
                                BaseOptions(
                                  baseUrl: 'https://api.escuelajs.co/api/v1/',
                                ),
                              ),
                              pathApi: 'files/upload',
                              method: 'POST',
                              yourData: FormData.fromMap(
                                {
                                  'file': MultipartFile.fromFileSync(
                                    selectedFile!.path,
                                    filename: selectedFile!.path
                                        .split(Platform.pathSeparator)
                                        .last,
                                  ),
                                },
                              ),
                            );
                            var res = ApiModel.fromMap(dataApi);
                            log(res.toJson());
                          }
                        }
                      },
                      child: const Text('Submit')),
                )
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
