//
//  SearchHistorySettingVC.swift
//  UnivCam
//
//  Created by 이준상 on 2017. 8. 12..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Foundation
import UIKit

class SearchHistorySettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    let llb = ["검색결과저장", "검색결과삭제"]
    let rlb = ["저장하지않음", ""]
    let save = "저장하지 않음"
    let unsave = "저장함"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "SHeaderCell")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.5
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryCell", for: indexPath) as! SearchHistoryCell
        
        cell.leftLabel.text! = llb[indexPath.row]
        cell.rightLabel.text! = rlb[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let SearchHistoryDeleteAlert = UIAlertController()
            let history_nondelete = UIAlertAction(title: "저장", style: .default, handler: { (action)->Void in
                print("저장")})
            let history_delete = UIAlertAction(title: "저장하지않음", style: .default, handler: { (action)->Void in
                print("저장하지않음")})
            let history_cancel = UIAlertAction(title: "취소", style: .cancel, handler: { (action)->Void in
                print("저장하지않음")})
            SearchHistoryDeleteAlert.addAction(history_nondelete)
            SearchHistoryDeleteAlert.addAction(history_delete)
            SearchHistoryDeleteAlert.addAction(history_cancel)
            SearchHistoryDeleteAlert.view.tintColor = UIColor(hex: 0x515859)
            self.present(SearchHistoryDeleteAlert, animated: true, completion: nil)
            break
        case 1:
            let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SearchDeleteViewController") as! SearchDeleteViewController
            self.present(vc, animated: true, completion: nil)
            break
        default:
            break
        }
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}

