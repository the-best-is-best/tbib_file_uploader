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

<p> add this in Info.plist </p>

```

     <key>NSCameraUsageDescription</key>
    <string>This app needs access to your camera to allow you to take a photo to use as your profile picture.</string>

    <key>NSMicrophoneUsageDescription</key>
    <string>This app needs access to your microphone to allow you to record a video to use as your profile picture.</string>

```

<p> solve pod install </p>

```

post_install do |installer|
  installer.pods_project.targets.each do |target|
      flutter_additional_ios_build_settings(target)

      target.build_configurations.each do |config|
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
          '$(inherited)',

                    ## dart: PermissionGroup.notification
                    'PERMISSION_NOTIFICATIONS=1',

            ]
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'NO'


    end
  end
end

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

<h3> Note </h3>
<p> you can use this function to pick file or image without widget  </p>

```dart
selectFileOrImage(
          context: context,
          selectedFile: ({String? name, String? path}) {
            log('selectedFile: $name , $path');
          },
          selectFile: false,
          selectImageCamera: true,
          selectImageGallery: true);

```
