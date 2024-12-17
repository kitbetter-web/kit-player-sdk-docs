# __SDK에서 발생한 에러 코드 수신__

## __`start()` 호출 시 에러 callback을 등록하기__

=== "Kotlin"

    ```kotlin
    // SampleActivity.kt

    sdkButton.setOnClickListener {
        KitInitializer.start(
            activity = this@SampleActivity,
            sdkType = SDKType.MODAL,
            onStartFailure = { kitError ->
                Toast.makeText(this@MainActivity, "errorCode : ${kitError.errorCode}, cause : ${kitError.cause}", Toast.LENGTH_SHORT).show()
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

    sdkButton.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            KitInitializer.INSTANCE.start(
                this, 
                SDKType.EMBED, 
                new Function1<String, Unit>() {
                    @Override
                    public Unit invoke(KitError kitError) {
                        // Add action when the start() call fails.
                        Toast.makeText(this, 
                            "errorCode : " + kitError.getErrorCode() + ", cause : " + kitError.getCause(), 
                            Toast.LENGTH_SHORT).show();
                        return null;
                    }
                },
                new Function1<String, Unit>() {
                    @Override
                    public Unit invoke(KitError error) {
                        // Add action when error received.
                        Log.d("KiT SDK Error", "errorCode : " + error.getErrorCode() + " cause : " + error.getCause());
                        return null;
                    }
                },
            );
        }
    })
    ```

## __`start()` 호출과 별개로 에러 callback을 등록하기__

=== "Kotlin"

    ```kotlin
    KitInitializer.setOnErrorListener {
        Log.d("KiT SDK Error", "errorCode : ${kitError.errorCode}, cause : ${kitError.cause}")
    }
    ```

=== "Java"

    ```java
    KitInitializer.INSTANCE.setOnErrorListener(new ErrorCodeCallback() {
        @Override
        public void onError(@NonNull KitError error) {
            Log.d("KiT SDK Error", "errorCode : " + error.getErrorCode() + " cause : " + error.getCause());
        }
    });
    ```

메모리 누수 방지를 위해, KiT SDK의 액티비티가 종료될 때 에러 callback을 메모리에서 제거합니다.
이 방법으로 callback을 등록할 경우 `start()` 호출 시점에 `setOnErrorListener()` 를 재호출해야 에러를 수신할 수 있습니다.