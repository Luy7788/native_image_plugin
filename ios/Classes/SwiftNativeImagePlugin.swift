import Flutter
import UIKit
import Kingfisher
import KingfisherWebP

public class SwiftNativeImagePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_image_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeImagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.register(FLNativeImageViewFactory(messenger: registrar.messenger()), withId: "native_image_view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

class FLNativeImageViewFactory: NSObject, FlutterPlatformViewFactory {
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
        return FLNativeImageView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
      return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeImageView: NSObject, FlutterPlatformView {
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
            let path = dic["path"] as? String?
            let url = dic["url"] as? String?
            let data = dic["data"] as? FlutterStandardTypedData?
            let fit = dic["fit"] as? String?
            if let _path = path {
                _imageView.image = UIImage.init(contentsOfFile: _path!)
            } else if let _url = url {
                _imageView.kf.setImage(with: URL(string: _url!))
            } else if let _data = data {
                _imageView.image = UIImage.init(data: _data!.data)
            }
            if let _fit = fit {
                switch _fit {
                    case "cover":
                    _imageView.contentMode = .scaleAspectFill
                    case "fill":
                    _imageView.contentMode = .scaleToFill
                    case "contain":
                    _imageView.contentMode = .scaleAspectFit
                    default: break
                }
            }
        }
    }

    func view() -> UIView {
        return _imageView
    }
    
}
