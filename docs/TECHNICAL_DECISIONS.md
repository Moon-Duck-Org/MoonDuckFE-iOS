# 🎯 기술적 의사결정

MoonDuck 개발 과정에서의 기술 선택과 그 배경을 설명합니다.

<br/>

## 1. Open API 통합

### 상황

4개 카테고리(영화, 드라마, 책, 공연)에 대해 각각 다른 외부 API를 사용합니다.

| 카테고리 | API | 인증 방식 | 응답 형식 |
|:---|:---|:---|:---|
| 영화 | 영화진흥위원회 | API Key | JSON |
| 책 | 네이버 검색 | Client ID + Secret | JSON |
| 드라마 | TMDB | Bearer Token | JSON |
| 공연 | 서울시 문화행사 | 없음 | JSON |

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

### 해결한 문제

| 문제 | 해결 |
|:---|:---|
| API별 인증 방식 차이 | 각 API별 헤더 설정 분리 |
| 응답 데이터 구조 차이 | API별 ResponseDTO 정의 후 `toDomain()`으로 Program 모델 통일 |

Presenter에서는 카테고리와 무관하게 동일한 `[Program]` 타입으로 처리합니다.

<br/>

## 2. Realm 선택

### 상황

v1.0에서는 RESTful API 서버를 사용했으나, 서버 비용 문제로 로컬 DB로 전환이 필요했습니다.

### 선택지

| 선택지 | 고려사항 |
|:---|:---|
| Core Data | Apple 기본 제공, 러닝커브 있음 |
| Realm | 간단한 API, Object 상속으로 모델 정의 |

### 선택 이유

- Object 상속만으로 모델 정의 가능
- 동기식 CRUD API 제공

```swift
// Realm Object 정의
class ReviewObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var rating: Int
}

// CRUD
let reviews = realm.objects(ReviewObject.self)
try realm.write { realm.add(reviewObject) }
```

<br/>

## 3. DTO Mapping

### 선택 배경

외부 API 응답 구조와 앱 내부 도메인 모델을 분리하기 위함입니다.

### 구현

```swift
// API 응답 DTO
struct SearchMovieResponse: Decodable {
    let movieListResult: MovieListResult
    
    func toDomain() -> [Program] {
        return movieListResult.movieList.map { movie in
            Program(
                category: .movie,
                title: movie.movieNm,
                subTitle: movie.movieNmEn
            )
        }
    }
}
```

API 스펙이 변경되면 ResponseDTO만 수정하고, 앱 내부 로직은 영향받지 않습니다.

v1.1에서 Realm 전환 후에도 동일한 패턴을 적용합니다:

```swift
// RealmObject → Domain Model
func toDomain() -> Review {
    return Review(
        id: id,
        title: title,
        content: content,
        rating: rating
    )
}
```

<br/>

## 4. Category Enum 설계

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

## 5. 라이브러리 선택

| 라이브러리 | 용도 | 선택 이유 |
|:---|:---|:---|
| Alamofire | HTTP 네트워킹 | URLSession 대비 간결한 코드 |
| Kingfisher | 이미지 캐싱 | 메모리/디스크 캐싱, 셀 재사용 시 취소 처리 |
| SwiftGen | 리소스 접근 | 문자열 오타 방지, 컴파일 타임 체크 |
| SwiftLint | 코드 스타일 | 코드 스타일 통일 |

### SwiftGen 적용 예시

```swift
// Before
let image = UIImage(named: "category_movie")

// After
let image = Asset.Assets.categoryMovie.image
```

<br/>

## 6. 이미지 첨부 처리

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

## 7. Firebase 활용

| 서비스 | 용도 |
|:---|:---|
| Analytics | 카테고리별 검색 횟수, API 에러 로깅 |
| Crashlytics | 크래시 리포트 수집 |
| RemoteConfig | 앱 업데이트 없이 설정값 변경 |

```swift
AnalyticsService.shared.logEvent(
    .SUCCESS_SEARCH_PROGRAM_MOVIE,
    parameters: [
        .PROGRAM_NAME: query,
        .PROGRAM_TOTAL_COUNT: "\(response.movieListResult.totCnt)"
    ]
)
```

<br/>

## 관련 문서

- [아키텍처 상세](ARCHITECTURE.md)
- [마이그레이션 스토리](MIGRATION_STORY.md)
