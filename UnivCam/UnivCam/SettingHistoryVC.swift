//
//  SearchHistorySettingVC.swift
//  UnivCam
//
//  Created by 이준상 on 2017. 8. 12..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Foundation
import UIKit

enum searchTitles : String {
    case save = "저장"
    case unsave = "저장하지않음"
    case save_result = "검색결과저장"
    case delete_result = "검색결과삭제"
    case result = "검색결과"
    case cancel = "취소"
}

class SearchHistorySettingVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            self.tableView.register(Cells.setting.nib, forCellReuseIdentifier: Cells.setting.identifier)
            self.tableView.register(Cells.setting_header.nib, forCellReuseIdentifier: Cells.setting_header.identifier)
        }
    }
    @IBOutlet weak var mainTitle: UILabel!
    
    let cell_title : [searchTitles] = [.save_result, .delete_result]
    let decide_save : [searchTitles] = [.save, .unsave]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 22)
            break
        case 1: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 26)
            break
        case 2: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 30)
            break
        case 3: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 33)
            break
        default:
            mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 30)
            break
        }
    }
    
}
extension SearchHistorySettingVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cell_title.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! SettingHeaderCell
        headerView.header_title.text = searchTitles.result.rawValue
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let value: CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: value = 34.56
            break
        case 1: value = 40.896
            break
        case 2: value = 48
            break
        case 3: value = 52.944
            break
        default:
            value = 48
            break
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let value: CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: value = 34.56
            break
        case 1: value = 40.896
            break
        case 2: value = 48
            break
        case 3: value = 52.944
            break
        default:
            value = 48
            break
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hcell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: hcell.setting_title.font = UIFont(name: hcell.setting_title.font.fontName, size: 12)
        hcell.version_info.font = UIFont(name: hcell.version_info.font.fontName, size: 12)
            break
        case 1: hcell.setting_title.font = UIFont(name: hcell.setting_title.font.fontName, size: 14)
        hcell.version_info.font = UIFont(name: hcell.version_info.font.fontName, size: 14)
            break
        case 2: hcell.setting_title.font = UIFont(name: hcell.setting_title.font.fontName, size: 16)
        hcell.version_info.font = UIFont(name: hcell.version_info.font.fontName, size: 16)
            break
        case 3: hcell.setting_title.font = UIFont(name: hcell.setting_title.font.fontName, size: 18)
        hcell.version_info.font = UIFont(name: hcell.version_info.font.fontName, size: 18)
            break
        default:
            hcell.setting_title.font = UIFont(name: hcell.setting_title.font.fontName, size: 16)
            hcell.version_info.font = UIFont(name: hcell.version_info.font.fontName, size: 16)
            break
        }
        switch indexPath.row {
        case 0:
            hcell.setting_title.text = cell_title[indexPath.row].rawValue
            hcell.version_info.text = searchTitles.save.rawValue
            break
        default:
            hcell.setting_title.text = cell_title[indexPath.row].rawValue
            hcell.version_info.isHidden = true
            break
        }
        return hcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let SearchHistoryDeleteAlert = UIAlertController()
            let history_nondelete = UIAlertAction(title: searchTitles.save.rawValue, style: .default, handler: { (action)->Void in
                print("저장")})
            let history_delete = UIAlertAction(title: searchTitles.unsave.rawValue, style: .default, handler: { (action)->Void in
                print("저장하지않음")})
            let history_cancel = UIAlertAction(title: searchTitles.cancel.rawValue, style: .cancel, handler: { (action)->Void in
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

