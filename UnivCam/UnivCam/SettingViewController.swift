//
//  SettingViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var SettingTableView: UITableView!
    @IBOutlet var topBorderView: UIView!
    
    let index_list = ["환경설정","유니브캠","세부사항"]
    let title_number = [2,2,4]
    let titles_section1 = ["검색결과관리","접근권한설정"]
    let titles_section2 = ["유니브캠 공유하기","유니브캠 평가하기"]
    let titles_section3 = ["버전정보","개발자 깃허브","디자이너 정보","Open Source Licence"]
    var section_num : Int = 0
    let shareText = "앨범 및 사진 정리 어플리케이션 UnivCam으로, 더욱 효율적이고 생산적인 앨범 정리를 해보세요!\niOS : , Android : "
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SettingTableView.delegate = self
        self.SettingTableView.dataSource = self
        //self.SettingTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SettingViewController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SettingHeaderTableViewCell
        header_cell.header_title.text = index_list[section]
        return header_cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title_number[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 0 {
            topBorderView.isHidden = false
        } else {
            topBorderView.isHidden = true
        }
        
        let sectionHeaderHeight: CGFloat = SettingTableView.sectionHeaderHeight
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
        else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting_cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingTableViewCell
        section_num += 1
        switch section_num {
        case 1,2:
            setting_cell.versionInfo.text = ""
            setting_cell.setting_title.text = titles_section1[indexPath.row]
            break
        case 3,4:
            setting_cell.versionInfo.text = ""
            setting_cell.setting_title.text = titles_section2[indexPath.row]
            break
        case 5:
            setting_cell.versionInfo.text = "1.0"
            setting_cell.setting_title.text = titles_section3[indexPath.row]
            break
        case 6,7,8:
            setting_cell.versionInfo.text = ""
            setting_cell.setting_title.text = titles_section3[indexPath.row]
            break
        default:
            break
        }
        
        return setting_cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 39.5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
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
                let Sevc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SearchHistorySettingVC") as! SearchHistorySettingVC
                self.show(Sevc, sender: Any?)
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
                let appShare = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                UIButton.appearance().tintColor = UIColor(hex:0x515859)
                appShare.excludedActivityTypes = [ UIActivityType.airDrop]
                appShare.popoverPresentationController?.sourceView = self.view
                self.present(appShare, animated: true, completion: nil)
                
                break
            case 1:
                UIApplication.shared.openURL(URL(string: "https://github.com/chojunyng")!)
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
                let Crevc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "CreatorListVC") as! CreatorListVC
                self.show(Crevc, sender: Any?)
                break
            case 2:
                let Devc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "DesignerViewController") as! DesignerViewController
                self.show(Devc, sender: Any?)
                break
            case 3:
                let Openvc = UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "OpenSourceViewController")
                self.show(Openvc, sender: Any?)
                break
            default:
                break
            }
            break
        default:
            break
        }
        if let index = self.SettingTableView.indexPathForSelectedRow{
            self.SettingTableView.deselectRow(at: index, animated: true)
        }
    }
}


