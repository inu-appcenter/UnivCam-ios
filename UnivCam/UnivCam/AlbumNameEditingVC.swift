//
//  AlbumNameEditingVC.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 20..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift

class AlbumNameEditingVC: UIViewController {

    @IBOutlet var albumTitleTextField: UITextField!
    @IBOutlet var deleteTextButton: UIButton! {
        didSet {
            deleteTextButton.addTarget(self,
                                   action: #selector(deleteText),
                                       for: .touchUpInside)
        }
    }
    @IBOutlet var renameAlbumButton: UIBarButtonItem! {
        didSet {
            renameAlbumButton.target = self
            renameAlbumButton.action = #selector(renameAlbum)
        }
    }
    
    lazy var backButton : UIButton = {
        let btn : UIButton = .init(type: .system)
        btn.setImage(
            Assets.leftNavigationItem.image,
            for: .normal)
        btn.setTitle("  뒤로가기", for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(unwindToHome), for: .touchUpInside)
        return btn
    }()
    
    
    var album : Album?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        albumTitleTextField.text = album?.title
        albumTitleTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        // Do any additional setup after loading the view.
    }

    func unwindToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteText() { 
        albumTitleTextField.text?.removeAll()
    }
    func renameAlbum() {
        guard let title = albumTitleTextField.text, !(albumTitleTextField.text?.isEmpty)! else { return }
        let realm = try! Realm()
        do {
            try realm.write {
                album?.title.removeAll()
                album?.title = title
            }
        } catch {
            
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

}
