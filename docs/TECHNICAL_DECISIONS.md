# 🎯 기술적 의사결정

MoonDuck 개발 과정에서의 기술 선택과 그 배경을 설명합니다.

<br/>

## 1. MVP 아키텍처

### 선택 배경

UIKit 기반 프로젝트에서 ViewController의 비대화를 방지하기 위해 MVP 패턴을 채택했습니다.

### 구조

| 계층 | 역할 |
|:---|:---|
| View (ViewController) | UI 렌더링, 사용자 입력 전달 |
| Presenter | 비즈니스 로직, View 업데이트 지시 |
| Model | 데이터 관리, 상태 변경 알림 |

### Protocol 기반 설계

View와 Presenter 간 의존성을 Protocol로 분리하여 단위 테스트 작성이 가능하도록 했습니다.

```swift
protocol HomeView: BaseView {
    func reloadReviews()
}

protocol HomePresenter: AnyObject {
    var view: HomeView? { get set }
    func viewDidLoad()
}
```

<br/>

## 2. Service Locator 패턴 (v1.0)

### 선택 배경

여러 Service 인스턴스를 Presenter에 주입할 때 일관된 방식이 필요했습니다.

### 구현

```swift
struct AppServices {
    let authService: AuthService
    let userService: UserService
    let reviewService: ReviewService
    let programSearchService: ProgramSearchService
}
```

SceneDelegate에서 앱 시작 시 생성하고, Presenter 초기화 시 필요한 서비스를 전달합니다.

```swift
let homePresenter = HomeViewPresenter(
    reviewService: appServices.reviewService,
    userService: appServices.userService
)
```

<br/>

## 3. DTO Mapping

### 선택 배경

서버 응답 구조와 앱 내부 도메인 모델을 분리하여 서버 스펙 변경에 대응하기 위함입니다.

### 구현

```swift
// 서버 응답 DTO
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
```

서버 API 스펙이 변경되면 ResponseDTO만 수정하고, 앱 내부 로직은 영향받지 않습니다.

<br/>

## 4. Open API 통합

### 상황

4개 카테고리(영화, 드라마, 책, 공연)에 대해 각각 다른 외부 API를 사용합니다.

| 카테고리 | API | 인증 방식 |
|:---|:---|:---|
| 영화 | 영화진흥위원회 | API Key |
| 책 | 네이버 검색 | Client ID + Secret |
| 드라마 | TMDB | Bearer Token |
| 공연 | 서울시 문화행사 | 없음 |

### 구현

ProgramSearchService에서 카테고리별 API 호출을 통합 관리합니다.

```swift
class ProgramSearchService {
    func movie(query: String, completion: @escaping ([Program]?, APIError?) -> Void)
    func book(query: String, completion: @escaping ([Program]?, APIError?) -> Void)
    func drama(query: String, completion: @escaping ([Program]?, APIError?) -> Void)
    func concert(query: String, completion: @escaping ([Program]?, APIError?) -> Void)
}
```

각 API의 응답을 `Program` 도메인 모델로 변환하여 Presenter에서는 동일한 방식으로 처리합니다.

### 해결한 문제

| 문제 | 해결 |
|:---|:---|
| API별 인증 방식 차이 | 각 API별 헤더 설정 분리 |
| 응답 형식 차이 (JSON, XML) | API별 ResponseDTO + toDomain() |
| 데이터 구조 차이 | Program 모델로 통일 |

<br/>

## 5. Category Enum 설계

### 선택 배경

4개 카테고리에 대한 리소스(이미지, 텍스트, 설정값)를 한 곳에서 관리하기 위함입니다.

### 구현

```swift
enum Category: String, CaseIterable {
    case all = "ALL"
    case movie = "MOVIE"
    case book = "BOOK"
    case drama = "DRAMA"
    case concert = "CONCERT"
    
    var image: UIImage { ... }
    var title: String { ... }
    var searchSize: Int { ... }
}
```

카테고리 추가 시 enum에 case와 관련 프로퍼티만 추가하면 됩니다.

<br/>

## 6. 라이브러리 선택

### Alamofire

URLSession 대비 간결한 API 호출 코드 작성을 위해 사용했습니다.

```swift
AF.request(url, parameters: params)
    .validate()
    .responseDecodable(of: Response.self) { response in
        // 처리
    }
```

### Kingfisher

이미지 다운로드 및 캐싱을 위해 사용했습니다.

```swift
imageView.kf.setImage(
    with: URL(string: imageURL),
    placeholder: placeholderImage,
    options: [.transition(.fade(0.2))]
)
```

- 메모리/디스크 캐싱 자동 처리
- 셀 재사용 시 이미지 다운로드 취소 처리

### Realm

v1.1에서 서버 대체를 위한 로컬 DB로 선택했습니다.

- Core Data 대비 간단한 API
- Object 상속만으로 모델 정의 가능
- 동기식 CRUD로 비동기 처리 최소화

### SwiftGen

리소스 접근 시 문자열 오타를 방지하기 위해 사용했습니다.

```swift
// Before: 런타임 에러 가능
let image = UIImage(named: "category_movie")

// After: 컴파일 타임 체크
let image = Asset.Assets.categoryMovie.image
```

### SwiftLint

팀 내 코드 스타일 통일을 위해 사용했습니다.

<br/>

## 7. 이미지 첨부 처리

### PHPickerViewController 사용

iOS 14+에서 권장하는 방식으로, 사진 라이브러리 전체 접근 권한 없이 선택한 이미지만 가져올 수 있습니다.

```swift
var configuration = PHPickerConfiguration()
configuration.selectionLimit = 1
configuration.filter = .images

let picker = PHPickerViewController(configuration: configuration)
```

### 이미지 크기 제한

업로드 전 클라이언트에서 10MB 제한을 검증합니다.

```swift
func validateImageSize(_ image: UIImage) -> Bool {
    guard let data = image.jpegData(compressionQuality: 0.8) else {
        return false
    }
    let sizeInMB = Double(data.count) / (1024 * 1024)
    return sizeInMB <= 10.0
}
```

<br/>

## 8. Firebase 활용

### Analytics

카테고리별 검색 횟수, API 에러 발생 등을 로깅합니다.

```swift
AnalyticsService.shared.logEvent(
    .SUCCESS_SEARCH_PROGRAM_MOVIE,
    parameters: [
        .PROGRAM_NAME: query,
        .PROGRAM_TOTAL_COUNT: "\(response.movieListResult.totCnt)"
    ]
)
```

### Crashlytics

크래시 발생 시 자동으로 리포트를 수집합니다.

### RemoteConfig

앱 업데이트 없이 설정값을 변경할 수 있도록 사용합니다.

<br/>

## 9. 다중 필터링 처리

### 상황

홈 화면에서 카테고리 필터와 정렬 옵션을 동시에 적용해야 합니다.

### 구현

CategoryModel과 SortModel이 각각 상태를 관리하고, Delegate를 통해 Presenter에 변경을 알립니다.

```swift
class HomeViewPresenter: BaseViewPresenter {
    override init(with provider: AppStorages, model: AppModels) {
        super.init(with: provider, model: model)
        self.model.categoryModel?.delegate = self
        self.model.sortModel?.delegate = self
        self.model.reviewModel?.delegate = self
    }
}

extension HomeViewPresenter: CategoryModelDelegate {
    func didChangeCategory() {
        // 필터링된 리뷰 목록 재조회
        view?.reloadReviews()
    }
}
```

<br/>

## 관련 문서

- [아키텍처 상세](ARCHITECTURE.md)
- [마이그레이션 스토리](MIGRATION_STORY.md)
