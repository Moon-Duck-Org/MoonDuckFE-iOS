//
//  BoardService.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Alamofire

class BoardService {
    
    // FIXME: - TEST CODE : BOARD API
    func boardPostsUser(request: BoardPosetUserRequest, completion: @escaping (_ succeed: [Board]?, _ failed: Error?) -> Void) {
        completion([Board(id: 0, title: "브리저튼 3 대공개", created: "2024년 5월 21일", nickname: "문덕이문덕이문덕이2", content: "원작대로라면 브리저튼가의 차남 베네딕트 브리저튼의 이야기가 될 듯 하였으나 케이트 샤르마 역의 시몬 애슐리의 인터뷰에 의하면 시즌 3는 콜린 브리저튼과 페넬로페 페더링턴의 이야기가 될 것이라고 한다.원작대로라면 브리저튼가의 차남 베네딕트 브리저튼의 이야기가 될 듯 하였으나 케이트 샤르마 역의 시몬 애슐리의 인터뷰에 의하면 시즌 3는 콜린 브리저튼과 페넬로페 페더링턴의 이야기가 될 것이라고 한다.", imageUrlList: [], link: "https://www.naver.com/", starRating: 2)], nil)
    }
}
