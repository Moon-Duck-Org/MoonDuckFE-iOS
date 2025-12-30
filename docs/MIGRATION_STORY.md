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

### Trade-off

| 포기한 것 | 얻은 것 |
|:---|:---|
| 다중 기기 간 자동 동기화 | 서버 비용 제거 |
| 서버 측 데이터 백업 | 오프라인 사용 가능 |
| 서버 기반 통계/분석 | 서버 장애로부터 독립 |

<br/>

## 전환 과정

### 계층 구조 변경

**Before (v1.0)**
```
Presenter → Service (API 호출) → ResponseDTO → Domain Model
```

**After (v1.1)**
```
Presenter → Model → Storage (Realm CRUD) → RealmObject → Domain Model
```

### 코드 변경

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

## 레거시 코드 보존

API 기반 초기 버전 코드는 `develop-api` 브랜치에 보존했습니다.

- Service Layer 구조
- Router 패턴 (MoonDuckAPI enum)
- ResponseDTO 정의
- 멀티파트 이미지 업로드 로직

[develop-api 브랜치 바로가기](https://github.com/Moon-Duck-Org/MoonDuckFE-iOS/tree/develop-api)

<br/>

## 관련 문서

- [아키텍처 상세](ARCHITECTURE.md)
- [기술적 의사결정](TECHNICAL_DECISIONS.md)
