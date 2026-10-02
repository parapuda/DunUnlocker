# DunUnlocker
삼성 갤럭시 기기를 비롯한 안드로이드 스마트폰에서 APN 타입에 dun을 정상적으로 추가하도록 도와주는 앱입니다.

## 저장소
https://github.com/naijun0403/DunUnlocker

## 요구 사항
- 안드로이드 기기
- Shizuku

## 주의 사항
안드로이드 시스템 특성상 같은 데이터로 이름만 다른 APN을 추가하면 추가되는 것이 아닌 이름이 수정됩니다.
이 점 참고해주세요!

**USE AT YOUR OWN RISK!**

## 빌드 방법

이 포크의 개발 환경 준비·빌드·검사·Git 작업은 [개발 안내](docs/development.md)를 참고해주세요.
본 프로젝트는 일반적으로 사용불가능한 안드로이드의 숨겨진 API를 활용합니다.

따라서 기본적으로 안드로이드 스튜디오에서 제공되는 android.jar (공개 API 정의 파일)을 사용하여 본 앱을 빌드할 수 없습니다.

빌드시에는 일반적으로 수정된 android.jar파일을 요구하며, 자세한 내용은 [여기](https://github.com/JetpackDuba/android-jar-with-hidden-api)를 참고해주세요.

## 라이선스
GPL-3.0-only

## Credits
- [vvb2060](https://github.com/vvb2060) - 우회 방안에 대한 기본적인 아이디어
- [pixel-volte-patch](https://github.com/kyujin-cho/pixel-volte-patch) - 우회 방안에 대한 기본적인 아이디어
