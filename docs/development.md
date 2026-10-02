# 개발 환경

이 포크의 원본은 `naijun0403/DunUnlocker`다. `master`는 원본을 따라가고,
작업은 별도 브랜치에서 한다. 앱은 Kotlin·Compose와 Gradle Wrapper를 사용한다.

## 처음 준비하기

Linux x86_64에서 `mise`, `curl`, `unzip`이 필요하다.

```bash
git clone git@github.com:parapuda/DunUnlocker.git ~/Projects/DunUnlocker
cd ~/Projects/DunUnlocker
git remote add upstream https://github.com/naijun0403/DunUnlocker.git
git config remote.pushDefault origin
git config pull.ff only
git config fetch.prune true
mise trust
mise install
mise run setup
mise run check
```

JDK는 `mise.toml`의 Temurin 21, Gradle은 저장소의 Wrapper를 사용한다.
Java 소스 호환성 11과 Gradle 실행용 JDK 21은 별개다.

SDK는 `.local/android-sdk/`에 설치하며 `local.properties`에 절대 경로를 쓴다.
두 경로는 Git에서 제외된다. Android Studio에서는 저장소 루트를 열고
Gradle JDK를 `mise where java`가 출력하는 경로로 지정한다.
다른 OS에서는 SDK Manager로 SDK 37.0과 Build Tools 36.0.0을 설치하고,
아래의 숨겨진 API jar를 프로젝트 전용 SDK에 적용한 뒤 `sdk.dir`를 지정한다.

## 숨겨진 API

이 앱은 `IActivityManager`, `ISub` 등 공개 SDK에 없는 타입을 사용한다.
공식 SDK의 `android.jar`만으로는 컴파일할 수 없다.

준비 스크립트는 [Reginer/aosp-android-jar](https://github.com/Reginer/aosp-android-jar/tree/262f6ae931160011572a5adfe4ec6302585e8f60/android-37)의
Android 17/API 37, JDK 21용 프레임워크 jar를 커밋과 SHA-256으로 고정해 받는다.
이 파일을 프로젝트 SDK의 `platforms/android-37.0/android.jar`로 설치한다.
공식 원본은 같은 폴더의 `android.jar.stock`에 보존한다.
jar는 컴파일용이고 앱에 포함하지 않는다. 실제 기기에서는 Shizuku와
HiddenApiBypass를 통한 실행 경로가 필요하다.

SDK를 올릴 때는 `gradle/libs.versions.toml`, 준비 스크립트의 SDK 패키지,
프레임워크 jar 출처·체크섬을 함께 갱신하고 빌드와 기기 호환성을 확인한다.
공용 SDK를 수정하면 다른 Android 프로젝트에도 영향을 주므로 전용 SDK를 쓴다.

## 빌드와 검사

```bash
mise run build       # 디버그 APK
mise run test        # 연결된 기기·에뮬레이터에서 기존 테스트 실행
mise run lint        # Android lint
mise run check       # 디버그 APK·lint·기기 테스트 APK 컴파일 (기기 불필요)
```

디버그 APK는 `app/build/outputs/apk/debug/app-debug.apk`, lint 보고서는
`app/build/reports/lint-results-debug.html`이다. 디버그 서명은 Gradle이 관리한다.
릴리스 서명 키·비밀번호와 개인별 IDE 설정은 저장소에 넣지 않는다.

현재 테스트는 모두 `app/src/androidTest`에 있어 API 34 이상 기기 또는
에뮬레이터가 필요하다. 저장 테스트는 가짜 ContentProvider를 사용하므로
실제 APN을 수정하지 않는다. 실제 앱의 APN 변경을 확인하는 수동 시험에는
Shizuku가 필요하다.

```bash
adb devices
mise exec -- ./gradlew installDebug
mise exec -- ./gradlew connectedDebugAndroidTest
```

## Git 작업

```bash
git fetch upstream
git switch master
git merge --ff-only upstream/master
git push origin master
git switch -c fix/apn-verification
# 수정과 검사 후
git add <수정한 파일>
git commit -m "fix: verify saved APN settings"
git push -u origin fix/apn-verification
```

`origin`은 내 포크, `upstream`은 원본이다. 푸시는 기본적으로 `origin`으로 향한다.
`pull.ff=only`로 의도하지 않은 병합 커밋을 막고, `fetch.prune=true`로 삭제된
원격 브랜치를 정리한다.
