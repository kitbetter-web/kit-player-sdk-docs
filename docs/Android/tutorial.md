# __Android 튜토리얼__

## __설치 조건__

- Android 7.0 (API Level 24) 이상
- JVM 11 이상
- Android Gradle Plugin 8.6.0 이상 권장
- Kotlin 1.9.22 이상

## __설치하기__

KiT Player SDK는 동영상 재생에 Bitmovin 솔루션을 사용합니다.
Bitmovin 저장소를 `settings.gradle`에 추가해야 합니다.

=== "Groovy"

    ```groovy
    // settings.gradle

    dependencyResolutionManagement {
        repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
        repositories {
            mavenCentral()
            ...
            maven { url 'https://artifacts.bitmovin.com/artifactory/public-releases' }
        }
    }
    ```

=== "Kotlin"

    ```kotlin
    // settings.gradle.kts

    dependencyResolutionManagement {
        repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
        repositories {
            mavenCentral()
            ...
            maven(url = "https://artifacts.bitmovin.com/artifactory/public-releases")
        }
    }
    ```

앱 모듈의 `build.gradle`에 SDK 의존성을 추가합니다.

=== "Groovy"

    ```groovy
    // app/build.gradle

    dependencies {
        implementation "io.github.kitbetter-web:sdk-android:1.0.0"
    }
    ```

=== "Kotlin"

    ```kotlin
    // app/build.gradle.kts

    dependencies {
        implementation("io.github.kitbetter-web:sdk-android:1.0.0")
    }
    ```

!!! warning "DataStore 의존성 추가 필수"
    KiT Player SDK는 내부적으로 `androidx.datastore`를 사용하지만, AAR에는 포함되어 있지 않습니다.
    앱 모듈의 `build.gradle`에 DataStore 의존성을 **반드시** 추가해야 합니다.

    자세한 내용은 [DataStore 의존성 가이드](datastore.md)를 참고하세요.

## __Application Context로 KiT Player SDK 초기화__

`initialize()`는 앱 실행 시 한 번만 호출하면 됩니다. `Application` 클래스의 `onCreate()`에서 호출하는 것을 권장합니다.

=== "Kotlin"

    ```kotlin
    // SampleApplication.kt

    class SampleApplication : Application() {
        override fun onCreate() {
            super.onCreate()

            KitInitializer.initialize(
                clientId = "your-client-id",
                secretKey = "your-secret-key",
                context = this@SampleApplication
            ) { success ->
                // 초기화 성공 여부를 수신합니다.
            }
        }
    }
    ```

=== "Java"

    ```java
    // SampleApplication.java

    public class SampleApplication extends Application {
        @Override
        public void onCreate() {
            super.onCreate();

            KitInitializer.INSTANCE.initialize(
                "your-client-id",
                "your-secret-key",
                this,
                success -> null
            );
        }
    }
    ```

`initialize()` 내부에는 API 요청이 포함되어 있으므로 몇 초의 딜레이가 있을 수 있습니다.
`initialize()` 콜백을 수신한 뒤에 `start()`를 호출하는 것이 안전합니다.

## __KiT Player SDK에 진입__

### SDKType

`start()` 호출 시 SDK 진입 방식을 선택할 수 있습니다.

| 타입 | 설명 |
|------|------|
| `SDKType.MODAL` | 현재 화면 위에 전체 화면으로 SDK를 오버레이합니다. |
| `SDKType.EMBED` | 현재 화면에서 SDK 화면으로 전환합니다. |

### start()

=== "Kotlin"

    ```kotlin
    // SampleActivity.kt

    sdkButton.setOnClickListener {
        KitInitializer.start(
            activity = this@SampleActivity,
            userId = "user-id",
            sdkType = SDKType.MODAL,  // SDKType.MODAL 또는 SDKType.EMBED
            onStartFailure = { kitError ->
                Toast.makeText(this, "errorCode : ${kitError.errorCode}", Toast.LENGTH_SHORT).show()
            },
            onKitError = { kitError ->
                Log.d("KiT SDK", "errorCode : ${kitError.errorCode}, cause : ${kitError.cause}")
            }
        )
    }
    ```

=== "Java"

    ```java
    // SampleActivity.java

    sdkButton.setOnClickListener(v -> {
        KitInitializer.INSTANCE.start(
            this,
            "user-id",
            SDKType.MODAL,
            kitError -> {
                Toast.makeText(this,
                    "errorCode : " + kitError.getErrorCode(),
                    Toast.LENGTH_SHORT).show();
                return null;
            },
            kitError -> {
                Log.d("KiT SDK", "errorCode : " + kitError.getErrorCode() + ", cause : " + kitError.getCause());
                return null;
            }
        );
    });
    ```

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|:----:|------|
| `activity` | `Activity` | ✓ | SDK를 실행할 Activity |
| `userId` | `String` | ✓ | 사용자 식별자 |
| `sdkType` | `SDKType` | | 진입 방식 (기본값: `SDKType.EMBED`) |
| `onStartFailure` | `(KitError) -> Unit` | | 초기화 미완료 시 호출되는 콜백 |
| `onKitError` | `(KitError) -> Unit` | | SDK 내부 에러 콜백 |

### startWithDynamicLink()

NFC 태그나 딥링크로부터 받은 링크 데이터를 SDK에 전달하여 진입할 때 사용합니다.
NFC 기능을 사용하지 않는 경우 `start()`를 사용하세요.

=== "Kotlin"

    ```kotlin
    KitInitializer.startWithDynamicLink(
        activity = this@SampleActivity,
        userId = "user-id",
        sdkType = SDKType.MODAL,
        dynamicLink = "received-dynamic-link",
        onStartFailure = { kitError ->
            Log.e("KiT SDK", "Start failed: ${kitError.errorCode}")
        },
        onKitError = { kitError ->
            Log.d("KiT SDK", "errorCode : ${kitError.errorCode}, cause : ${kitError.cause}")
        }
    )
    ```

=== "Java"

    ```java
    KitInitializer.INSTANCE.startWithDynamicLink(
        this,
        "user-id",
        SDKType.MODAL,
        "received-dynamic-link",
        kitError -> {
            Log.e("KiT SDK", "Start failed: " + kitError.getErrorCode());
            return null;
        },
        kitError -> {
            Log.d("KiT SDK", "errorCode : " + kitError.getErrorCode());
            return null;
        }
    );
    ```

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|:----:|------|
| `activity` | `Activity` | ✓ | SDK를 실행할 Activity |
| `userId` | `String` | ✓ | 사용자 식별자 |
| `sdkType` | `SDKType` | | 진입 방식 (기본값: `SDKType.EMBED`) |
| `dynamicLink` | `String?` | | NFC 태그 또는 딥링크로부터 전달받은 데이터 |
| `onStartFailure` | `(KitError) -> Unit` | | 초기화 미완료 시 호출되는 콜백 |
| `onKitError` | `(KitError) -> Unit` | | SDK 내부 에러 콜백 |
