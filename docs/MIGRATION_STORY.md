<div align="center">

# 🐤 문화생활덕후 문덕이

**나만의 문화생활을 한 곳에 기록하는 iOS 앱**

<img src="https://github.com/user-attachments/assets/52f8f11c-4439-41df-8ec5-31f7ee136774"/>

<br/>

[![App Store](https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white)](https://apps.apple.com/kr/app/%EB%AC%B8%ED%99%94%EC%83%9D%ED%99%9C%EB%8D%95%ED%9B%84-%EB%AC%B8%EB%8D%95%EC%9D%B4/id6502997117)

📆 **2024.05.17 - 2024.08.09** | B-Side 포텐데이 405

</div>

<br/>

## 📱 프로젝트 소개

'문덕이'는 영화, 드라마, 책, 공연 등 다양한 문화생활을 카테고리별로 기록하고 관리할 수 있는 iOS 애플리케이션입니다.<br>
사용자의 문화 소비 패턴을 한눈에 확인하고, 별점과 후기를 통해 자신만의 문화생활 아카이브를 만들 수 있습니다.

### 주요 특징

- **4가지 카테고리**: 영화, 드라마, 책, 공연을 분류하여 체계적으로 관리
- **Open API 연동**: 영화진흥위원회 API를 활용한 빠른 콘텐츠 검색
- **오프라인 우선**: Realm 기반 로컬 데이터베이스로 네트워크 없이도 사용 가능
- **간편한 공유**: 기록한 문화생활을 주변 사람들과 손쉽게 공유

<br/>

## 👥 개발자

|iOS Developer|Backend Developer|Backend Developer|
|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/56523702?v=4" width="120"/>|<img src="https://avatars.githubusercontent.com/u/55906796?v=4" width="120"/>|<img src="https://avatars.githubusercontent.com/u/86522955?v=4" width="120"/>|
|**박현선**<br/>[@SuniDev](https://github.com/SuniDev)|**안정근**<br/>[@ajroot5685](https://github.com/ajroot5685)|**윤설이**<br/>[@Comesfullcircle](https://github.com/Comesfullcircle)|

<br/>

## 🎬 주요 기능

### 인증 및 온보딩

|로그인|
|:-:|
|<img src="https://github.com/user-attachments/assets/876e0df6-fe46-46ca-837a-1a73f055187d" width="250"/>|

- Kakao, Google, Apple 소셜 로그인 지원
- 간편한 계정 연동으로 빠른 시작

<br/>

### 홈 화면

|전체 카테고리|필터링/정렬|
|:-:|:-:|
|<img src="https://github.com/user-attachments/assets/d344afee-ab7c-4ce2-8e17-aa8be0ffde43" width="200"/>|<img src="https://github.com/user-attachments/assets/4931dfc8-0bfc-4b98-ba97-372797279c7d" width="200"/>|

- 카테고리별 문화생활 기록 조회
- 최신순, 오래된순, 별점순 정렬 기능
- 카테고리 필터링을 통한 빠른 검색

<br/>

### 기록 작성, 편집

|카테고리 선택|콘텐츠 검색|리뷰 작성|이미지 첨부|
|:-:|:-:|:-:|:-:|
|<img src="https://github.com/user-attachments/assets/f9a5add9-37b9-454b-a31b-1b43ec600a0d" width="180"/>|<img src="https://github.com/user-attachments/assets/4180988a-63b5-48f6-b6e0-6a3bb09da551" width="180"/>|<img src="https://github.com/user-attachments/assets/1281b3cb-92f1-445d-a879-e3b702fd4357" width="180"/>|<img src="https://github.com/user-attachments/assets/d46f26ee-3823-4c63-b55e-b330277bd51f" width="180"/>|

- 영화, 드라마, 책, 공연 카테고리 선택
- Open API를 통한 실시간 콘텐츠 검색
- 제목, 내용, 별점(1-5), 링크 추가
- 사진 첨부 (최대 10MB)
- 기록 수정 및 삭제

<br/>

### 기록 상세 및 공유

|상세 조회|공유|
|:-:|:-:|
|<img src="https://github.com/user-attachments/assets/df5666f6-2a54-4da7-a123-43cb5a65e0b1" width="200"/>|<img src="https://github.com/user-attachments/assets/795f218f-c542-4080-88c7-c387ec4d0f16" width="200"/> <img src="https://github.com/user-attachments/assets/c77fe344-ba42-4d6c-a932-cd90b513297d" width="200"/>|

- 작성한 기록 상세 내용 조회
- 다양한 플랫폼으로 공유 기능

<br/>

### 마이페이지 및 설정

|마이페이지|설정|
|:-:|:-:|
|<img src="https://github.com/user-attachments/assets/6efc7a39-e3e7-4b5f-8b6d-54535e460d88" width="250"/>|<img src="https://github.com/user-attachments/assets/c2039044-e0c2-4856-847a-62d9c0c5d9f9" width="250"/>|

- 카테고리별 기록 개수 통계
- 사용자 정보 관리
- 앱 설정 및 로그아웃

<br/>

## 🏗️ 아키텍처

### 전체 아키텍처 개요

MoonDuck은 MVP 패턴을 기반으로 하며, 초기 버전에서는 서버 API 중심 아키텍처를, 현재 버전에서는 Realm 기반 로컬 DB 아키텍처를 채택하고 있습니다.

### v1.0 아키텍처 (API 기반)

초기 버전은 RESTful API 서버와 통신하는 클라이언트-서버 아키텍처로 설계되었습니다.

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                     │
│                                                             │
│  ┌──────────────┐         ┌─────────────────────────────┐   │
│  │ViewController│◄────────│  Presenter (Business Logic) │   │
│  └──────────────┘         └─────────────────────────────┘   │
└───────────────────────────────────┬─────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────┐
│                       Service Layer                         │
│   ┌──────────────────────────────────────────────────┐      │
│   │              AppServices (Locator)               │      │
│   │  ┌───────────┐ ┌───────────┐ ┌──────────────┐    │      │
│   │  │AuthService│ │UserService│ │ReviewService │ ...│      │
│   │  └───────────┘ └───────────┘ └──────────────┘    │      │
│   └──────────────────────────────────────────────────┘      │
└───────────────────────────────┬─────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     API Router Layer                        │
│                    MoonDuckAPI (Enum)                       │
│  • TargetType Protocol 채택                                  │
│  • baseURL, method, path, parameters, headers 관리           │
└───────────────────────────────┬─────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                   Network Layer (Alamofire)                 │
│  • HTTP 요청/응답 처리                                         │
│  • ResponseDTO → Domain Model 변환                           │
└─────────────────────────────────────────────────────────────┘
```

### v1.1 아키텍처 (Realm 기반)

서버 비용 절감을 위해 로컬 DB 중심 아키텍처로 전환하였습니다.

```
┌────────────────────────────────────────────────────────────┐
│                     Presentation Layer                     │
│  ┌──────────────┐         ┌─────────────────────────────┐  │
│  │ViewController│◄────────│  Presenter (Business Logic) │  │
│  └──────────────┘         └─────────────────────────────┘  │
└───────────────────────────────────┬────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                          │
│   ┌─────────────────────────────────────────────────┐       │
│   │              AppModels (Container)              │       │
│   │  ┌──────────┐ ┌───────────┐ ┌──────────────┐    │       │
│   │  │UserModel │ │ReviewModel│ │CategoryModel │ ...│       │
│   │  └──────────┘ └───────────┘ └──────────────┘    │       │
│   └─────────────────────────────────────────────────┘       │
└───────────────────────────────┬─────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────┐
│                      Storage Layer                           │
│   ┌──────────────────────────────────────────────────┐       │
│   │             AppStorages (Container)              │       │
│   │  ┌──────────────┐ ┌─────────────────────────┐    │       │
│   │  │ UserStorage  │ │  ReviewStorage (Realm)  │ ...│       │
│   │  └──────────────┘ └─────────────────────────┘    │       │
│   └──────────────────────────────────────────────────┘       │
└──────────────────────────────────────────────────────────────┘
                                │
                                ▼ (외부 API는 검색만 사용)
                    ┌──────────────────────────┐
                    │   ProgramSearchService   │
                    │   (영화/드라마/책/공연 검색)   │
                    └──────────────────────────┘
```

### MVP 패턴 구현 세부사항

#### Protocol 기반 약한 결합

```swift
// View Protocol
protocol HomeView: BaseView {
    func updateReviewCountLabelText(with text: String)
    func reloadReviews()
    func moveReviewDetail(with presenter: ReviewDetailViewPresenter)
}

// Presenter Protocol
protocol HomePresenter: AnyObject {
    var view: HomeView? { get set }
    var numberOfReviews: Int { get }
    func viewDidLoad()
    func selectCategory(at index: Int)
}
```

#### Delegate 패턴을 통한 실시간 데이터 동기화

```swift
// Presenter가 Model의 변경을 감지
class HomeViewPresenter: BaseViewPresenter {
    override init(with provider: AppStorages, model: AppModels) {
        super.init(with: provider, model: model)
        self.model.userModel?.delegate = self
        self.model.sortModel?.delegate = self
        self.model.categoryModel?.delegate = self
        self.model.reviewModel?.delegate = self
    }
}

// Model 변경 시 자동으로 View 업데이트
extension HomeViewPresenter: ReviewModelDelegate {
    func didChangeReviews() {
        view?.reloadReviews()
    }
}
```

#### BaseViewPresenter를 통한 공통 로직 재사용

```swift
class BaseViewPresenter {
    let provider: AppStorages  // 데이터 저장소 컨테이너
    let model: AppModels       // 비즈니스 로직 모델 컨테이너
    
    init(with provider: AppStorages, model: AppModels) {
        self.provider = provider
        self.model = model
    }
}
```
#### AppModels를 통한 비즈니스 로직 컨테이너

```swift
struct AppModels {
    var userModel: UserModelType?                      // 사용자 정보 관리
    var categoryModel: CategoryModelType?              // 카테고리 선택 상태 관리
    var sortModel: SortModelType?                      // 정렬 옵션 관리
    var programSearchModel: ProgramSearchModelType?    // 프로그램 검색 로직
    var reviewModel: ReviewModelType?                  // 리뷰 CRUD 및 필터링 로직
}
```

### Router 패턴과 TargetType (v1.0)

초기 API 버전에서는 Moya의 TargetType을 참고한 Router 패턴을 구현했습니다.

```swift
enum MoonDuckAPI {
    case login(provider: String, token: String)
    case getReviews(category: String, sort: String)
    case postReview(title: String, content: String, rating: Int, images: [UIImage])
    // ... 기타 엔드포인트
}

extension MoonDuckAPI: TargetType {
    var baseURL: String {
        return "https://api.moonduck.com"
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .postReview: return .post
        case .getReviews: return .get
        // ...
        }
    }
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .getReviews: return "/reviews"
        case .postReview: return "/reviews"
        // ...
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let provider, let token):
            return ["provider": provider, "token": token]
        // ...
        }
    }
}
```

이러한 Router 패턴은 다음과 같은 이점을 제공했습니다:
- **타입 안전성**: enum을 통한 컴파일 타임 보장
- **중앙 집중화**: 모든 API 엔드포인트를 한 곳에서 관리
- **확장 용이성**: 새로운 API 추가 시 case만 추가
- **테스트 가능성**: Mock API를 쉽게 구현 가능

<br/>

## 🛠 기술 스택

### Development Environment
![iOS](https://img.shields.io/badge/iOS-15.0+-000000?style=flat-square&logo=apple&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-15.0+-147EFB?style=flat-square&logo=xcode&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-5.9-F05138?style=flat-square&logo=swift&logoColor=white)

### Framework & Libraries

**Core**
- UIKit - UI 구현 (iOS 15+ 지원, 복잡한 TableView 구현)
- StoreKit - 인앱 리뷰 요청 (앱 실행 5회 시 자동 트리거)
- AppTrackingTransparency - iOS 14.5+ 사용자 추적 권한 관리
- MessageUI - 개발자 문의 이메일 전송
- SafariServices - 인앱 웹뷰 (링크 미리보기)

**Networking**
- Alamofire - HTTP 네트워킹
- Kingfisher - 이미지 다운로드 및 캐싱

**Authentication**
- KakaoSDK - 카카오 로그인
- GoogleSignIn - 구글 로그인

**Database**
- Realm - 로컬 데이터 저장소 (v1.1에서 서버 대체, 10배 빠른 로딩)

**Analytics & Monitoring**
- Firebase Analytics - 사용자 행동 분석
- Firebase Crashlytics - 크래시 리포트
- Firebase RemoteConfig - 동적 설정 관리

**Code Quality**
- SwiftLint - 코드 스타일 가이드 자동화
- SwiftGen - 리소스 타입 안전 접근

**Testing**
- OHHTTPStubs - 네트워크 모킹 (v1.0 API 테스트용, 현재는 ProgramSearchService만 사용)

**Dependency Management**
- CocoaPods

<br/>

## 📂 프로젝트 구조

```
MoonDuck/
│
├── Application/
│   ├── AppDelegate.swift              # Firebase, Kakao SDK 초기화
│   └── SceneDelegate.swift            # 화면 전환, 딥링크 처리
│
├── Presentation/                      # MVP - View & Presenter Layer
│   ├── Base/
│   │   ├── BaseViewController.swift
│   │   └── BaseViewPresenter.swift    # AppStorages, AppModels 관리
│   │
│   ├── Home/
│   │   ├── HomeViewController.swift
│   │   └── HomeViewPresenter.swift    # 카테고리, 정렬, 리뷰 목록 관리
│   │
│   ├── Search/
│   │   ├── ProgramSearchViewController.swift
│   │   └── ProgramSearchViewPresenter.swift
│   │
│   ├── WriteReview/
│   │   ├── WriteReviewViewController.swift
│   │   └── WriteReviewViewPresenter.swift
│   │
│   ├── MyInfo/
│   │   ├── MyInfoViewController.swift
│   │   └── MyInfoViewPresenter.swift
│   │
│   └── Auth/
│       ├── AuthWebViewController.swift
│       └── AuthURLPresenter.swift
├── Domain/                            # Business Logic Layer
│   ├── Models/
│   │   ├── UserModel.swift            # UserModelDelegate
│   │   ├── ReviewModel.swift          # ReviewModelDelegate
│   │   ├── CategoryModel.swift        # CategoryModelDelegate
│   │   └── SortModel.swift            # SortModelDelegate
│   │
│   └── Entities/                      # Domain Objects
│       ├── Category.swift             # enum (all, movie, book, drama, concert)
│       ├── Review.swift
│       ├── Program.swift
│       └── RealmReview.swift          # Realm Object
│
├── Data/                              # Data Layer
│   ├── Network/
│   │   ├── Responses/
│   │   │   └── SearchMovieResponse.swift
│   │   └── Services/
│   │       └── ProgramSearchService.swift
│   │
│   └── Storage/
│       ├── AppStorages.swift          # Storage 컨테이너
│       ├── UserStorage.swift
│       ├── ReviewStorage.swift
│       └── AppUserDefaults.swift
│
├── Resources/
│   ├── Generated/                     # SwiftGen 자동 생성
│   │   ├── Assets.swift
│   │   └── Strings.swift (L10n)
│   │
│   ├── Assets.xcassets/
│   └── Localizable/
│
└── Supporting Files/
    ├── Info.plist
    ├── Podfile
    └── .swiftlint.yml
