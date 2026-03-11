# __SDK에서 발생한 에러 코드 수신__

## __`start()` 호출 시 에러 콜백 등록하기__

=== "Kotlin"

    ```kotlin
    // SampleActivity.kt

    sdkButton.setOnClickListener {
        KitInitializer.start(
            activity = this@SampleActivity,
            userId = "user-id",
            sdkType = SDKType.MODAL,
            onStartFailure = { kitError ->
                Toast.makeText(this, "errorCode : ${kitError.errorCode}, cause : ${kitError.cause}", Toast.LENGTH_SHORT).show()
            },
            onKitError = { kitError ->
                Log.d("KiT SDK Error", "errorCode : ${kitError.errorCode}, cause : ${kitError.cause}")
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
                    "errorCode : " + kitError.getErrorCode() + ", cause : " + kitError.getCause(),
                    Toast.LENGTH_SHORT).show();
                return null;
            },
            kitError -> {
                Log.d("KiT SDK Error", "errorCode : " + kitError.getErrorCode() + ", cause : " + kitError.getCause());
                return null;
            }
        );
    });
    ```

## __`start()` 호출과 별개로 에러 콜백 등록하기__

=== "Kotlin"

    ```kotlin
    KitInitializer.setOnErrorListener { error ->
        Log.d("KiT SDK Error", "errorCode : ${error.errorCode}, cause : ${error.cause}")
    }
    ```

=== "Java"

    ```java
    KitInitializer.INSTANCE.setOnErrorListener(new ErrorCodeCallback() {
        @Override
        public void onError(@NonNull KitError error) {
            Log.d("KiT SDK Error", "errorCode : " + error.getErrorCode() + ", cause : " + error.getCause());
        }
    });
    ```

메모리 누수 방지를 위해, KiT SDK의 액티비티가 종료될 때 에러 콜백을 메모리에서 자동으로 제거합니다.
이 방법으로 콜백을 등록할 경우 `start()` 호출 시마다 `setOnErrorListener()`를 재호출해야 에러를 수신할 수 있습니다.

## __에러 콜백 직접 해제하기__

SDK 액티비티가 종료되면 에러 콜백은 자동으로 해제됩니다.
필요한 경우 직접 해제할 수도 있습니다.

=== "Kotlin"

    ```kotlin
    KitInitializer.clearErrorListener()
    ```

=== "Java"

    ```java
    KitInitializer.INSTANCE.clearErrorListener();
    ```
