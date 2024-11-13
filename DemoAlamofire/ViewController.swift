import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {
    
    let url =
        "https://api.openweathermap.org/data/2.5/weather?q=Hanoi&unit=metric&lang=vi&appid=e2029e14dfbb872bf7a67b3b8b03a3c5"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func fetchAPI() {
        AF.request(url, method: .get).responseData { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                let json = JSON(data)
                print(json)
                let weatherResponse = WeatherResponse(json: json)
                let weathers = weatherResponse.weathers
                print(weathers?.count ?? 0)
            case .failure(let error):
                print(error)
            }
        }
    }
}