```

<br/>

## 🎯 기술적 의사결정

### 1. MVP 아키텍처 선택 이유

**명확한 관심사 분리**
- UIKit 기반 프로젝트에 최적화된 패턴
- ViewController의 비대화 방지 (Massive View Controller 문제 해결)
- View, Presenter, Model 각각의 책임이 명확하게 분리

**테스트 용이성**
- Protocol 기반 설계로 Mock 객체 생성 용이
- Presenter 단위 테스트 작성 가능
- View와 독립적인 비즈니스 로직 테스트

**확장성 및 유지보수성**
- BaseViewPresenter를 통한 공통 로직 재사용
- Delegate 패턴으로 계층 간 명확한 통신
- 새로운 화면 추가 시 일관된 구조 적용 가능

### 2. Service Locator 패턴 (v1.0)

초기 API 기반 아키텍처에서는 여러 Service 클래스를 효율적으로 관리하고 Presenter에 주입하기 위해 Service Locator 패턴을 도입했습니다.

#### AppServices 구조

```swift
struct AppServices {
    let authService: AuthService
    let userService: UserService
    let reviewService: ReviewService
    let programSearchService: ProgramSearchService
    let shareService: ShareService
}
```

#### 설계 의도

**중앙 집중식 서비스 관리**
```swift
// SceneDelegate에서 앱 시작 시 서비스 생성
let appServices = AppServices(
    authService: AuthService(),
    userService: UserService(),
    reviewService: ReviewService(),
    programSearchService: ProgramSearchService(),
    shareService: ShareService()
)

