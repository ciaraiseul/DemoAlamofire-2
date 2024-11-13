import Foundation
import SwiftyJSON

class ItuneObject {
    let resultCount: Int?
    let results: [Itune]?
    
    required public init(json: JSON) {
        resultCount = json["resultCount"].intValue
        results = json["results"].arrayValue.compactMap { Itune(json: $0) }
    }
}

class Itune {
    let artistName: String?
    let trackCount: Int?
    let releaseDate: String?
    let primaryGenreName: String?
    let previewURL: String?
    let description: String?
    let trackID: Int?
    let trackName: String?
    let country: String?
    let trackViewURL: String?
    let artworkUrl30: String?
    let artworkUrl100: String?
    let trackPrice: Double?
    let currency: String?
    let collectionPrice: Double?
    
    required public init?(json: JSON) {
        artistName = json["artistName"].string
        trackCount = json["trackCount"].int
        releaseDate = json["releaseDate"].stringValue
        primaryGenreName = json["primaryGenreName"].string
        previewURL = json["previewUrl"].string
        description = json["description"].string
        trackID = json["trackId"].int
        trackName = json["trackName"].string
        country = json["country"].string
        trackViewURL = json["trackViewUrl"].string
        artworkUrl30 = json["artworkUrl30"].string
        artworkUrl100 = json["artworkUrl100"].string  
        trackPrice = json["trackPrice"].double
        currency = json["currency"].string
        collectionPrice = json["collectionPrice"].double
    }
}
