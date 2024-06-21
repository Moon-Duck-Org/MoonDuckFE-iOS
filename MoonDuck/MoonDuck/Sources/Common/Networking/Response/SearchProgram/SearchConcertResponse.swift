//
//  SearchConcertResponse.swift
//  MoonDuck
//
//  Created by suni on 6/17/24.
//

import Foundation

struct SearchConcertResponse: Codable {
    var culturalEventInfo: CulturalEventInfo
    
    struct CulturalEventInfo: Codable {
        var listTotalCount: Int
        var result: Result
        var row: [Row]
        
        enum CodingKeys: String, CodingKey {
            case row
            case listTotalCount = "list_total_count"
            case result = "RESULT"
        }
    }
    
    struct Result: Codable {
        var code: String
        var message: String
        
        enum CodingKeys: String, CodingKey {
            case code = "CODE"
            case message = "MESSAGE"
        }
    }
    
    struct Row: Codable {
        var codename: String?
        var guname: String?
        var title: String?
        var date: String?
        var place: String?
        var orgName: String?
        var useTrgt: String?
        var userFee: String?
        var player: String?
        var program: String?
        var etcDesc: String?
        var orgLink: String?
        var mainImg: String?
        var rgstdate: String?
        var ticket: String?
        var strtDate: String?
        var endDate: String?
        var themcode: String?
        var lot: String?
        var lat: String?
        var isFree: String?
        var hmpgAddr: String?
        
        enum CodingKeys: String, CodingKey {
            case codename = "CODENAME"
            case guname = "GUNAME"
            case title = "TITLE"
            case date = "DATE"
            case place = "PLACE"
            case orgName = "ORG_NAME"
            case useTrgt = "USE_TRGT"
            case userFee = "USE_FEE"
            case player = "PLAYER"
            case program = "PROGRAM"
            case etcDesc = "ETC_DESC"
            case orgLink = "ORG_LINK"
            case mainImg = "MAIN_IMG"
            case rgstdate = "RGSTDATE"
            case ticket = "TICKET"
            case strtDate = "STRTDATE"
            case endDate = "END_DATE"
            case themcode = "THEMECODE"
            case lot = "LOT"
            case lat = "LAT"
            case isFree = "IS_FREE"
            case hmpgAddr = "HMPG_ADDR"
        }
        
        func toDomain() -> Program {
            
            let title: String = title ?? ""
            let genre: String = codename ?? ""
            let palce: String = orgName ?? ""
            
            return Program(category: .concert,
                           title: title,
                           genre: genre,
                           place: palce)
        }
    }
}

// - deleted code : 이전 Open API에 사용된 XML Parser
// struct SearchConcertResponse {
//    enum TagType: String {
//        case dbs, prfnm, prfpdfrom, fcltynm, area, genrenm, prfstate, none, channel
//        case dbItem = "db"
//    }
//    
//    var prfnm: String? = nil
//    var prfpdfrom: String? = nil
//    var fcltynm: String? = nil
//    var area: String? = nil
//    var genrenm: String? = nil
//    var prfstate: String? = nil
//    
//    func toDomain() -> Program {
//        let title = prfnm ?? ""
//        
//        return Program(category: .concert,
//                       title: title,
//                       genre: genrenm,
//                       place: fcltynm)
//    }
// }
// protocol SearchConcertXMLParserDelegate {
//    func xmlParser(_ parser: SearchConcertXMLParser, didSuccess resList: [SearchConcertResponse])
// }
//
//class SearchConcertXMLParser: NSObject, XMLParserDelegate {
//    
//    var delegate: SearchConcertXMLParserDelegate?
//    
//    private var isLock = false
//    private var currentTagType: SearchConcertResponse.TagType = .none
//    private var tempResModel: SearchConcertResponse?
//    private var resList: [SearchConcertResponse] = []
//    
//    func parse(string: String) {
//        if let data = string.data(using: .utf8) {
//            let parser = XMLParser(data: data)
//            parser.delegate = self
//            parser.parse()
//        }
//    }
//    
//    // 태그 시작
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
//        
//        let tagType = SearchConcertResponse.TagType(rawValue: elementName)
//        
//        switch tagType {
//        case .dbItem:
//            isLock = true
//            tempResModel = SearchConcertResponse()
//            currentTagType = .dbItem
//        default:
//            currentTagType = tagType ?? .none
//        }
//    }
//    
//    // 태그 끝
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        let tagType = SearchConcertResponse.TagType(rawValue: elementName)
//        
//        if tagType == .dbItem {
//            guard let tempResModel = tempResModel else {
//                return
//            }
//            resList.append(tempResModel)
//            isLock = false
//        } else if tagType == .dbs {
//            parser.abortParsing()
//            // TODO: delegate 연결
//            delegate?.xmlParser(self, didSuccess: resList)
//        }
//    }
//    
//    // 태그 사이 문자열
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        let str = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        if isLock, str.isNotEmpty {
//            switch currentTagType {
//            case .prfnm:
//                tempResModel?.prfnm = str
//            case .prfpdfrom:
//                tempResModel?.prfpdfrom = str
//            case .fcltynm:
//                tempResModel?.fcltynm = str
//            case .area:
//                tempResModel?.area = str
//            case .genrenm:
//                tempResModel?.genrenm = str
//            case .prfstate:
//                tempResModel?.prfstate = str
//            default:
//                break
//            }
//        }
//    }
// }