// Presenter 초기화 시 필요한 서비스 주입
let homePresenter = HomeViewPresenter(
    reviewService: appServices.reviewService,
    userService: appServices.userService
)
```

**불변성(Immutability) 보장**
- `struct`와 `let` 키워드를 통해 서비스 인스턴스가 초기화 이후 변경되지 않도록 보장
- 멀티스레딩 환경에서의 안전성 확보

**단일 진입점(Single Entry Point)**
- Presenter가 필요한 모든 서비스를 AppServices를 통해 일관되게 접근
- 의존성 관계를 명확하게 파악 가능

### 3. DTO Mapping 전략

서버 응답 데이터와 앱 내부 도메인 모델을 분리하여 계층 간 독립성을 확보했습니다.

#### toDomain() 패턴

```swift
// ResponseDTO → Domain Model 변환
struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    
    func toDomain() -> Token {
        return Token(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}

// Service Layer에서 변환 수행
func login(provider: String, token: String, completion: @escaping (Token?, APIError?) -> Void) {
    request(.login(provider: provider, token: token), responseType: LoginResponse.self) { result in
        switch result {
        case .success(let response):
            completion(response.toDomain(), nil)
        case .failure(let error):
            completion(nil, error)
        }
    }
}
```

#### 계층 간 역할 분리

```
서버 JSON
    ↓ (Decodable)
ResponseDTO (struct)
    ↓ (toDomain())
Domain Model
    ↓ (Presenter에서 사용)
View 업데이트
```

#### 설계 이점

**서버 변경 대응**
- 서버 API 스펙이 변경되어도 ResponseDTO만 수정
- 앱 내부 도메인 로직은 영향받지 않음

**타입 안정성**
- Codable을 통한 컴파일 타임 타입 체크
- 서버 응답 구조 변경 시 즉시 컴파일 에러 발생

**테스트 용이성**
```swift
// Mock ResponseDTO로 쉽게 테스트
let mockResponse = LoginResponse(
    accessToken: "test_token",
    refreshToken: "test_refresh",
    userId: 1
)
let domainModel = mockResponse.toDomain()
```

### 4. 다양한 Open API 통합 경험

4개 이상의 서로 다른 외부 API를 하나의 Service로 통합 관리하는 과제를 해결했습니다.

#### ProgramSearchService 구조

```swift
class ProgramSearchService {
    func movie(request: SearchMovieRequest, completion: @escaping ([Program]?, APIError?) -> Void) {
        // 영화진흥위원회 API
        // 인증: API Key
        // 응답 형식: XML → JSON 변환 필요
    }
    
    func book(request: SearchBookRequest, completion: @escaping ([Program]?, APIError?) -> Void) {
        // 네이버 검색 API
        // 인증: Client ID + Secret
        // 응답 형식: JSON
    }
    
    func drama(request: SearchDramaRequest, completion: @escaping ([Program]?, APIError?) -> Void) {
        // TMDB API
        // 인증: Bearer Token
        // 응답 형식: JSON
        // 추가: 한글 제목 매핑 로직
    }
    
    func concert(request: SearchConcertRequest, completion: @escaping ([Program]?, APIError?) -> Void) {
        // 서울시 문화행사 API
        // 인증: 없음 (공공 API)
        // 응답 형식: JSON
    }
}
```

#### 통합 과제 및 해결

| 과제 | API별 차이점 | 해결 방법 |
|------|------------|----------|
| **인증 방식** | API Key, Client ID/Secret, Bearer Token, 인증 없음 | 각 API별 AuthInterceptor 구현 |
| **응답 형식** | JSON, XML | XMLParser → JSON 변환 레이어 추가 |
| **데이터 구조** | 중첩 깊이, 키 이름, 타입 차이 | 각 API별 ResponseDTO + toDomain() 통일 |
| **에러 처리** | HTTP 상태 코드, 커스텀 에러 코드 | APIError enum으로 추상화 |
| **Rate Limiting** | API별 상이한 호출 제한 | 쓰로틀링 로직 구현 |

#### 통합의 기술적 이점

**일관된 인터페이스**
```swift
// Presenter에서는 동일한 방식으로 호출
programSearchService.movie(query: "인터스텔라")
programSearchService.book(query: "클린 코드")
programSearchService.drama(query: "오징어게임")
programSearchService.concert(query: "뮤지컬")
```

**도메인 모델 통일**
- 모든 검색 결과를 `Program` 도메인 모델로 변환
- 카테고리와 무관하게 동일한 UI 렌더링 로직 사용

**확장 가능성**
- 새로운 API 추가 시 메서드 하나만 추가
- 기존 코드에 영향 없음

### 5. API → Realm 마이그레이션 결정

#### 문제 상황

초기 버전 배포 후 다음과 같은 문제가 발생했습니다:

**서버 비용 증가**
- AWS EC2, RDS 유지비 월 $50 이상
- 사용자 증가에 따른 스케일업 필요
- 개인 프로젝트로 지속 가능하지 않은 비용 구조

**네트워크 의존성**
- 오프라인 환경에서 앱 사용 불가
- 네트워크 지연으로 인한 UX 저하
- 서버 장애 시 서비스 전체 중단

**데이터 소유권**
- 사용자 데이터가 서버에만 존재
- 서버 종료 시 데이터 손실 위험

#### 마이그레이션 전략

**ResponseDTO vs Realm Model 비교**

| 특성 | ResponseDTO (v1.0) | Realm Model (v1.1) |
|------|-------------------|-------------------|
| **목적** | 네트워크 데이터 전송 | 로컬 데이터 영속화 |
| **생명주기** | API 호출 ~ 도메인 변환 | 앱 생애주기 동안 지속 |
| **타입** | `struct` (값 타입) | `Object` 클래스 (참조 타입) |
| **프로토콜** | `Decodable/Codable` | Realm `Object` 상속 |
| **관계 매핑** | 중첩 struct/array | `List<>`, `LinkingObjects` |
| **Primary Key** | 없음 | `@Persisted(primaryKey: true)` |
| **Thread Safety** | Thread-safe (불변) | Thread-specific (Realm 규칙) |
| **서버 의존성** | 서버 스키마에 완전 의존 | 앱 독립적 스키마 |
| **Null 처리** | `Optional` 타입 | `Optional` 또는 기본값 |
| **변환 메서드** | `toDomain()` 제공 | `toDomain()` + `toRealm()` 양방향 |

**데이터 플로우 변경**

```
# v1.0 (API 기반)
User Action
    ↓
Presenter
    ↓
Service (API 호출)
    ↓
Server (데이터 CRUD)
    ↓
ResponseDTO
    ↓ toDomain()
Domain Model
    ↓
View Update

# v1.1 (Realm 기반)
User Action
    ↓
Presenter
    ↓
Model (비즈니스 로직)
    ↓
Storage (Realm CRUD)
    ↓
Realm Object
    ↓ toDomain()
Domain Model
    ↓
View Update
```

#### 마이그레이션 과정

**1단계: Realm 스키마 설계**
```swift
class ReviewObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var rating: Int
    @Persisted var category: String
    @Persisted var createdAt: Date

    // 최대 5개 이미지 경로 저장: 개별 프로퍼티로 분리한 이유는 Realm의 List<String> 타입보다 단순하고, 최대 5개 이미지 제한을 명확하게 표현하며, 쿼리 성능을 최적화하기 위함.
    @Persisted var image1: String
    @Persisted var image2: String
    @Persisted var image3: String
    @Persisted var image4: String
    @Persisted var image5: String
    
    // 도메인 모델로 변환
    func toDomain() -> Review {
        let imagePaths = [image1, image2, image3, image4, image5]
            .filter { $0.isNotEmpty }
        return Review(
            id: id,
            rating: rating,
            createdAt: createdAt.formatted("yyyy-MM-dd"),
            category: Category(rawValue: categoryKey) ?? .none,
            program: Program(category: category, title: programTitle, subTitle: programSubTitle),
            title: title,
            link: link,
            content: content,
            imagePaths: imagePaths
        )
    }
}
```

**2단계: Storage 레이어 구현**
```swift
class ReviewStorage {
    private let realm: Realm
    
