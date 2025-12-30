# 🔄 마이그레이션 스토리

v1.0(API 기반)에서 v1.1(Realm 기반)으로 전환한 과정을 기록합니다.

<br/>

## 배경

### v1.0 구조

초기 버전은 RESTful API 서버와 통신하는 구조였습니다.

```
iOS App → RESTful API Server → AWS RDS
```

### 문제 상황

| 문제 | 상세 |
|:---|:---|
| 서버 비용 | AWS EC2, RDS 유지비 발생 |
| 네트워크 의존성 | 오프라인 환경에서 앱 사용 불가 |
| 서버 장애 리스크 | 서버 다운 시 앱 전체 사용 불가 |

개인 프로젝트로 서버 비용을 지속적으로 부담하기 어려웠습니다.

<br/>

## 마이그레이션 결정

### 선택지 검토

| 선택지 | 장점 | 단점 |
|:---|:---|:---|
| 서버 유지 | 다중 기기 동기화 가능 | 비용 지속 발생 |
| Firebase Firestore | 서버리스, 실시간 동기화 | 사용량 따른 비용 발생 가능 |
| Realm (로컬 DB) | 비용 없음, 오프라인 지원 | 다중 기기 동기화 불가 |

문화생활 기록 앱 특성상 다중 기기 동기화보다 오프라인 사용이 더 중요하다고 판단하여 Realm을 선택했습니다.

### 포기한 것

- 다중 기기 간 자동 동기화
- 서버 측 데이터 백업
- 서버 기반 통계/분석

### 얻은 것

- 서버 비용 제거
- 오프라인 사용 가능
- 서버 장애로부터 독립

<br/>

## 마이그레이션 과정

### 1단계: 계층 구조 변경

**Before (v1.0)**
```
ViewController
    ↓
Presenter
    ↓
Service (API 호출)
    ↓
ResponseDTO → Domain Model
```

**After (v1.1)**
```
ViewController
    ↓
Presenter
    ↓
Model (비즈니스 로직)
    ↓
Storage (Realm CRUD)
    ↓
RealmObject → Domain Model
```

### 2단계: Service → Storage 전환

**v1.0 Service**
```swift
class ReviewService {
    func getReviews(completion: @escaping ([Review]?, APIError?) -> Void) {
        AF.request(MoonDuckAPI.getReviews)
            .responseDecodable(of: ReviewListResponse.self) { response in
                switch response.result {
                case .success(let dto):
                    completion(dto.toDomain(), nil)
                case .failure(let error):
                    completion(nil, .networkError(error))
                }
            }
    }
}
```

**v1.1 Storage**
```swift
class ReviewStorage {
    private let realm: Realm
    
    func readAll() -> [Review] {
        let objects = realm.objects(ReviewObject.self)
        return objects.map { $0.toDomain() }
    }
    
    func create(_ review: Review) throws {
        try realm.write {
            realm.add(review.toRealm())
        }
    }
}
```

### 3단계: Realm Object 정의

```swift
class ReviewObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var rating: Int
    @Persisted var category: String
    @Persisted var createdAt: Date
    @Persisted var image1: String
    @Persisted var image2: String
    @Persisted var image3: String
    @Persisted var image4: String
    @Persisted var image5: String
    
    func toDomain() -> Review {
        let imagePaths = [image1, image2, image3, image4, image5]
            .filter { $0.isNotEmpty }
        return Review(
            id: id,
            rating: rating,
            createdAt: createdAt.formatted("yyyy-MM-dd"),
            category: Category(rawValue: category) ?? .movie,
            title: title,
            content: content,
            imagePaths: imagePaths
        )
    }
}
```

이미지 경로를 `List<String>` 대신 개별 프로퍼티로 분리한 이유:
- 최대 5개 이미지 제한을 명시적으로 표현
- 쿼리 시 단순한 접근 가능

### 4단계: Presenter 수정

**v1.0 (비동기)**
```swift
func loadReviews() {
    reviewService.getReviews { [weak self] reviews, error in
        guard let reviews = reviews else {
            self?.view?.showError(error)
            return
        }
        self?.reviews = reviews
        self?.view?.reloadReviews()
    }
}
```

**v1.1 (동기)**
```swift
func loadReviews() {
    let reviews = model.reviewModel?.getReviews() ?? []
    self.reviews = reviews
    view?.reloadReviews()
}
```

Realm은 동기식 API를 제공하므로 completion handler가 필요 없어졌습니다.

### 5단계: 에러 처리 단순화

**v1.0**
```swift
enum APIError: Error {
    case networkError(Error)
    case decodingError
    case serverError(statusCode: Int)
    case unauthorized
    case notFound
}
```

**v1.1**
```swift
enum StorageError: Error {
    case notFound
    case writeFailed
}
```

네트워크 관련 에러 케이스가 제거되었습니다.

<br/>

## 유지된 부분

### ProgramSearchService

콘텐츠 검색 기능은 외부 API를 사용해야 하므로 그대로 유지했습니다.

```swift
class ProgramSearchService {
    func movie(query: String, completion: @escaping ([Program]?, APIError?) -> Void)
    func book(query: String, completion: @escaping ([Program]?, APIError?) -> Void)
    func drama(query: String, completion: @escaping ([Program]?, APIError?) -> Void)
    func concert(query: String, completion: @escaping ([Program]?, APIError?) -> Void)
}
```

### toDomain() 패턴

ResponseDTO → Domain Model 변환 패턴을 RealmObject → Domain Model 변환에도 동일하게 적용했습니다.

<br/>

## 레거시 코드 보존

API 기반 초기 버전 코드는 `develop-api` 브랜치에 보존했습니다.

보존된 내용:
- Service Layer 구조
- Router 패턴 (MoonDuckAPI enum)
- ResponseDTO 정의
- 멀티파트 이미지 업로드 로직

[develop-api 브랜치 바로가기](https://github.com/Moon-Duck-Org/MoonDuckFE-iOS/tree/develop-api)

<br/>

## Before / After 비교

| 항목 | v1.0 (API) | v1.1 (Realm) |
|:---|:---|:---|
| 데이터 저장 | 서버 DB | 로컬 Realm |
| 네트워크 필요 | 필수 | 검색 시에만 |
| 서버 비용 | 발생 | 없음 |
| 오프라인 사용 | 불가 | 가능 |
| 다중 기기 동기화 | 가능 | 불가 |
| 데이터 접근 | 비동기 | 동기 |

<br/>

## 관련 문서

- [아키텍처 상세](ARCHITECTURE.md)
- [기술적 의사결정](TECHNICAL_DECISIONS.md)
