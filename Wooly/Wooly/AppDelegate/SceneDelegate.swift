//
//  SceneDelegate.swift
//  Wooly
//
//  Created by 이예슬 on 2021/04/02.
//

import UIKit
import AVFoundation
import AudioToolbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("Resign")
        if let remainingTime = Alarms.shared.nextAlarm?.remainingMinute {
            var second = Calendar.current.dateComponents([.second], from: Date()).second!
            second = 60 - second + (remainingTime-1)*60 + 3
            appDelegate.playSound("bell", time: second)
        }
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    

    func makePlayer(bpm: Float, beatCount: Int) -> AVPlayer? {
        let path = Bundle.main.path(forResource: "example.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        let drumUrl = url
        let beatDuration = CMTime(seconds: Double(bpm), preferredTimescale: 1)
        
        let composition = AVMutableComposition()
        guard let track = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return nil
        }
        
        let drumAsset = AVAsset(url: drumUrl)
        let drumDuration = drumAsset.duration
        let drumTimeRange = CMTimeRange(start: CMTime.zero, duration: drumDuration)
        
        let silenceDuration = beatDuration - drumDuration
        
        var prevBeatEnd = CMTime.zero
        
        for deatIndex in 0 ..< beatCount {
            let drumTargetRange = CMTimeRange(start: prevBeatEnd, duration: drumDuration)
            let drumSegment = AVCompositionTrackSegment(url: drumUrl, trackID: track.trackID, sourceTimeRange: drumTimeRange, targetTimeRange: drumTargetRange)
            track.segments.append(drumSegment)
            
            if deatIndex == 0 {
                prevBeatEnd = prevBeatEnd + drumDuration
            } else {
                let silenceTargetRange = CMTimeRange(start: prevBeatEnd, duration: silenceDuration)
                track.insertEmptyTimeRange(silenceTargetRange)
                prevBeatEnd = prevBeatEnd + silenceDuration + drumDuration
            }
        }
        
        try! track.validateSegments(track.segments)
        
        let playerItem = AVPlayerItem(asset: composition)
        
        return AVPlayer(playerItem: playerItem)
    }
    func playSound(_ soundName: String, time: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var audioPlayer = appDelegate.audioPlayer
        //vibrate phone first
        AudioServicesPlaySystemSound(1104)
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
                                              nil,
                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                                              },
                                              nil)
        
        let path = Bundle.main.path(forResource: "example.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
            return
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        
        //negative number means loop infinity
        audioPlayer!.volume = 1.0
        audioPlayer!.numberOfLoops = 4
        //        audioPlayer!.play()
//        audioPlayer!.play(atTime:(audioPlayer?.deviceCurrentTime ?? 0) + Double(time))
//        audioPlayer!.stop()
        print("played")
    }
}