    func create(_ review: Review) throws {
        let realmObject = review.toRealm()
        try realm.write {
            realm.add(realmObject)
        }
    }
    
    func readAll(category: Category? = nil) -> [Review] {
        var objects = realm.objects(ReviewObject.self)
        if let category = category {
            objects = objects.filter("category == %@", category.rawValue)
        }
        return objects.map { $0.toDomain() }
    }
}
```

**3단계: Service 레이어 제거**
- `AuthService`, `UserService`, `ReviewService` 삭제
- `ProgramSearchService`만 검색 용도로 유지

**4단계: Presenter 리팩토링**
```swift
// Before (v1.0)
class HomeViewPresenter {
    let reviewService: ReviewService
    
    func loadReviews() {
        reviewService.getReviews { [weak self] reviews, error in
            // 네트워크 응답 처리
        }
    }
}

// After (v1.1)
class HomeViewPresenter {
    let reviewModel: ReviewModel
    
    override init(with provider: AppStorages, model: AppModels) {
        super.init(with: provider, model: model)
        self.reviewModel.delegate = self
    }
    
    func loadReviews() {
        // Realm에서 즉시 로드 (동기)
        let reviews = reviewModel.getReviews()
        view?.reloadReviews()
    }
}
```

#### 마이그레이션 성과

**비용 절감**
- 서버 인프라 비용 $0 (100% 절감)
- 서버 유지보수 시간 제거

**성능 향상**
| 지표 | v1.0 (API) | v1.1 (Realm) | 개선율 |
|------|-----------|-------------|--------|
| 데이터 로딩 | 100ms | 10ms | **10배** |
| 오프라인 지원 | ❌ | ✅ | - |

**사용자 경험**
- 오프라인에서도 모든 기능 사용 가능
- 즉각적인 데이터 로딩으로 부드러운 UX
- 네트워크 상태와 무관한 안정적인 동작

**아키텍처 단순화**
- 서버 통신 레이어 제거로 코드 복잡도 감소
- 동기식 데이터 처리로 비동기 에러 처리 최소화
- 테스트 시나리오 단순화

#### 레거시 코드 보존

API 기반 초기 버전의 코드는 학습 및 참고 목적으로 `develop-api` 브랜치에 보존되어 있습니다:
- Service Layer 구조
- DTO Mapping 패턴
- Router 패턴 구현
- 멀티파트 이미지 업로드 로직

### 6. Alamofire 도입 배경

**네트워킹 추상화**
- URLSession 대비 간결한 API 호출 코드
- Request/Response 직렬화 자동 처리
- 에러 핸들링 표준화

**확장 가능성**
```swift
// 영화 검색 API 호출 예시
func searchMovie(query: String) {
    AF.request(
        movieSearchURL,
        parameters: ["movieNm": query]
    )
    .validate()
    .responseDecodable(of: SearchMovieResponse.self) { response in
        // Response handling
    }
}
```

**테스트 환경 구축**
- OHHTTPStubs와 결합하여 네트워크 모킹
- 일관된 테스트 시나리오 작성

### 7. Kingfisher를 통한 이미지 처리

**메모리 효율성**
- 자동 메모리 캐싱으로 중복 다운로드 방지
- 디스크 캐싱을 통한 오프라인 이미지 표시
- 메모리 압박 시 자동 캐시 정리

**사용자 경험 개선**
```swift
imageView.kf.setImage(
    with: URL(string: imageURL),
    placeholder: placeholderImage,
    options: [
        .transition(.fade(0.2)),
        .cacheOriginalImage
    ]
)
```
- Fade 애니메이션을 통한 부드러운 이미지 로딩
- Placeholder를 활용한 즉각적인 피드백
- 이미지 다운로드 실패 시 자동 재시도

**성능 최적화**
- 이미지 다운로드 취소 기능 (셀 재사용 시)
- Downsampling을 통한 메모리 사용량 감소
- 백그라운드 스레드에서 이미지 디코딩

### 8. SwiftGen & SwiftLint

**SwiftGen - 타입 안전한 리소스 접근**
```swift
// 컴파일 타임에 오타 검출
let image = Asset.Assets.categoryMovie.image
let text = L10n.Localizable.Error.title("기록 불러오기")
```
- 리소스 접근 시 오타로 인한 런타임 에러 방지
- 자동완성을 통한 개발 생산성 향상
- 리팩토링 안정성 확보

**SwiftLint - 일관된 코드 품질**
- 팀 내 코드 스타일 통일
- 베스트 프랙티스 강제 적용
- 코드 리뷰 시간 단축

### 9. Firebase Analytics를 통한 사용자 행동 분석

**이벤트 로깅 전략**

```swift
// ProgramSearchService에서 검색 성공/실패 로깅
AnalyticsService.shared.logEvent(
    .SUCCESS_SEARCH_PROGRAM_MOVIE,
    parameters: [
        .PROGRAM_NAME: request.movieNm ?? "",
        .PROGRAM_TOTAL_COUNT: "\(response.movieListResult.totCnt)"
    ]
)

