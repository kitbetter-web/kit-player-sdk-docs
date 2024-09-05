# __Android 튜토리얼__
## __설치 조건__
- 최소 설치 가능 안드로이드 SDK Level ≥ 24
- 권장 Android Gradle Plugin ≥ 7.4.2
- sourceCompatibility, targetCompatibility ≥ 1.8
- SDK가 사용하는 Kotlin 버전은 1.8.0입니다. 이보다 낮은 버전을 사용하고 있을 경우 [Gradle dependency resolution](https://docs.gradle.org/current/userguide/dependency_resolution.html)과 관련한 이슈가 발생할 수 있습니다.

## __설치하기__
=== "Groovy"
    ```kotlin
    // settings.gradle

    dependencyResolutionManagement {
        repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
        repositories {
            ...
            maven { url 'https://jitpack.io' }
            maven { url = uri("https://artifacts.bitmovin.com/artifactory/public-releases") }
        }
    }
    ```



=== "Kotlin"
    ```kotlin
    // settings.gradle

    dependencyResolutionManagement {
        repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
        repositories {
            ...
            maven { url = uri("https://jitpack.io") }
            maven(url = "https://artifacts.bitmovin.com/artifactory/public-releases")
        }
    }
    ```

KiT Player SDK는 동영상 재생에 Bitmovin 솔루션을 사용합니다.
root build.gradle에 Bitmovin 의존성을 추가해야 합니다.

```kotlin
// Project : build.gradle

plugins {
    id 'maven-publish'
}

```

=== "Groovy"
    ```kotlin
    // App : build.gradle

    dependencies {
        implementation "com.github.kitbetter-web:sdk-android:1.0.0"
    }
    ```

=== "Kotlin"
    ```kotlin
    // App : build.gradle

    dependencies {
        implementation("com.github.kitbetter-web:sdk-android:1.0.0")
    }
    ```

## __Application Context로 KiT Player SDK 초기화__
=== "Kotlin"

    ```kotlin
    // SampleApplication.kt

    class SampleApplication: Application() {
        override fun onCreate() {
            super.onCreate()
            
            val sampleSdkKey = "280a8a4d-a27f-4d01-b031-2a003cc4c039"
            val sampleSecretKey = "4325349b13f4e91a1e7f561f2d715e51e69330307c6db7a04b1207e9ef9z2357b"
            val samplePackageName = "your.projects.packagename"
            
            SDKInitializer.initialize(
                sampleSdkKey,
                sampleSecretKey,
                samplePackageName,
                this@SampleApplication
            ) { success ->
                // Add action when initialization is successful.
            }
        }
    }z
    ```

=== "Java"

    ```java
    // SampleApllication.java

    public class SampleApplication extends Application {
        @Override
        public void onCreate() {
            super.onCreate();

            String sdkKey = "280a8a4d-a27f-4d01-b031-2a003cc4c039";
            String secretKey = "4325349b13f4e91a1e7f561f2d715e51e69330307c6db7a04b1207e9ef9z2357b";
            String packageName = "your.projects.packagename";

            SDKInitializer.INSTANCE.initialize(
                    sdkKey, secretKey, packageName, this, new Function1<Boolean, Unit>() {
                        @Override
                        public Unit invoke(Boolean aBoolean) {
                            // Add action when initialization is successful.
                            return null;
                        }
                    }
            );
        }
    }
    ```

## __KiT Player SDK에 진입__
=== "Kotlin"

    ```kotlin
    // SampleActivity.kt

    SDKInitializer.start(
        activity = this@SampleActivity,
        sdkType = SDKType.MODAL  // choose which you want (MODAL, EMBED)
    ) { errorMsg ->
        // Add action when the start() call fails.
        Toast.makeText(this@MainActivity, errorMsg, Toast.LENGTH_SHORT).show()
    }
    ```

=== "Java"

    ```java
    // SampleActivity.java

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        SDKInitializer.INSTANCE.start(this, SDKType.EMBED, new Function1<String, Unit>() {
            @Override
            public Unit invoke(String errorMsg) {
                // Add action when the start() call fails.
                Toast.makeText(SampleActivity.this, errorMsg, Toast.LENGTH_SHORT).show();
                return null;
            }
        });
    }
    ```
