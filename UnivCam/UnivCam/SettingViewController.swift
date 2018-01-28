//
//  SettingViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

enum SettingTitle : String {
    case option = "환경설정"
    case univcam = "유니브캠"
    case details = "세부사항"
    case search_results = "검색결과관리"
    case permission_setting = "접근권한설정"
    case share_univcam = "유니브캠 공유하기"
    case evaluate_univcam = "유니브캠 평가하기"
    case version_info = "버전정보"
    case developer_github = "개발자 깃허브"
    case designer_info = "디자이너 정보"
    case opensource_licence = "Open Source Licence"
    case share_url = "https://www.facebook.com/UIAppCenter/?fref=ts"
    case share_text = "앨범 및 사진 정리 어플리케이션 UnivCam으로, 더욱 효율적이고 생산적인 앨범 정리를 해보세요!\nhttps://www.facebook.com/UIAppCenter/?fref=ts"
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView! {
        didSet {
            self.settingTableView.delegate = self
            self.settingTableView.dataSource = self
            self.settingTableView.register(Cells.setting.nib,
                                           forCellReuseIdentifier: Cells.setting.identifier)
            self.settingTableView.register(Cells.setting_header.nib,
                                           forCellReuseIdentifier: Cells.setting_header.identifier)
        }
    }
    @IBOutlet var topBorderView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    
    let index_list : [SettingTitle] = [.option, .univcam, .details]
    var title_number : [Int] {
        get {
            return [titles_section1.count, titles_section2.count, titles_section3.count]
        }
    }
//    let titles_section1 : [SettingTitle] = [.search_results, .permission_setting]
    let titles_section1 : [SettingTitle] = [.permission_setting]
    let titles_section2 : [SettingTitle] = [.share_univcam, .evaluate_univcam]
    let titles_section3 : [SettingTitle] = [.version_info, .designer_info, .developer_github, .opensource_licence]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: settingLabel.font = UIFont(name: settingLabel.font.fontName, size: 22)
            break
        case 1: settingLabel.font = UIFont(name: settingLabel.font.fontName, size: 26)
            break
        case 2: settingLabel.font = UIFont(name: settingLabel.font.fontName, size: 30)
            break
        case 3: settingLabel.font = UIFont(name: settingLabel.font.fontName, size: 33)
            break
        default:
            settingLabel.font = UIFont(name: settingLabel.font.fontName, size: 30)
            break
        }
    }
}

extension SettingViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return index_list.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: Cells.setting_header.identifier) as! SettingHeaderCell
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: header_cell.header_title.font = UIFont(name: header_cell.header_title.font.fontName, size: 9)
            break
        case 1: header_cell.header_title.font = UIFont(name: header_cell.header_title.font.fontName, size: 10)
            break
        case 2: header_cell.header_title.font = UIFont(name: header_cell.header_title.font.fontName, size: 12)
            break
        case 3: header_cell.header_title.font = UIFont(name: header_cell.header_title.font.fontName, size: 13)
            break
        default:
            header_cell.header_title.font = UIFont(name: header_cell.header_title.font.fontName, size: 13)
            break
        }
        header_cell.header_title.text = index_list[section].rawValue
        return header_cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title_number[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yPosition = scrollView.contentOffset.y
        
        let sectionHeaderHeight: CGFloat = settingTableView.sectionHeaderHeight
        if yPosition <= sectionHeaderHeight && yPosition >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-yPosition, 0, 0, 0)
        }
        else if yPosition >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
        topBorderView.isHidden = yPosition > 0 ? false : true
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return UITableViewCell()}
        let setting_cell = tableView.dequeueReusableCell(withIdentifier: Cells.setting.identifier) as! SettingCell
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: setting_cell.setting_title.font = UIFont(name: setting_cell.setting_title.font.fontName, size: 12)
        
        setting_cell.version_info.font = UIFont(name: setting_cell.version_info.font.fontName, size: 12)
            break
        case 1: setting_cell.setting_title.font = UIFont(name: setting_cell.setting_title.font.fontName, size: 14)
        setting_cell.version_info.font = UIFont(name: setting_cell.version_info.font.fontName, size: 14)
            break
        case 2: setting_cell.setting_title.font = UIFont(name: setting_cell.setting_title.font.fontName, size: 16)
        setting_cell.version_info.font = UIFont(name: setting_cell.version_info.font.fontName, size: 16)
            break
        case 3: setting_cell.setting_title.font = UIFont(name: setting_cell.setting_title.font.fontName, size: 18)
        setting_cell.version_info.font = UIFont(name: setting_cell.version_info.font.fontName, size: 18)
            break
        default:
            setting_cell.setting_title.font = UIFont(name: setting_cell.setting_title.font.fontName, size: 16)
            setting_cell.version_info.font = UIFont(name: settingLabel.font.fontName, size: 16)
            break
        }
        switch indexPath.section {
        case 0:
            setting_cell.version_info.isHidden = true
            setting_cell.setting_title.text = titles_section1[indexPath.row].rawValue
            break
        case 1:
            setting_cell.version_info.isHidden = true
            setting_cell.setting_title.text = titles_section2[indexPath.row].rawValue
            break
        case 2:
            switch indexPath.row {
            case 0:
                setting_cell.version_info.text = appVersion
                setting_cell.setting_title.text = titles_section3[indexPath.row].rawValue
                break
            default:
                setting_cell.version_info.isHidden = true
                setting_cell.setting_title.text = titles_section3[indexPath.row].rawValue
                break
            }
            break
        default:
            break
        }
        
        
        return setting_cell
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let value: CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: value = 28.44
            break
        case 1: value = 33.654
            break
        case 2: value = 39.5
            break
        case 3: value = 43.5685
            break
        default:
            value = 39.5
            break
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let value: CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: value = 11.52
            break
        case 1: value = 13.632
            break
        case 2: value = 16
            break
        case 3: value = 17.648
            break
        default:
            value = 16
            break
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(indexPath.section)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
//                let Sevc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SearchHistorySettingVC") as! SearchHistorySettingVC
//                self.show(Sevc, sender: Any?)
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                break
            case 1:
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                break
            default:
                break
            }
            break
        case 1:
            switch indexPath.row {
            case 0:
                let appShare = UIActivityViewController(activityItems: [SettingTitle.share_text.rawValue], applicationActivities: nil)
                UIButton.appearance().tintColor = UIColor(hex:0x515859)
                appShare.excludedActivityTypes = [ UIActivityType.airDrop]
                appShare.popoverPresentationController?.sourceView = self.view
                self.present(appShare, animated: true, completion: nil)
                
                break
            case 1:
                UIApplication.shared.openURL(URL(string: SettingTitle.share_url.rawValue)!)
                break
            default:
                break
            }
            break
        case 2:
            switch indexPath.row {
            case 0:
                break
            case 1:
                let infoVCDesign = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
                infoVCDesign.viewType = .designer
                self.show(infoVCDesign, sender: Any.self)
                break
            case 2:
                let infoVCDevelope = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
                infoVCDevelope.viewType = .developer
                self.show(infoVCDevelope, sender: Any.self)
                break
            case 3:
                let Openvc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "OpenSourceViewController")
                self.show(Openvc, sender: Any.self)
                break
            default:
                break
            }
            break
        default:
            break
        }
        if let index = self.settingTableView.indexPathForSelectedRow{
            self.settingTableView.deselectRow(at: index, animated: true)
        }
    }
}


