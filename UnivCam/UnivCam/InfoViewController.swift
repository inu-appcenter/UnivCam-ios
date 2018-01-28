//
//  DesignerViewController.swift
//  UnivCam
//
//  Created by 조용문 on 2017. 8. 11..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

enum InfoTitles : String {
    case name = "이름"
    case email = "이메일"
    case github = "Github"
    case potfolio = "포트폴리오"
    case hyeok_name = "서혁"
    case hyeok_email = "ghsspower@gmail.com"
    case hyoek_github = "spemer"
    case hyoek_potfolio = "http://spemer.com"
    case jun_name = "조준영"
    case jun_email = "pom0894@naver.com"
    case jun_github = "chojunyoung"
    case sang_name = "이준상"
    case sang_email = "zun8ang@gmail.com"
    case sang_github = "zun8ang"
    case moon_name = "조용문"
    case moon_email = "choymoonk@gmail.com"
    case moon_github = "choymoon"
    case designer_section_title = "Spemer (Hyeok Seo)"
    case developer_section_title = "iOS 개발자"
}

enum InfoType : String {
    case designer = "디자이너 정보"
    case developer = "개발자 정보"
}

class InfoViewController : UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView! {
        didSet {
            infoTableView.dataSource = self
            infoTableView.delegate = self
            infoTableView.register(Cells.setting.nib, forCellReuseIdentifier: Cells.setting.identifier)
            infoTableView.register(Cells.setting_header.nib, forCellReuseIdentifier: Cells.setting_header.identifier)
            // Do any additional setup after loading the view.
        }
    }
    @IBOutlet weak var info_title: UILabel!
    
    let designer_info_title = InfoTitles.designer_section_title
    let designer_header_title : [InfoTitles] = [.name, .email, .github, .potfolio]
    let developer_info_title = InfoTitles.developer_section_title
    let developer_header_title : [InfoTitles] = [.name, .email, .github]
    let seoHyeok : [InfoTitles] = [.hyeok_name, .hyeok_email, .hyoek_github, .hyoek_potfolio]
    let choJun : [InfoTitles] = [.jun_name, .jun_email, .jun_github]
    let leeJun : [InfoTitles] = [.sang_name, .sang_email, .sang_github]
    let choYong : [InfoTitles] = [.moon_name, .moon_email, .moon_github]
    var viewType : InfoType?
    
    
    override func viewWillAppear(_ animated: Bool) {
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: info_title.font = UIFont(name: info_title.font.fontName, size: 22)
            break
        case 1: info_title.font = UIFont(name: info_title.font.fontName, size: 26)
            break
        case 2: info_title.font = UIFont(name: info_title.font.fontName, size: 30)
            break
        case 3: info_title.font = UIFont(name: info_title.font.fontName, size: 33)
            break
        default:
            info_title.font = UIFont(name: info_title.font.fontName, size: 30)
            break
        }
        switch viewType {
        case .designer?:
            info_title.text = viewType?.rawValue
            break
        case .developer?:
            self.infoTableView.alwaysBounceVertical = true
            info_title.text = viewType?.rawValue
            break
        case .none:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension InfoViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewType {
        case .designer?:
            return 1
        case .developer?:
            return 3
        case .none:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! SettingHeaderCell
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: cell.header_title.font = UIFont(name: cell.header_title.font.fontName, size: 9)
            break
        case 1: cell.header_title.font = UIFont(name: cell.header_title.font.fontName, size: 10)
            break
        case 2: cell.header_title.font = UIFont(name: cell.header_title.font.fontName, size: 12)
            break
        case 3: cell.header_title.font = UIFont(name: cell.header_title.font.fontName, size: 13)
            break
        default:
            cell.header_title.font = UIFont(name: cell.header_title.font.fontName, size: 13)
            break
        }
        switch viewType {
        case .designer?:
            cell.header_title.text = designer_info_title.rawValue
            break
        case .developer?:
            cell.header_title.text = developer_info_title.rawValue
            break
        case .none:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let value: CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: value = 39.96
            break
        case 1: value = 47.286
            break
        case 2: value = 55.5
            break
        case 3: value = 61.2165
            break
        default:
            value = 55.5
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewType {
        case .designer?:
            return designer_header_title.count
        case .developer?:
            return developer_header_title.count
        case .none:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: cell.setting_title.font = UIFont(name: cell.setting_title.font.fontName, size: 12)
        cell.version_info.font = UIFont(name: cell.version_info.font.fontName, size: 12)
            break
        case 1: cell.setting_title.font = UIFont(name: cell.setting_title.font.fontName, size: 14)
        cell.version_info.font = UIFont(name: cell.version_info.font.fontName, size: 14)
            break
        case 2: cell.setting_title.font = UIFont(name: cell.setting_title.font.fontName, size: 16)
        cell.version_info.font = UIFont(name: cell.version_info.font.fontName, size: 16)
            break
        case 3: cell.setting_title.font = UIFont(name: cell.setting_title.font.fontName, size: 18)
        cell.version_info.font = UIFont(name: cell.version_info.font.fontName, size: 18)
            break
        default:
            cell.setting_title.font = UIFont(name: cell.setting_title.font.fontName, size: 16)
            cell.version_info.font = UIFont(name: cell.version_info.font.fontName, size: 16)
            break
        }
        switch viewType {
        case .designer?:
            cell.setting_title.text = designer_header_title[indexPath.row].rawValue
            cell.version_info.text = seoHyeok[indexPath.row].rawValue
            break
        case .developer?:
            switch indexPath.section {
            case 0:
                cell.setting_title.text = developer_header_title[indexPath.row].rawValue
                cell.version_info.text = choJun[indexPath.row].rawValue
                break
            case 1:
                cell.setting_title.text = developer_header_title[indexPath.row].rawValue
                cell.version_info.text = leeJun[indexPath.row].rawValue
                break
            case 2:
                cell.setting_title.text = developer_header_title[indexPath.row].rawValue
                cell.version_info.text = choYong[indexPath.row].rawValue
                break
            default:
                break
            }
            break
        case .none:
            break
        }
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yPosition = scrollView.contentOffset.y
        
        let sectionHeaderHeight: CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: sectionHeaderHeight = 39.96
            break
        case 1: sectionHeaderHeight = 47.286
            break
        case 2: sectionHeaderHeight = 55.5
            break
        case 3: sectionHeaderHeight = 61.2165
            break
        default:
            sectionHeaderHeight = 55.5
            break
        }
        if yPosition <= sectionHeaderHeight && yPosition >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-yPosition, 0, 0, 0)
        }
        else if yPosition >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
    }
}

