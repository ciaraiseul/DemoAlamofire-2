import SwiftyJSON
import Alamofire

class ManagerAPI {
    static let shared = ManagerAPI()
    
    func getItune(_ searchText: String,
                  completion: @escaping (([Itune]) -> Void),
                  failure: @escaping ((String) -> Void)) {
        let url =
        "https://itunes.apple.com/search?term=%@&limit=10"
        let urlString = String(format: url, searchText)
        
        AF.request(urlString, method: .get).responseData { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                let json = JSON(data)
                let ituneObjc = ItuneObject(json: json)
                completion(ituneObjc.results ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
}
