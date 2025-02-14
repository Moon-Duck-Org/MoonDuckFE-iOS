//
//  CategorySearchService.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Alamofire

class ProgramSearchService {
    func movie(request: SearchMovieRequest, completion: @escaping (_ succeed: [Program]?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.searchMovie(request).performRequest(responseType: SearchMovieResponse.self, completion: { result in
            switch result {
            case .success(let response):
                // LOG
                if request.curPage == "1" {
                    AnalyticsService.shared.logEvent(
                        .SUCCESS_SEARCH_PROGRAM_MOVIE,
                        parameters: [.PROGRAM_NAME: request.movieNm ?? "",
                                     .PROGRAM_TOTAL_COUNT: "\(response.movieListResult.totCnt)"]
                    )
                }
                let movieList = response.movieListResult.movieList.map { $0.toDomain() }
                completion(movieList, nil)
            case .failure(let error):
                // LOG
                AnalyticsService.shared.logEvent(
                    .FAIL_SEARCH_PROGRAM_MOVIE,
                    parameters: [.PROGRAM_NAME: request.movieNm ?? "",
                                 .ERROR_CODE: error.code ?? "",
                                 .ERROR_MESSAGE: error.message ?? "",
                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                )
                completion(nil, error)
            }
        })
    }
    
    func book(request: SearchBookRequest, completion: @escaping (_ succeed: [Program]?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.searchBook(request).performRequest(responseType: SearchBookResponse.self, completion: { result in
            switch result {
            case .success(let response):
                // LOG
                if request.start == 1 {
                    AnalyticsService.shared.logEvent(
                        .SUCCESS_SEARCH_PROGRAM_BOOK,
                        parameters: [.PROGRAM_NAME: request.query,
                                     .PROGRAM_TOTAL_COUNT: "\(response.total)"]
                    )
                }
                let bookList = response.items.map { $0.toDomain() }
                completion(bookList, nil)
            case .failure(let error):
                // LOG
                AnalyticsService.shared.logEvent(
                    .FAIL_SEARCH_PROGRAM_BOOK,
                    parameters: [.PROGRAM_NAME: request.query,
                                 .ERROR_CODE: error.code ?? "",
                                 .ERROR_MESSAGE: error.message ?? "",
                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                )
                completion(nil, error)
            }
        })
    }
    
    func drama(request: SearchDramaRequest, completion: @escaping (_ succeed: [Program]?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.searchDrama(request).performRequest(responseType: SearchDramaResponse.self, completion: { result in
            switch result {
            case .success(let response):
                // LOG
                if request.page == 1 {
                    AnalyticsService.shared.logEvent(
                        .SUCCESS_SEARCH_PROGRAM_DRAMA,
                        parameters: [.PROGRAM_NAME: request.query,
                                     .PROGRAM_TOTAL_COUNT: "\(response.totalResults)"]
                    )
                }
                
                let bookList = response.results.map { $0.toDomain() }
                completion(bookList, nil)
            case .failure(let error):
                // LOG
                AnalyticsService.shared.logEvent(
                    .FAIL_SEARCH_PROGRAM_DRAMA,
                    parameters: [.PROGRAM_NAME: request.query,
                                 .ERROR_CODE: error.code ?? "",
                                 .ERROR_MESSAGE: error.message ?? "",
                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                )
                
                completion(nil, error)
            }
        })
    }
    
    func concert(request: SearchConcertRequest, completion: @escaping (_ succeed: [Program]?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.searchConcert(request).performRequest(responseType: SearchConcertResponse.self, completion: { result in
                switch result {
                case .success(let response):
                    // LOG
                    if request.startIndex == 1 {
                        AnalyticsService.shared.logEvent(
                            .SUCCESS_SEARCH_PROGRAM_CONCERT,
                            parameters: [.PROGRAM_NAME: request.title,
                                         .PROGRAM_TOTAL_COUNT: "\(response.culturalEventInfo.listTotalCount)"]
                        )
                    }
                    
                    let concertList = response.culturalEventInfo.row.map { $0.toDomain() }
                    completion(concertList, nil)
                case .failure(let error):
                    if error == .emptySearchData {
                        // LOG
                        if request.startIndex == 1 {
                            AnalyticsService.shared.logEvent(
                                .SUCCESS_SEARCH_PROGRAM_CONCERT,
                                parameters: [.PROGRAM_NAME: request.title,
                                             .PROGRAM_TOTAL_COUNT: "0"]
                            )
                        }
                        completion([], nil)
                    } else {
                        // LOG
                        AnalyticsService.shared.logEvent(
                            .FAIL_SEARCH_PROGRAM_CONCERT,
                            parameters: [.PROGRAM_NAME: request.title,
                                         .ERROR_CODE: error.code ?? "",
                                         .ERROR_MESSAGE: error.message ?? "",
                                         .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                        )
                        completion(nil, error)
                    }
                }
            })
    }
}
