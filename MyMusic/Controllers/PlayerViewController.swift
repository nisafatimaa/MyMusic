import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet var holder : UIView!
    
    public var position : Int = 0
    public var songs = [SongModel]()
    var player : AVAudioPlayer?
    let pauseButton = UIButton()
    
    //image
    private let albumImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //labels
    private let songNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
    func configure(){
        let song = songs[position]
        
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else { return }
            
            player = try AVAudioPlayer(contentsOf: URL(string : urlString)!)
            
            guard let player = player else { return }
            
            player.volume = 0.5
            player.play()
        }
        
        catch {
            print("error occured")
        }
        
        //setting image
        albumImage.frame = CGRect(x: 10,
                                  y: 10,
                                  width: holder.frame.size.width-20,
                                  height: holder.frame.size.width-20)
        
        albumImage.image = UIImage(named: song.imageName)
        holder.addSubview(albumImage)
        
        //labels
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImage.frame.size.height + 10,
                                     width: holder.frame.size.width-20,
                                     height: 70)
        
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImage.frame.size.height + 10 + 50,
                                      width: holder.frame.size.width-20,
                                      height: 70)
        
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImage.frame.size.height + 10 + 100,
                                       width: holder.frame.size.width-20,
                                       height: 70)
        
        songNameLabel.text = song.songName
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(albumNameLabel)
        holder.addSubview(artistNameLabel)
        
        //buttons
        let forwardButton = UIButton()
        let backButton = UIButton()
        
        let yposition = artistNameLabel.frame.origin.y + 70 + 20
        let size : CGFloat = 68
        
        pauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
                                   y: yposition,
                                   width: size,
                                   height: size)
        forwardButton.frame = CGRect(x: holder.frame.size.width - size - 20,
                                   y: yposition,
                                   width: size,
                                   height: size)
        backButton.frame = CGRect(x: 20,
                                   y: yposition,
                                   width: size,
                                   height: size)
        
        pauseButton.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        pauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        forwardButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        pauseButton.tintColor = .black
        forwardButton.tintColor = .black
        backButton.tintColor = .black
        
        holder.addSubview(pauseButton)
        holder.addSubview(forwardButton)
        holder.addSubview(backButton)
        
        //slider
        let slider = UISlider(frame: CGRect(x: 20,
                                            y: holder.frame.size.height-60,
                                            width: holder.frame.size.width - 40,
                                            height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder.addSubview(slider)
    }
    
    @objc func didSlideSlider(_ slider : UISlider){
        let value = slider.value
        player?.volume = value
    }
    
    @objc func didTapPauseButton(){
        if player?.isPlaying == true {
            player?.pause()
            pauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }else{
            player?.play()
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func didTapForwardButton(){
        if position < (songs.count - 1){
            position = position + 1
            player?.stop()
            for subviews in holder.subviews {
                subviews.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapBackButton(){
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            for subviews in holder.subviews {
                subviews.removeFromSuperview()
            }
            configure()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
}
