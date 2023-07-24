# tbib_file_uploader

This package for upload file you can display notifications and progress notification and can receive upload bytes and total bytes

<h4> Note this package use awesome notification</h4>

- Can display progress in your app
  
<img  src="https://github.com/the-best-is-best/tbib_file_uploader/blob/main/github_assets/screen1.png?raw=true" height="300"></img>

<img  src="https://github.com/the-best-is-best/tbib_file_uploader/blob/main/github_assets/screen2.png?raw=true" height="300"></img>

- Notification with progress bar
  
<img  src="https://github.com/the-best-is-best/tbib_file_uploader/blob/main/github_assets/screen3.png?raw=true" height="300"></img>

- Notification downloaded ended

<img  src="https://github.com/the-best-is-best/tbib_file_uploader/blob/main/github_assets/screen4.png?raw=true" height="300"></img>

- ios configuration

<h3> step 1 </h3>

```swift
 Change
  BUILD_LIBRARY_FOR_DISTRIBUTION = NO 
 to 
 BUILD_LIBRARY_FOR_DISTRIBUTION = NO  
 ```

<h3 style="display:inline-block;">Note: </h3> <h4 style="display:inline-block;;"> Notification progress bar not support in ios.</h4>

- How to use

<h3> step 1 </h3>

- init package in main

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TBIBFileUploader().init();
  ....
}
```

<h3>if you want to download file can use <a href="https://pub.dev/packages/tbib_downloader"> tbib downloader </a></h3>
