# __ChromeCast Manifest Metadata 충돌__

KiTplayer SDK는 큰 화면으로 영상을 즐기실 수 있도록 ChromeCast 기능을 지원합니다.

ChromeCast를 사용하기 위해서는 **__AndroidManifest__**에 Metadata를 정의해야 합니다.

## 당신의 앱에 ChromeCast 기능이 구현되어 있는 경우
ChromeCast SDK는 하나의 앱에 두 개 이상의 `CastOptionsProvider`를 나누어 정의할 수 없습니다.
KiTplayer SDK의 ChromeCast 기능을 사용하고 싶으실 경우, KiTplayer SDK의 `CastOptionsProvider`를 앱에 적용하기 위해 당신의 앱의 Metadata를 제거해야 합니다.

```xml
// AndroidManifest.xml

<application
    ...
    <meta-data
        android:name="com.google.android.gms.cast.framework.OPTIONS_PROVIDER_CLASS_NAME"
        android:value="your.projects.packagename.CastOptionsProvider" />
</application>
```