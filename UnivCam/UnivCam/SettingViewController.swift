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
    
    let index_list = ["환경설정","유니브캠","세부사항"]
    let title_number = [2,2,4]
    let titles_section1 = ["검색결과관리","접근권한설정"]
    let titles_section2 = ["유니브캠 공유하기","유니브캠 평가하기"]
    let titles_section3 = ["버전정보","개발자 깃허브","디자이너 정보","개발자 정보"]
    var section_num : Int = 0
    override func viewWillAppear(_ animated: Bool) {
        //        super.viewWillAppear(true)
        //        self.extendedLayoutIncludesOpaqueBars = false
    }
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
        //header_cell.textLabel?.text = index_list[section]
        return header_cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title_number[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting_cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingTableViewCell
        section_num += 1
        switch section_num {
        case 1,2:
            setting_cell.setting_title.text = titles_section1[indexPath.row]
            break
        case 3,4:
            setting_cell.setting_title.text = titles_section2[indexPath.row]
            break
        case 5,6,7,8:
            setting_cell.setting_title.text = titles_section3[indexPath.row]
            break
        default:
            break
        }
        
        return setting_cell
    }
    
    
    //
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 39.5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

