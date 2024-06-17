//
//  SearchConcertResponse.swift
//  MoonDuck
//
//  Created by suni on 6/17/24.
//

import Foundation

struct SearchConcertResponse {
    enum TagType: String {
        case dbs, prfnm, prfpdfrom, fcltynm, area, genrenm, prfstate, none, channel
        case dbItem = "db"
    }
    
    var prfnm: String? = nil
    var prfpdfrom: String? = nil
    var fcltynm: String? = nil
    var area: String? = nil
    var genrenm: String? = nil
    var prfstate: String? = nil
    
    func toDomain() -> ReviewProgram {
        let title = prfnm ?? ""
        
        return ReviewProgram(programType: .concert,
                             title: title,
                             genre: genrenm,
                             place: fcltynm)
    }
}

protocol SearchConcertXMLParserDelegate {
    func xmlParser(_ parser: SearchConcertXMLParser, didSuccess resList: [SearchConcertResponse])
}

class SearchConcertXMLParser: NSObject, XMLParserDelegate {
    
    var delegate: SearchConcertXMLParserDelegate?
    
    private var isLock = false
    private var currentTagType: SearchConcertResponse.TagType = .none
    private var tempResModel: SearchConcertResponse?
    private var resList: [SearchConcertResponse] = []
    
    func parse(string: String) {
        if let data = string.data(using: .utf8) {
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
    }
    
    // 태그 시작
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        
        let tagType = SearchConcertResponse.TagType(rawValue: elementName)
        
        switch tagType {
        case .dbItem:
            isLock = true
            tempResModel = SearchConcertResponse()
            currentTagType = .dbItem
        default:
            currentTagType = tagType ?? .none
        }
    }
    
    // 태그 끝
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let tagType = SearchConcertResponse.TagType(rawValue: elementName)
        
        if tagType == .dbItem {
            guard let tempResModel = tempResModel else {
                return
            }
            resList.append(tempResModel)
            isLock = false
        } else if tagType == .dbs {
            parser.abortParsing()
            // TODO: delegate 연결
            delegate?.xmlParser(self, didSuccess: resList)
        }
    }
    
    // 태그 사이 문자열
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if isLock, str.isNotEmpty {
            switch currentTagType {
            case .prfnm:
                tempResModel?.prfnm = str
            case .prfpdfrom:
                tempResModel?.prfpdfrom = str
            case .fcltynm:
                tempResModel?.fcltynm = str
            case .area:
                tempResModel?.area = str
            case .genrenm:
                tempResModel?.genrenm = str
            case .prfstate:
                tempResModel?.prfstate = str
            default:
                break
            }
        }
    }
}
