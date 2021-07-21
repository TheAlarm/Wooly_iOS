//
//  AppDelegate.swift
//  Wooly
//
//  Created by 이예슬 on 2021/04/02.
//

import UIKit
import AudioToolbox
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer?
    let audioSession = AVAudioSession.sharedInstance()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.'
        Scheduler.shared.requestAuth()
        Scheduler.shared.center.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification){
//
//
//    }
    func playSound(_ soundName: String){
        //vibrate phone first
        AudioServicesPlaySystemSound(SystemSoundID(1104))
        AudioServicesPlaySystemSound(1104)
        AudioServicesPlaySystemSound(1104)
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
            nil,
            { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            },
            nil)
        do {
                    try audioSession.setCategory(
                        AVAudioSession.Category.playAndRecord)
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
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
        audioPlayer!.numberOfLoops = 4
        audioPlayer!.play()
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate{
    //앱이 foreground상태 일 때, 알림이 온 경우 어떻게 표현할 것인지 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list,.sound,.banner])
    }
    // push를 눌렀을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //알람이 Back에서 왔고 진동이면 avplayer
//        playSound("bell")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                return
            }
        let vc = UIViewController()
        vc.view.backgroundColor = .black
        rootViewController.present(vc,animated: true)
            // change your view controller here
//            rootViewController = UIViewController()
    }
}

extension UIApplication {

func currentTopViewController(controller: UIViewController? = UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.first?.windows.filter{$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {

if let navigationController = controller as? UINavigationController {
       return currentTopViewController(controller: navigationController.visibleViewController)
   }
   if let tabbarController = controller as? UITabBarController {
       if let selected = tabbarController.selectedViewController {
           return currentTopViewController(controller: selected)
       }
   }
   if let presented = controller?.presentedViewController {
       return currentTopViewController(controller: presented)
   }
   return controller

}

}

