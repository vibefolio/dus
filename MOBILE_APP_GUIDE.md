# DUS 모바일 앱 (Hotwire Native)

## 개요
Hotwire Native로 웹 화면을 그대로 모바일 앱으로 변환.
서버 코드 변경 없이 앱 업데이트 가능.

## Rails 서버 준비 (완료)
- [x] TurboNativeApp concern (네이티브 감지)
- [x] mobile 레이아웃 (navbar/footer 없음)
- [x] /native/config 엔드포인트 (앱 설정)

## Android 앱 생성
1. Android Studio → New Project → Empty Activity
2. build.gradle에 Hotwire Native 의존성 추가:
   ```gradle
   implementation 'dev.hotwire:navigation:1.0.0'
   ```
3. BASE_URL을 `https://designd.co.kr`로 설정
4. MainActivity에서 HotwireActivity 구현

## iOS 앱 생성
1. Xcode → New Project → App
2. Swift Package Manager로 Hotwire Native 추가:
   `https://github.com/hotwired/hotwire-native-ios`
3. SceneDelegate에서 startLocation 설정

## 스토어 배포
- Bundle ID: `com.vibers.dus`
- App Store / Play Store에 앱 등록
- 개인정보 처리방침: https://designd.co.kr/privacy
