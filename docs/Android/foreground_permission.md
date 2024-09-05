# __FOREGROUND_SERVICE_DATA_SYNC 권한 이슈__

Target SDK 34부터 포그라운드 서비스의 사용 목적을 명시해야 합니다.

KiTplayer SDK는 동영상 재생 솔루션으로 Bitmovin Player를 사용하고 있습니다.
Bitmovin Player의 영상 다운로드 기능에 FOREGROUND_SERVICE_DATA_SYNC 권한이 사용됩니다.

앱 배포 중 Google로부터 권한 사용 목적 증명을 위해 자료를 제출해야 하는 경우,
KiTplayer SDK에 진입 후 앨범을 태그하고 동영상 재생 탭으로 이동하여,
영상 다운로드 버튼을 클릭한 후 처리되는 일련의 과정을 영상으로 녹화하여 제출하시기 바랍니다.

![KiTplayer SDK Video 탭](assets/foreground_permission_android.jpg)