# KiTPlayer SDK for iOS

## 시작하기
이 문서는 KiTPlayerSDK 사용하기 위한 기본적인 방법을 안내합니다.

### 요구사항
- iOS 14.0 이상

## 설치
KiTPlayerSDK를 SPM(Swift Package Manager)을 통해 설치할 수 있습니다.

### Swift Package Manager 설정
Xcode에서 프로젝트를 열고 File > Swift Packages > Add Package Dependency… 메뉴를 선택합니다.

아래 주소를 입력 후 `Add Package` 버튼을 눌러서 프로젝트에 추가합니다.
```text
https://github.com/muzlive-info/muzlive-kit-player-sdk-ios
```

[repository](https://github.com/muzlive-info/muzlive-kit-player-sdk-ios)

## 프로젝트 설정

### 1. 앱 프라이버시 설정

KiTPlayer SDK를 사용하기 위해서는 다음의 권한이 필요합니다.

- `Privacy - Microphone Usage Description`
- `Privacy - Local Network Usage Description`
- `Privacy - Camera Usage Description`
- `Privacy - Bluetooth Always Usage Description`

`Info.plist` 파일에 아래 항목을 추가하세요:

```xml title="마이크 권한"
<key>NSMicrophoneUsageDescription</key>
<string>키트 인식을 위해 마이크 권한이 필요합니다.</string>
```

```xml title="카메라 권한"
<key>NSCameraUsageDescription</key>
<string>QR코드 인식을 위해 카메라 권한이 필요합니다.</string>
```

```xml title="로컬 네트워크 권한"
<key>NSLocalNetworkUsageDescription</key>
<string>크롬캐스트 동작을 위해 로컬 네트워크 권한이 필요합니다.</string>
```

```xml title="블루투스 권한"
<key>NSBluetoothAlwaysUsageDescription</key>
<string>크롬캐스트 동작을 위해 블루투스 권한이 필요합니다.</string>
```

## SDK 사용하기

### 1. 초기화

KiTPlayer SDK를 사용하기 위해서는 앱이 시작될 때 SDK를 초기화해야 합니다.  
이 작업은 `AppDelegate`의 `application(_:didFinishLaunchingWithOptions:)` 메서드에서 수행됩니다.

```swift
import Foundation
import UIKit
import KiTPlayerSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let clientId = "YOUR_KITPLAYER_CLIENT_ID"
        let secretKey = "YOUT_KITPLAYER_SECRET_KEY"
        KiTPlayer.initialize(with: clientId, secretKey)
        return true
    }
}
```

> 🚨 주의  
> `SECRET_KEY`는 앱의 보안을 위해 외부에 노출되지 않도록 주의해야 합니다. 따라서, `SECRET_KEY`는 소스코드에 직접 입력하지 않고, 별도의 파일에 저장하여 사용하는 것이 좋습니다.

### 2. 플레이어 실행

`ViewController`에서 버튼을 통해 `start()` 메서드를 호출하여 플레이어를 실행할 수 있습니다. 예시는 다음과 같습니다:

=== "Circular Layout"
    ```swift
    import KiTPlayer

    class ViewController: UIViewController {
        @IBAction func playButtonTapped(_ sender: UIButton) {
            KiTPlayer.shared.start()
        }
    }
    ```
=== "Embeded Layout"
    ```swift
    import KiTPlayer

    class ViewController: UIViewController {
        @IBAction func playButtonTapped(_ sender: UIButton) {
            KiTPlayer.shared.start(with: .embeded)
        }
    }
    ```

### 3. 에러 확인

SDK 사용 중 발생할 수 있는 에러를 처리하기 위해 delegate를 등록할 수 있습니다.

```swift
import KiTPlayer

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        KiTPlayer.shared.addListenerDelegate(self)
    }
}

extension ViewController: KiTPlayerListenerDelegate {
    func didOccurError(_ errorCode: KiTPlayerSDK.KiTPlayerErrorCode) {
        print(errorCode)
    }
}
```
