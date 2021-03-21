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

- Run `amplify configure` and enter your access key.
- Set the iOS deployment target to 13.0 in the Podfile and add:
  `target.build_configurations.each do |config|
  config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  end`
- Add dependencies to pubspec.yaml:
    - `amplify_flutter: '<1.0.0'`
    - `amplify_auth_cognito: '<1.0.0'`
    - `amplify_analytics_pinpoint: '<1.0.0'`
    - `amplify_datastore: '<1.0.0'`
- Run `amplify init`
- Initialize Amplify in the application using the provided code fragment from the
[docs](https://docs.amplify.aws/lib/project-setup/create-application/q/platform/flutter#n3-provision-the-backend-with-amplify-cli)
  and add all necessary plugins
  
### Add Authentication

Run `amplify add auth` and allow guest access.

### Add DataStore

- Run `amplify add api` and select GraphQL.
- Adjust the GraphQL schema in schema.graphql
- Generate code from the schema with `amplify codegen models`

### Implement frontend

(Compare to implementation in [home_page.dart](lib/home_page.dart))