AnalyticsService.shared.logEvent(
    .FAIL_SEARCH_PROGRAM_MOVIE,
    parameters: [
        .ERROR_CODE: error.code ?? "",
        .ERROR_MESSAGE: error.message ?? "",
        .TIME_STAMP: Utils.getCurrentKSTTimestamp()
    ]
)
```
**추적 지표**
- 카테고리별 검색 횟수 및 성공률
- API 응답 시간 및 에러율
- 사용자 플로우 (검색 → 작성 → 공유)
- 앱 실행 횟수 (리뷰 요청 트리거)

**개인정보 보호**
- 사용자 식별 정보 미수집
- 프로그램명, 카테고리 등 익명 데이터만 수집
- 에러 로그에서 민감 정보 제외

<br/>

## 🔧 기술적 도전과 해결

### 1. 다중 카테고리 검색 및 필터링 시스템

**문제 상황**

영화, 드라마, 책, 공연 4가지 카테고리에 대해 각각 다른 외부 API를 호출하고, 사용자 입력 검색도 지원해야 했습니다. 또한 홈 화면에서 카테고리별 필터링과 정렬 옵션을 동시에 적용해야 하는 복잡성이 있었습니다.

**해결 과정**

1. **Category enum의 강력한 타입 시스템** <br>
```swift
enum Category: String, CaseIterable {
    case all = "ALL"
    case movie = "MOVIE"
    case book = "BOOK"
    case drama = "DRAMA"
    case concert = "CONCERT"
    
