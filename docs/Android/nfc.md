# __NFC 기능__

KiT Player SDK는 NFC 태그를 통해 앨범 또는 음악을 바로 재생하는 기능을 지원합니다.
앱에서 NFC 태그를 감지하면 태그 데이터를 SDK에 전달하고, SDK가 해당 컨텐츠를 자동으로 실행합니다.

## __동작 흐름__

```
NFC 태그 감지 (앱)
    ↓
NFCStaticVariable.emitNfcEvent(tagData)
    ↓
NFCStaticVariable.setDynamicLinkCollector 콜백 실행
    ↓
KitInitializer.startWithDynamicLink(dynamicLink = tagData)
```

## __설정하기__

### 1. NFC 태그 데이터 발행

앱에서 NFC 태그를 감지했을 때 `emitNfcEvent()`로 태그 데이터를 SDK에 전달합니다.
`emitNfcEvent()`는 suspend 함수이므로 코루틴 내에서 호출해야 합니다.

```kotlin
// NFC 태그를 감지하는 Activity

override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)

    val tagData = intent.getStringExtra("nfc_data") ?: return

    lifecycleScope.launch {
        NFCStaticVariable.emitNfcEvent(tagData)
    }
}
```

### 2. 태그 데이터 수신 및 SDK 실행

`setDynamicLinkCollector()`를 통해 NFC 이벤트를 구독하고, SDK를 실행합니다.
SDK가 이미 실행 중인 경우에는 콜백이 호출되지 않습니다.

`setDynamicLinkCollector()`는 suspend 함수이며 Flow를 구독하는 방식으로 동작합니다.
Activity의 `lifecycleScope`에서 실행하는 것을 권장합니다.

```kotlin
// SampleActivity.kt

override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    lifecycleScope.launch {
        NFCStaticVariable.setDynamicLinkCollector { dynamicLink ->
            KitInitializer.startWithDynamicLink(
                activity = this@SampleActivity,
                userId = "user-id",
                sdkType = SDKType.MODAL,
                dynamicLink = dynamicLink
            )
        }
    }
}
```

!!! note
    `setDynamicLinkCollector()`는 내부적으로 `StateFlow`를 구독합니다.
    Activity가 종료되면 `lifecycleScope`가 함께 취소되므로 별도 해제 처리가 필요하지 않습니다.

## __API 레퍼런스__

### emitNfcEvent()

NFC 태그 데이터를 SDK에 전달합니다.

```kotlin
suspend fun emitNfcEvent(data: String)
```

| 파라미터 | 타입 | 설명 |
|---------|------|------|
| `data` | `String` | NFC 태그로부터 읽은 데이터 |

### setDynamicLinkCollector()

NFC 태그 이벤트를 구독합니다. SDK가 실행 중이지 않을 때만 콜백이 호출됩니다.

```kotlin
suspend fun setDynamicLinkCollector(action: (String) -> Unit)
```

| 파라미터 | 타입 | 설명 |
|---------|------|------|
| `action` | `(String) -> Unit` | 태그 데이터를 전달받아 실행할 코드 블록 |

### clearReplayEvent()

저장된 NFC 이벤트를 초기화합니다.

```kotlin
fun clearReplayEvent()
```
