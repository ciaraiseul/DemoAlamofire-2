import UIKit
import SwiftyJSON
import Alamofire

class SearchItuneViewController: UIViewController {
    let searchBar = UISearchBar()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    var itunes: [Itune] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.delegate = self
        searchBar.placeholder = "Search for movies..."
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
      
        setupConstraints()
    }
    
    func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchItune(searchText: String) {
        let url = "https://itunes.apple.com/search?term=%@&media=movie&limit=20"
        let urlString = String(format: url, searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        AF.request(urlString, method: .get).responseData { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                let json = JSON(data)
                let ituneResponse = ItuneObject(json: json)
                self.itunes = ituneResponse.results ?? []
                self.collectionView.reloadData()
            case .failure(let error):
                print("API Error: \(error)")
            }
        }
    }
}

extension SearchItuneViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchItune(searchText: searchText)
    }
}

extension SearchItuneViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itunes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let ituneItem = itunes[indexPath.row]
        
        cell.titleLabel.text = ituneItem.trackName
        if let artworkUrlString = ituneItem.artworkUrl100, let imageUrl = URL(string: artworkUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = itunes[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.movie = movie
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchItuneViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let padding: CGFloat = 8
        let totalPadding = padding * (itemsPerRow + 1)
        let individualWidth = (view.frame.width - totalPadding) / itemsPerRow
        return CGSize(width: individualWidth, height: individualWidth * 1.5)
    }
}
