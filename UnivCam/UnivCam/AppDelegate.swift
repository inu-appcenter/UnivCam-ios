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
        
        var ojeCtBool : ObjCBool = true
        let isDirExist = FileManager.default.fileExists(atPath: UnivCamAPI.baseURLString, isDirectory: &ojeCtBool)
        if !isDirExist {
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: UnivCamAPI.baseURLString), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("에러")
            }
        } else {
            print("이미 존재하는 폴더입니다.")
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

