import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController {
    var movie: Itune?
    
    let imageView = UIImageView()
    let trackLabel = UILabel()
    let artistLabel = UILabel()
    let priceLabel = UILabel()
    let countryLabel = UILabel()
    let genreLabel = UILabel()
    let watchButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        print("DetailViewController loaded with movie: \(movie?.trackName ?? "No movie")")
        setupUI()
        configureData()
    }
    
    func setupUI() {
    
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        
        [trackLabel, artistLabel, priceLabel, countryLabel, genreLabel].forEach {
            $0.numberOfLines = 0
            view.addSubview($0)
        }
        
       
        watchButton.setTitle("WATCH", for: .normal)
        watchButton.backgroundColor = .blue
        watchButton.setTitleColor(.white, for: .normal)
        watchButton.layer.cornerRadius = 10
        watchButton.addTarget(self, action: #selector(didTapWatchButton), for: .touchUpInside)
        view.addSubview(watchButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            trackLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            artistLabel.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: 10),
            artistLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            countryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            genreLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 10),
            genreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            watchButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 20),
            watchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchButton.widthAnchor.constraint(equalToConstant: 200),
            watchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureData() {
        guard let movie = movie else { return }
        
        trackLabel.text = "Track: \(movie.trackName ?? "Unknown")"
        artistLabel.text = "Artist: \(movie.artistName ?? "Unknown")"
        priceLabel.text = "Price: \(movie.trackPrice ?? 0.0)"
        countryLabel.text = "Country: \(movie.country ?? "Unknown")"
        genreLabel.text = "Primary: \(movie.primaryGenreName ?? "Unknown")"
        
        if let artworkUrlString = movie.artworkUrl100, let imageUrl = URL(string: artworkUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    @objc func didTapWatchButton() {
        guard let previewURLString = movie?.previewURL, let url = URL(string: previewURLString) else {
            print("URL không hợp lệ")
            return
        }
        
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}
