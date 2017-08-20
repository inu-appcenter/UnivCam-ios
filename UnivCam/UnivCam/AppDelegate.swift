//
//  AppDelegate.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let albums: Results<Album> = {
        let realm = try! Realm()
        return realm.objects(Album.self)
    }()
    
    var keyWindow: UIWindow {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }
    class func getDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureAppearance()
        createLocalFolder()
        
        return true
    }
    func createLocalFolder() {
        // 다큐먼트 + /Univcam 경로
        // Root folder -> sub folders
        let pathURL = URL(fileURLWithPath: UnivCamAPI.baseURLString)
        var ojeCtBool : ObjCBool = true
        let isDirExist = FileManager.default.fileExists(atPath: UnivCamAPI.baseURLString,
                                                        isDirectory: &ojeCtBool)
        
        if !isDirExist {
            do {
                try FileManager.default.createDirectory(at: pathURL,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print("파일 쓰기 에러")
            }
        } else {
            print("존재 하지않는 경로")
        }
    }

    func configureAppearance() {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = Palette.navigationTint.color
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
    }
}

