# Flutter Amplify Demo

Small Flutter chat app demo with AWS Amplify integration.

## How to build it from scratch within a few minutes

### Prerequisites

- [Flutter](https://flutter.dev)
- [Amplify](https://docs.amplify.aws/start/q/integration/flutter)
together with an [AWS account](https://console.aws.amazon.com)

### Create a new Flutter project

Either use the IntelliJ IDEA, Android Studio or simply `flutter create flutter_amplify_demo`
in order to create the Flutter project.

### Initialize Amplify

- Run `amplify configure` and enter your access key
- Set the Android minSdkVersion to 21 in your [app/build.gradle](android/app/build.gradle) file
- Set the iOS deployment target to 13.0 in the [Podfile](ios/Podfile) and add:
```
  target.build_configurations.each do |config|
    config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  end
```
- Add dependencies to pubspec.yaml:
```
  amplify_flutter: '<1.0.0'
  amplify_auth_cognito: '<1.0.0'
  amplify_api: '<1.0.0'
  amplify_analytics_pinpoint: '<1.0.0'
  amplify_datastore: '<1.0.0'
  amplify_storage_s3: '<1.0.0'
```
- Run `amplify init`
- Initialize Amplify in the application using the provided code fragment from the
[docs](https://docs.amplify.aws/lib/project-setup/create-application/q/platform/flutter#n3-provision-the-backend-with-amplify-cli)
  and add all necessary plugins
```
Amplify.addPlugins([
  AmplifyAuthCognito(),
  AmplifyAPI(),
  AmplifyAnalyticsPinpoint(),
  AmplifyDataStore(modelProvider: ModelProvider.instance),
  AmplifyStorageS3(),
]);
```
  
### Add Authentication

Run `amplify add auth` and allow guest access (Manual configuration).

### Add DataStore

- Run `amplify add api` and select GraphQL
- Adjust the GraphQL schema in [schema.graphql](amplify/backend/api/flutteramplifydemo/schema.graphql)
- Generate code from the schema with `amplify codegen models`

### Add Storage

- Run `amplify add storage`
    - Content (Images, audio, video, etc.)
    - Auth and guest users
    - create/update, read & delete (for Auth and Guest users)
    - Lambda Trigger? No

### Add Analytics
- Run `amplify add analytics` and select Amazon Pinpoint.

### Push backend to cloud

Run `amplify push` in order to push your changes to the cloud.

### Implement frontend

(Compare to implementation in [home_page.dart](lib/pages/home_page.dart))
