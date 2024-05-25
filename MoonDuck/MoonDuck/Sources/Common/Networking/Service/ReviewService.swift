//
//  ReviewService.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Alamofire

class ReviewService {
    
    // FIXME: - TEST CODE : BOARD API
    func boardPostsUser(request: BoardPosetUserRequest, completion: @escaping (_ succeed: [Review]?, _ failed: Error?) -> Void) {
        completion([Review(id: 0, title: "브리저튼 3 대공개", created: "2024년 5월 21일", nickname: "문덕이문덕이문덕이2", category: .movie, content: "원작대로라면 브리저튼가의 차남 베네딕트 브리저튼의 이야기가 될 듯 하였으나 케이트 샤르마 역의 시몬 애슐리의 인터뷰에 의하면 시즌 3는 콜린 브리저튼과 페넬로페 페더링턴의 이야기가 될 것이라고 한다.원작대로라면 브리저튼가의 차남 베네딕트 브리저튼의 이야기가 될 듯 하였으나 케이트 샤르마 역의 시몬 애슐리의 인터뷰에 의하면 시즌 3는 콜린 브리저튼과 페넬로페 페더링턴의 이야기가 될 것이라고 한다.", imageUrlList: [], link: "https://www.naver.com/", starRating: 2)], nil)
    }
    
    func reviewAll(request: ReviewAllRequest, completion: @escaping (_ succeed: [Review]?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.reviewAll(request))
            .responseDecodable(of: [ReviewResponse].self) { response in
                switch response.result {
                case .success(let response):
                    completion(response.map { $0.toDomain }, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
//            .responseDecodable { (response: AFDataResponse<ReviewListResponse>) in
    }
}
