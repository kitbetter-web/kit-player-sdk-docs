# __DataStore 의존성 추가__

KiT Player SDK는 내부적으로 `androidx.datastore`를 사용합니다.
단, SDK AAR에는 DataStore가 포함되어 있지 않으므로 앱 모듈에 DataStore 의존성을 **반드시** 추가해야 합니다.

추가하지 않으면 SDK 실행 시 런타임 크래시가 발생합니다.

## __의존성 추가__

=== "Groovy"

    ```groovy
    // app/build.gradle

    dependencies {
        implementation "androidx.datastore:datastore-preferences:1.1.1"
    }
    ```

=== "Kotlin"

    ```kotlin
    // app/build.gradle.kts

    dependencies {
        implementation("androidx.datastore:datastore-preferences:1.1.1")
    }
    ```

## __버전 충돌 발생 시__

앱이 이미 다른 버전의 DataStore를 사용 중인 경우, SDK와의 버전 충돌로 빌드 에러가 발생할 수 있습니다.
이 경우 Gradle의 dependency resolution 설정으로 버전을 통일합니다.

=== "Groovy"

    ```groovy
    // app/build.gradle

    configurations.all {
        resolutionStrategy {
            force "androidx.datastore:datastore-preferences:1.1.1"
            force "androidx.datastore:datastore-preferences-core:1.1.1"
        }
    }
    ```

=== "Kotlin"

    ```kotlin
    // app/build.gradle.kts

    configurations.all {
        resolutionStrategy {
            force("androidx.datastore:datastore-preferences:1.1.1")
            force("androidx.datastore:datastore-preferences-core:1.1.1")
        }
    }
    ```
