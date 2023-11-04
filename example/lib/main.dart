import 'dart:developer';
import 'dart:io';

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
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool hide = false;
  File? selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        child: Padding(
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
                  Column(
                    children: [
                      Builder(builder: (context) {
                        bool isHide = false;
                        return StatefulBuilder(
                          // Listen to changes in the ValueNotifier

                          builder: (_, builderSetState) => Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text('Show or hide widget'),
                                  Switch.adaptive(
                                      value: !isHide,
                                      onChanged: (v) {
                                        builderSetState(() {
                                          isHide = !isHide;
                                        });
                                      }),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blueAccent,
                                        width: isHide ? 0 : 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: TBIBUploaderFile(
                                  isHide: isHide,
                                  validator: (p0) {
                                    if (selectedFile == null) {
                                      return 'Please select file';
                                    }
                                    return null;
                                  },
                                  allowedExtensions: const [
                                    // FileExtensions.DOCX,
                                    // FileExtensions.PDF,
                                    FileExtensions.JPG,
                                    // FileExtensions.PNG
                                  ],
                                  maxFileSize: 2,
                                  fileType: FileType.image,
                                  // displayNote: '',
                                  // selectImageGallery: false,
                                  // selectImageCamera: false,
                                  selectedFile: ({name, path}) {
                                    if (path == null) return;
                                    log('selectedFile $name $path');
                                    selectedFile = File(path[0]!);
                                  },
                                  children: [
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // ElevatedButton(
                              //     onPressed: () async {
                              //       builderSetState(() {
                              //         isHide = !isHide;
                              //       });
                              //     },
                              //     child: const Text('Hide')),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Builder(builder: (context) {
                        bool isHide = false;
                        return StatefulBuilder(
                          // Listen to changes in the ValueNotifier

                          builder: (_, builderSetState) => Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text('Show or hide widget'),
                                  Switch.adaptive(
                                      value: !isHide,
                                      onChanged: (v) {
                                        builderSetState(() {
                                          isHide = !isHide;
                                        });
                                      }),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blueAccent,
                                        width: isHide ? 0 : 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: TBIBUploaderFile(
                                  isHide: isHide,
                                  allowedExtensions: const [
                                    FileExtensions.XLS,
                                    FileExtensions.XLSX,
                                    FileExtensions.JPEG,
                                  ],
                                  selectedFile: ({name, path}) {},
                                  maxFileSize: 12,
                                  style: const TBIBUploaderStyle(
                                      labelText: 'Please select file 1'),
                                  children: [
                                    TextFormField(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // ElevatedButton(
                              //     onPressed: () async {
                              //       builderSetState(() {
                              //         isHide = !isHide;
                              //       });
                              //     },
                              //     child: const Text('Hide')),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (selectedFile == null) return;
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
                        },
                        child: const Text('Submit')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectFileOrImage(
          context: context,
          selectedFile: ({String? name, String? path}) {
            log('selectedFile: $name , $path');
          },
          selectFile: false,
          selectImageCamera: true,
          selectImageGallery: true);
    });
  }
}