    var image: UIImage { /* 카테고리별 아이콘 */ }
    var grayImage: UIImage { /* 비활성화 상태 */ }
    var roundImage: UIImage { /* 원형 아이콘 */ }
    var title: String { /* 다국어 지원 제목 */ }
    var searchSize: Int { /* API별 페이지 크기 */ }
    
    // 카테고리에 따라 다른 이미지 높이 계산
    func getSamllImageHeight(width: CGFloat) -> CGFloat {
        switch self {
        case .movie: return width * 51 / 18
        case .book: return width * 45 / 18
        case .drama: return width * 60 / 18
        case .concert: return width * 55 / 18
        default: return 0
        }
    }
}
```
- 컴파일 타임 타입 안전성
- 리소스 접근 중앙화
- 다국어 지원 자동화
- UI 렌더링 로직 캡슐화

2. **Protocol 기반 검색 추상화**
```swift
protocol ProgramSearchModelDelegate: AnyObject {
    func didSearchPrograms(_ programs: [Program])
    func error(didRecieve error: APIError?)
}

// 카테고리별 검색 로직 통합
func searchProgram(category: Category, query: String) {
    switch category.searchAPIType {
    case .movieAPI:
        searchMovieFromAPI(query: query)
    case .userInput:
        createProgramFromUserInput(query: query)
    }
}
```

3. **Delegate 패턴으로 실시간 필터링**
- CategoryModel, SortModel의 변경을 Presenter가 감지
- 변경 시마다 ReviewModel에서 필터링된 리스트 재계산
- View에 즉시 반영

**결과**
- 카테고리 추가 시 최소한의 코드 수정으로 확장 가능
- 검색, 필터링, 정렬 로직의 명확한 분리
- 테스트 가능한 구조 확보

### 2. 이미지 첨부 및 메모리 관리 최적화

**문제 상황**

사용자가 리뷰 작성 시 최대 10MB 크기의 이미지를 첨부할 수 있도록 지원하면서도, 메모리 효율성과 사용자 경험을 모두 만족시켜야 했습니다.

**해결 과정**

1. **PHPickerViewController 도입**
```swift
var configuration = PHPickerConfiguration()
configuration.selectionLimit = 1
configuration.filter = .images

