import UIKit
import Flutter
import Firebase
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          let token = deviceToken.map{String(format: "%02.2hhx", $0)}.joined()
          print("pushTokenFCM_ios ",token)
          Messaging.messaging().apnsToken = deviceToken
          
          super.application(application,
                            didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
      }
}
