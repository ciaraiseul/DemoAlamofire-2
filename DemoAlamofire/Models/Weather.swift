import Foundation
import SwiftyJSON

class Coordinates {
    var longitude: Double?
    var latitude: Double?
    
    required public init?(json: JSON) {
        longitude = json["lon"].doubleValue
        latitude = json["lat"].doubleValue
    }
}

class Weather {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
    
    required public init?(json: JSON) {
        id = json["id"].intValue
        main = json["main"].stringValue
        description = json["description"].stringValue
        icon = json["icon"].stringValue
    }
}

class WeatherResponse {
    var coordinates: Coordinates?
    var weathers: [Weather]?
    
    required public init(json: JSON) {
        coordinates = Coordinates(json: json["coord"])
        weathers = json["weather"].arrayValue.map { Weather(json: $0)!}
    }
}