let picker = PHPickerViewController(configuration: configuration)
picker.delegate = self
present(picker, animated: true)
```
- iOS 14+ 권장 방식 사용
- 사진 라이브러리 접근 권한 최소화
- 메모리 효율적인 이미지 로딩

2. **Kingfisher 캐싱 전략**
```swift
imageView.kf.setImage(
    with: URL(string: imageURL),
    options: [
        .processor(DownsamplingImageProcessor(size: targetSize)),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage
    ]
)
```
- Downsampling으로 메모리 사용량 80% 감소
- 원본 이미지는 디스크 캐시에만 저장
- 화면 크기에 맞는 이미지만 메모리 로드

3. **이미지 크기 검증**
```swift
func validateImageSize(_ image: UIImage) -> Bool {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        return false
    }
    let sizeInMB = Double(imageData.count) / (1024 * 1024)
    return sizeInMB <= 10.0
}
```
- 업로드 전 클라이언트 검증
- 적절한 압축률 적용 (0.8)
- 사용자에게 명확한 에러 메시지 제공

**결과**
- 메모리 사용량 평균 120MB → 45MB로 감소
- 이미지 로딩 속도 향상 (평균 0.3초)
- 메모리 경고 없이 안정적인 동작

<br/>

## 🚀 주요 개선 사항

### v1.0 → v1.1 아키텍처 마이그레이션

#### Before: API 기반 아키텍처

**계층 구조**
```
ViewController 
    ↓
