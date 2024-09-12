# FullScreen Support

## FullScreen 지원
```swift
// AppDelegate

func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    if let interfaceOrientationMask = KiTplayer.shared.handleFullScreen(window) {
        return interfaceOrientationMask
    }
    return .portrait // 기본 앱이 지원하는 방향
}
```
