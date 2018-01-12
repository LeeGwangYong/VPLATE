//
//  TrimmingViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 12..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import PryntTrimmerView
import Photos

class TrimmingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var trimmerView: TrimmerView!
    var player: AVPlayer?
    var asset: AVAsset!
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?
    var duration: Double?
    var delegate: EditorViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor.darkGray
        guard let duration = duration else {return}
        trimmerView.minDuration = duration
        trimmerView.maxDuration = duration
        trimmerView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trimmerView.asset = asset
        
        addVideoPlayer(with: asset, playerView: playerView)
    }
    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TrimmingViewController.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        if let startTime = trimmerView.startTime {
            player?.seek(to: startTime)
        }
    }
    @IBAction func playAction(_ sender: UIButton) {
        guard let player = player else { return }
        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
        } else {
            player.pause()
            stopPlaybackTimeChecker()
        }
    }
    
    func startPlaybackTimeChecker() {
        
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval:0.1, target: self,
                                                        selector:
            #selector(TrimmingViewController.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }
    
    func trimVideo(asset: AVAsset?, startTime: CMTime?, endTime: CMTime?){
        guard let asset = asset else {return}
        guard let startTime = startTime else {return}
        guard let endTime = endTime else {return}
        
        let manager = FileManager.default
        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
        let mediaType = "mp4"
        
        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            print("Length: \(length)")
            var outputURL = documentDirectory.appendingPathComponent("output")
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                let name = "ExampleVideo"
                outputURL = outputURL.appendingPathComponent("\(name).mp4")
            } catch let error {
                print(error.localizedDescription)
            }
            
            _ = try? manager.removeItem(at: outputURL)
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4
            
            exportSession.timeRange = CMTimeRange(start: startTime, end: endTime)
            exportSession.exportAsynchronously {
                switch exportSession.status{
                case .completed:
                    print("Success URL : \(outputURL)")
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
                    }) { saved, error in
                        if saved {
                            print("Saved")
                            self.dismiss(animated: true, completion: {
                                self.player?.pause()
                                self.player = nil
                                self.delegate?.getAssetData(asset: asset, url: outputURL)
                            })
                        }
                    }
                //self.loadAsset(exportSession.asset)
                case .failed:
                    print("Failed")
                case .cancelled:
                    print("Cancelled")
                default: break
                }
            }
        }
        
    }
    
    func stopPlaybackTimeChecker() {
        
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }
    
    
    
    @objc func onPlaybackTimeChecker() {
        
        guard let startTime = trimmerView.startTime, let endTime = trimmerView.endTime, let player = player else {
            return
        }
        
        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)
        
        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            trimmerView.seek(to: startTime)
        }
    }
    
    @IBAction func trimAction(_ sender: Any) {
       
        trimVideo(asset: asset, startTime: trimmerView.startTime, endTime: trimmerView.endTime)
        
        //trimVideo(asset: asset, startTime: trimmerView.startTime, endTime: trimmerView.endTime)
    }
    
}

extension TrimmingViewController: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player?.play()
        startPlaybackTimeChecker()
    }
    
    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        let duration = (trimmerView.endTime! - trimmerView.startTime!).seconds
        print(duration)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
