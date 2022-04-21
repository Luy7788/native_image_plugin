import Flutter
import UIKit
import Kingfisher
import KingfisherWebP

public class SwiftNativeImagePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_image_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeImagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
      return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _imageView: UIImageView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _imageView = UIImageView.init(frame: frame)
        super.init()
        // iOS views can be created here
        if args != nil && args is Dictionary<String, Any> {
            let dic: Dictionary<String,Any> = args as! Dictionary<String, Any>
            let path = dic["path"] as! String?
            let url = dic["url"] as! String?
            let data = dic["data"] as! Data?
            if let _path = path && _path.count > 0 {
                _imageView.image = UIImage.init(contentsOfFile: _path)
            }
            if let _url = url && _url.count > 0 {
                _imageView.kf.setImage(with: URL(string: _url))
            }
            if let _data = data {
                _imageView.image = UIImage.init(data: _data)
            }
        }
    }

    func view() -> UIView {
        return _imageView
    }
    
}