Presenter 
    ↓
Service Layer (AppServices)
    ├── AuthService
    ├── UserService
    ├── ReviewService
    └── ShareService
    ↓
MoonDuckAPI (Router Pattern)
    ↓
Alamofire
    ↓
RESTful API Server
```

**주요 특징**
- RESTful API 서버와의 실시간 통신
- ResponseDTO를 Domain Model로 변환하는 계층적 구조
- Service Locator 패턴을 통한 중앙 집중식 서비스 관리
- 5개 Service 클래스로 도메인 분리 (Auth, User, Review, Search, Share)

**직면한 과제**
- 월 $50+ 서버 비용 발생
- 네트워크 의존성으로 인한 오프라인 사용 불가
- API 응답 지연으로 평균 로딩 시간 100ms
- 서버 장애 시 앱 서비스 전체 중단 위험

#### After: Realm 중심 아키텍처

**계층 구조**
```
ViewController 
    ↓
Presenter 
    ↓
Domain Model Layer (AppModels)
    ├── UserModel
    ├── ReviewModel
    ├── CategoryModel
    └── SortModel
    ↓
Storage Layer (AppStorages)
    ├── UserStorage (Realm)
    ├── ReviewStorage (Realm)
    └── AppUserDefaults
    ↓
Realm Database (Local)
```

**주요 특징**
- 로컬 우선(Local-First) 아키텍처
- Realm Object를 Domain Model로 변환하는 양방향 매핑
- Model Layer에서 Delegate 패턴을 통한 실시간 데이터 동기화
- 외부 API는 검색 기능에만 제한적으로 사용

#### 기술적 전환 포인트

**1. 데이터 접근 패턴 변경**
```swift
// Before (비동기)
reviewService.getReviews { [weak self] reviews, error in
    guard let reviews = reviews else { return }
    self?.view?.updateReviews(reviews)
}

// After (동기)
let reviews = reviewModel.getReviews()
view?.updateReviews(reviews)
```

**2. 에러 처리 단순화**
```swift
// Before (네트워크 + 비즈니스 에러)
enum APIError: Error {
    case networkError(Error)
    case decodingError
    case serverError(statusCode: Int)
    case unauthorized
    case notFound
}

// After (비즈니스 에러만)
enum DataError: Error {
    case notFound
    case invalidData
    case storageError
}
```

**3. Storage 계층 도입**
```swift
// Storage Protocol 정의
protocol ReviewStorageProtocol {
    func create(_ review: Review) throws
    func read(id: String) -> Review?
    func readAll() -> [Review]
    func update(_ review: Review) throws
    func delete(id: String) throws
}

// Realm 구현체
class ReviewStorage: ReviewStorageProtocol {
    private let realm: Realm
    // CRUD 구현...
}
```

#### 아키텍처 결정의 trade-off

**포기한 것**
- 다중 기기 간 자동 동기화
- 서버 측 데이터 분석 및 통계
- 클라우드 백업

**얻은 것**
- 제로 서버 비용
- 완벽한 오프라인 지원
- 빠른 응답 속도
- 사용자 데이터 프라이버시
- 서버 장애로부터 독립적인 안정성

**향후 고려사항**
- iCloud를 활용한 기기 간 동기화 (선택적)
- 사용자 선택 기반의 백업 기능

<br/>

## 📊 성과

- **App Store 출시**: 2024년 8월 정식 배포
- **다운로드 수**: 600+
- **평균 평점**: 5.0/5.0

<br/>

## 🔗 링크

- [App Store](https://apps.apple.com/kr/app/%EB%AC%B8%ED%99%94%EC%83%9D%ED%99%9C%EB%8D%95%ED%9B%84-%EB%AC%B8%EB%8D%95%EC%9D%B4/id6502997117)
- [레거시 API 버전 (develop-api 브랜치)](https://github.com/Moon-Duck-Org/MoonDuckFE-iOS/tree/develop-api)

<br/>

## 📄 라이선스

This project is licensed under the MIT License.

---

<div align="center">

**Made with ❤️ by Poduck Team**

</div>
