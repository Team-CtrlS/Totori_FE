# <img width="40" height="40" alt="White" src="https://github.com/user-attachments/assets/e18ada55-9880-445e-84a4-0bd955c9ab07" /> 토토리(Totori)

> 프로젝트 기간 | 2025.09.01 ~ ing
<img width="1628" height="892" alt="스크린샷 2026-06-19 오후 6 48 47" src="https://github.com/user-attachments/assets/f785a1b5-997c-41a3-a19d-247f33bdafbe" />

# Totori_FE
> 토토리는 난독 아동과 읽기에 어려움을 겪는 아동이 자신의 관심사로 만들어진 동화를 읽고, 반복 학습을 통해 읽기 자신감을 키울 수 있도록 돕는 모바일 학습 서비스입니다. 보호자와 특수교사는 주간·전체 리포트에서 아동의 읽기 유창성과 오류 추세를 확인할 수 있습니다.

`Totori_FE`는 토토리의 **iOS 클라이언트**입니다. 관심사 음성 입력, 맞춤 동화 낭독, 퀴즈, 보호자 리포트 등 사용자에게 보이는 전체 학습 경험을 담당합니다.

### ✏️ 주요 기능

- 아동·보호자 역할별 로그인과 가족 연결
- 관심사 음성 입력 및 맞춤 동화 열람
- 문장별 듣기·낭독과 퀴즈 학습
- 배지·도토리 보상과 출석 현황
- 주간·전체 학습 리포트

<p align="center">
<img width="1920" height="1080" alt="10 주요 기능" src="https://github.com/user-attachments/assets/8de2b2ae-832b-4afa-a6c3-f75e4f7ea905" />
<img width="1920" height="1080" alt="11 주요 기능" src="https://github.com/user-attachments/assets/942c517e-c511-45f0-8054-55ed1c77fe1e" />
<img width="1920" height="1080" alt="12 주요 기능" src="https://github.com/user-attachments/assets/17073971-2dfa-44bb-a38e-41da8ffd0c5d" />
<img width="1920" height="1080" alt="13 주요 기능" src="https://github.com/user-attachments/assets/1e72be1a-dba8-4158-bb8a-eda1d235685f" />
</p>

### 📺 시연 영상

