import UIKit
import Flutter

public struct JStoreUser: Codable {
    let title: String
    let message: String
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
 
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let vc = self.window.rootViewController as? FlutterViewController

    // let flutterEngine = (vc?.engine!)!

    let batteryChannel = FlutterMethodChannel(name: "kraken_js_dart_native_channel",
                                              binaryMessenger: vc!.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
              case "alert":
                let args = (call.arguments as? Array<AnyObject>)!
                // let callId = args[0] as? String
                let param: AnyObject = args[1]
                let title = param["title"] as? String ?? "提示"
                let message = param["message"]  as? String ?? ""
                let cancelButtonTitle = param["cancelButtonTitle"] as? String ?? "取消"
                let okButtonTitle = param["okButtonTitle"] as? String ?? "确定"
                let contextId = param["contextId"] as? String ?? ""
                let alertController = UIAlertController(title: title,
                                                        message: message , preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
                    action in
                    print("点击了取消")
                    result("{\"method\": \""+call.method+"\"} from swift 取消")
                })

                let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: {
                    action in
                    print("点击了确定")
                    result("{\"method\": \""+call.method+"\"} from swift 确定")
                })

                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    vc?.present(alertController, animated: true, completion: nil)
                }
                batteryChannel.invokeMethod("broadcast",  arguments: "{\"method\": \""+call.method+"\", \"contextId\": \""+contextId+"\", \"msg\": \"broadcast from native\"}")
            default:
                result("{\"method\": \""+call.method+"\"} from swift 未找到")
        }
        
    })

    // // 初始化 Kraken 插件
    // let kraken = Kraken.init(flutterEngine: flutterEngine)

    // // 注册一个处理 JS 调用的回调函数
    // kraken.registerMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) in
    //   // 调用 JS 的函数
    //   result("method: " + call.method)
    // })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
