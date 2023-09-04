//
//  FileDetailsTVCell.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 01.09.2023.
//

import UIKit
import AVFoundation

protocol FileDetailsDelegate: AnyObject {
    func startVideoDownload(withPath path: String)
}

class FileDetailsTVCell: BaseTVCell {
    
    
    // MARK: - IBOutlets -
    
    // Image Views
    @IBOutlet private weak var mediaImageView: UIImageView!
    @IBOutlet private weak var videoMarkImageView: UIImageView!
    
    // Player
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    
    @IBOutlet private weak var goForwardButton: UIButton!
    @IBOutlet private weak var goBackwardButton: UIButton!
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var playerStackView: UIStackView!
        
    // Activity Indicator
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    
    // MARK: - Properties -
    
    private var mediaSize = CGRect()
    private var mediaFile: MediaFile?
    private weak var delegate: FileDetailsDelegate?
        
    // Player
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playbackTimeObserver: Any?
    
    
    // MARK: - Lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil

        // Show the play button again
        playButton.isHidden = false
        videoMarkImageView.isHidden = false
    }
    
    override class var cellIdentifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
    deinit {
        if let observer = playbackTimeObserver {
            player?.removeTimeObserver(observer)
            playbackTimeObserver = nil
        }
    }
    
    
    // MARK: - Public Methods -
    
    func configureCell(_ mediaFile: MediaFile?, delegate: FileDetailsDelegate) {
        self.mediaFile = mediaFile
        self.delegate = delegate
        //
        configureUI()
    }
    
    
    // MARK: - Private Methods -
    
    private func configureUI() {
        guard let mediaFile = mediaFile else { return }
                
        switch mediaFile.mediaType {
        case .photo:
            configureUIForImage(mediaFile)
            
        case .video:
            configureUIForVideo(mediaFile)
        }
    }
    
    private func configureUIForImage(_ mediaFile: MediaFile) {
        showAndHideVideoPlayerUI(true)
        
        if let image = mediaFile.image {
            mediaImageView.image = image
        }
    }
    
    private func configureUIForVideo(_ mediaFile: MediaFile) {
        showAndHideVideoPlayerUI(false)
        
        if let image = mediaFile.image {
            mediaImageView.image = image
        }
        
        activityIndicator.stopAnimating()
                    
        if let videoURL = mediaFile.videoURL {
            // If video is ready to play, set up the player
            setupVideoPlayer(videoURL)
                
            playButton.isHidden = true
            videoMarkImageView.isHidden = true
        } else {
            // If video is not ready, show the play button
            playButton.isHidden = false
            videoMarkImageView.isHidden = false
        }
    }
          
    private func showAndHideVideoPlayerUI(_ needToHide: Bool) {
        playButton.isHidden = needToHide
        playPauseButton.isHidden = needToHide
        videoMarkImageView.isHidden = needToHide
        goForwardButton.isHidden = needToHide
        goBackwardButton.isHidden = needToHide
        progressView.isHidden = needToHide
        activityIndicator.isHidden = needToHide
    }
    
    private func setupVideoPlayer(_ videoURL: URL) {

        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)            
        
        if let playerLayer = playerLayer {
            playerLayer.frame = self.frame
            playerLayer.videoGravity = .resizeAspectFill
            mediaImageView.layer.addSublayer(playerLayer)
            //
            addProgressObserver()
        }

        
        // Observer to handle video playback completion
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.playerDidFinishPlaying()
        }
    }
        
    private func addProgressObserver() {
        guard let player = player else { return }
        
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        playbackTimeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
                        
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(seconds: 1, preferredTimescale: 1))
            let currentTime = CMTimeGetSeconds(time)
            
            let progress = Float(currentTime / duration)
            self.progressView.progress = progress
        }
    }
        
    @objc private func playerDidFinishPlaying() {
        guard let player = player else { return }
        player.seek(to: .zero)
        if #available(iOS 13.0, *) {
            playPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    // MARK: - IBActions -
    
    @IBAction private func playAction(_ sender: UIButton) {
        guard let mediaFile = mediaFile, let path = mediaFile.path else { return }
        sender.isHidden = true
              
        // Start Activity Indicator
        activityIndicator.startAnimating()
        videoMarkImageView.isHidden = true
              
        // Notify the delegate to start video download
        delegate?.startVideoDownload(withPath: path)
    }
    
    @IBAction private func playPauseAction(_ sender: UIButton) {
        guard let player = player else { return }
        sender.bounce()
        
        if player.rate == 0 {
            // Player is paused, start playback
            player.play()
            if #available(iOS 13.0, *) {
                sender.setImage(UIImage(systemName: "pause"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Player is playing, pause it
            player.pause()
            if #available(iOS 13.0, *) {
                sender.setImage(UIImage(systemName: "play"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBAction private func goForwardAction(_ sender: UIButton) {
        sender.bounce()
        //
        let currentTime = CMTimeGetSeconds(player?.currentTime() ?? CMTime.zero)
        let newTime = currentTime + 15.0
        let time = CMTimeMakeWithSeconds(newTime, preferredTimescale: 1)
        //
        player?.seek(to: time)
    }
    
    @IBAction private func goBackwardAction(_ sender: UIButton) {
        sender.bounce()
        //
        let currentTime = CMTimeGetSeconds(player?.currentTime() ?? CMTime.zero)
        let newTime = currentTime - 15.0
        let time = CMTimeMakeWithSeconds(newTime, preferredTimescale: 1)
        //
        player?.seek(to: time)
    }
}