[토토리 데모 영상 보기](https://youtu.be/WHZ7pYWFDvs)

## 🍎 담당 팀원

| 정윤아 | 복지희 |
| :---: | :---: |
| <img width="120" alt="정윤아 GitHub 프로필" src="https://avatars.githubusercontent.com/u/166522604?v=4" />| <img width="120" alt="복지희 GitHub 프로필" src="https://avatars.githubusercontent.com/u/129582481?v=4" />
| [`@laura-jung`](https://github.com/laura-jung) |[`@jettieb`](https://github.com/jettieb)|
| **iOS Developer** | **iOS Developer** |
| 프로젝트 view 기초 세팅<br> 네트워크 기초 세팅<br> 메인화면 view, API 연결<br> 동화 생성, 낭독 view , API 연결<br> 퀴즈 API 연결<br> STT, TTS 연결<br>|퀴즈 화면 view, <br>학습 리포트 view, API 연결 <br> 뱃지 view, API 연결|

## ⚒️ 기술 스택

- Swift 5
- SwiftUI
- Moya 15
- Alamofire 5
- Kingfisher 8
- SwiftKeychainWrapper 4
- Swift Package Manager

## 📁 프로젝트 구조

```text
Totori_FE/
├── Totori/
│   ├── Application/
│   │   ├── Core/                 # 앱 상태, 내비게이션, 키체인, 녹음 관리
│   │   └── TotoriApp.swift       # 앱 진입점
│   ├── Network/
│   │   ├── API/                  # API 엔드포인트 정의
│   │   ├── Base/                 # 공통 요청, 응답, 토큰 처리
│   │   ├── Login/                # 로그인·출석 API
│   │   ├── SignUp/               # 회원가입·가족 연결 API
│   │   ├── StoryBook/            # 동화 API
│   │   ├── Quiz/                 # 퀴즈 API
│   │   └── Report/               # 학습 리포트 API
│   ├── Presentation/
│   │   ├── Common/               # 공통 UI와 리소스
│   │   └── ...                   # 기능별 View·ViewModel
│   ├── Info.plist
│   └── Config.xcconfig           # 직접 생성, Git 추적 제외
├── Totori.xcodeproj/
└── README.md
```

## 🗺️ 전체 시스템 아키텍처
<img width="3374" height="1939" alt="Frame 1739332346" src="https://github.com/user-attachments/assets/d349542c-5d00-4040-9fec-2ea0f66d5460" />


## 실행 환경

- macOS
- Xcode와 iOS 26 SDK
- iOS 26 시뮬레이터 또는 테스트 기기
- 실행 중인 [`Totori_BE`](https://github.com/Team-CtrlS/Totori_BE) [`Totori_AI`](https://github.com/Team-CtrlS/Totori_AI)서버

## 설치 및 설정

### 1. 저장소 복제

```bash
git clone https://github.com/Team-CtrlS/Totori_FE.git
cd Totori_FE
```

### 2. API 주소 설정

프로젝트는 `Totori/Config.xcconfig`의 `BASE_URL`을 사용합니다. 이 파일은 Git에서 제외되어 있으므로 직접 생성해야 합니다.

```xcconfig
BASE_URL = http://localhost:8080
```

환경별 예시:

```xcconfig
// iOS 시뮬레이터
BASE_URL = http://localhost:8080

// 실기기
BASE_URL = '실제 배포된 서버 주소'
```

### 3. 프로젝트 열기

```bash
open Totori.xcodeproj
```

Xcode가 `Package.resolved`를 기준으로 Swift Package 의존성을 자동으로 내려받습니다.

### 4. 서명 설정

1. Xcode에서 `Totori` 프로젝트와 앱 Target을 선택합니다.
2. `Signing & Capabilities`에서 자신의 Development Team을 선택합니다.
3. 필요한 경우 `Bundle Identifier`를 고유한 값으로 변경합니다.

## 실행

Xcode 상단에서 시뮬레이터 또는 연결된 기기를 선택한 뒤 `⌘R`을 누릅니다.

## 빌드

Xcode에서는 `Product > Build` 또는 `⌘B`를 사용합니다. 명령줄에서는 다음과 같이 시뮬레이터 빌드를 확인할 수 있습니다.

```bash
xcodebuild \
  -project Totori.xcodeproj \
  -scheme Totori \
  -sdk iphonesimulator \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## 📦 데이터와 재현 범위

프론트엔드는 별도의 학습 데이터나 초기 DB 데이터를 요구하지 않습니다. 앱 실행에 필요한 화면 코드, 이미지, 색상, 폰트 등의 리소스는 `Totori/Presentation/Common/Resources`에 포함되어 있습니다.

보안상 저장소에 포함되지 않는 값은 아래와 같습니다.

| 항목 | 준비 방법 |
| --- | --- |
| `Totori/Config.xcconfig` | 위의 API 주소 설정 예시로 직접 생성 |
| 로그인 토큰 | 앱 로그인 후 Keychain에 자동 저장 |
| 서비스 데이터 | 실행 중인 백엔드 API에서 조회 |

따라서 UI를 재현하려면 백엔드 서버와 `BASE_URL` 설정이 필요합니다. Swift Package 버전은 저장소의 `Package.resolved`로 고정되어 있습니다.

## 🚀 문제 해결

#### 앱이 시작하자마자 종료됩니다

`Totori/Config.xcconfig`가 없거나 `BASE_URL`이 비어 있는지 확인하세요. 앱은 `Info.plist`에서 `BASE_URL`을 찾지 못하면 실행을 중단합니다.

#### Swift Package를 내려받지 못합니다

Xcode에서 `File > Packages > Reset Package Caches`를 실행한 뒤 `Resolve Package Versions`를 다시 시도하세요.

#### 시뮬레이터에서는 되지만 실기기에서 서버에 연결되지 않습니다

`BASE_URL`을 Mac의 LAN IP로 변경하고 다음을 확인하세요.

- Mac과 iPhone이 같은 네트워크인지
- 백엔드가 `localhost`가 아닌 외부 요청도 수신하는지
- macOS 방화벽이 8080 포트를 차단하지 않는지

## 📁 관련 저장소

- 백엔드: [`Totori_BE`](https://github.com/Team-CtrlS/Totori_BE)
- AI 서버: [`Totori_AI`](https://github.com/Team-CtrlS/Totori_AI)

## 라이선스

현재 별도의 라이선스 파일이 없습니다.
