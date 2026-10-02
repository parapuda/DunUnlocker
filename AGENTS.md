# DunUnlocker 개발

- 환경·Git 작업은 `docs/development.md`를 따른다.
- 도구는 `mise.toml`과 Gradle Wrapper를 사용한다. 기본 검사: `mise run check`.
- `.local/android-sdk`는 숨겨진 API jar를 적용한 전용 SDK다. 공개 SDK로 바꾸거나
  다른 프로젝트의 SDK를 덮어쓰지 않는다.
- APN 호출은 `data/ApnManager.kt`, 권한 위임과 저장은 `BrokerInstrumentation.kt`,
  이름 있는 복사본의 검증은 `data/NamedApnCopy.kt`에 있다.
- `mise run test`는 연결된 기기·에뮬레이터가 필요하다. 저장 테스트는 가짜
  ContentProvider를 쓴다. `mise run check`는 기기 테스트 APK를 컴파일만 한다.
- `master`는 원본 추적에 사용하고 변경은 작업 브랜치에 둔다.
