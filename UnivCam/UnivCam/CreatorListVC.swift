//
//  SettingViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class CreatorListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var CreatorTableView: UITableView! {
        didSet {
            CreatorTableView.delegate = self
            CreatorTableView.dataSource = self
        }
    }
    var indexcount : Int = 0
    var developer = "ios개발자"
    
    
    let llb = ["이름", "이메일", "Github"] // Left Label
    
    let cjy = ["조준영", "pom0894@naver.com", "chojunyoung"] // Delveloper Cho Jun Yeong's Info
    let ljs = ["이준상", "zun8ang@gmail.com", "zun8ang"] // Developer Lee Jun Sang's Info
    let cym = ["조용문", "choymoonk@gmail.com", "choymoon"] // Developer Cho Young Moon's Info
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 55
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
        else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeveloperInfoCell", for: indexPath) as! DeveloperInfoCell
        cell.leftLabel.text! = llb[indexPath.row]
        indexcount += 1
        switch indexcount {
        case 1,2,3:
            cell.rightLabel.text! = cjy[indexPath.row]
            break
        case 4,5,6:
            cell.rightLabel.text! = ljs[indexPath.row]
            break
        case 7,8,9:
            cell.rightLabel.text! = cym[indexPath.row]
            break
        default:
            break
        }
        
        return cell
    }
    
}


