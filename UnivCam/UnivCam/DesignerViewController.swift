//
//  DesignerViewController.swift
//  UnivCam
//
//  Created by 조용문 on 2017. 8. 11..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class DesignerViewController: UIViewController {

    @IBOutlet weak var DesignerTableView: UITableView! {
        didSet {
            DesignerTableView.dataSource = self
            DesignerTableView.delegate = self
            DesignerTableView.tableFooterView = UIView()
            // Do any additional setup after loading the view.
        }
    }
    
    
    let llb = ["이름", "이메일", "Github","포트폴리오"] // Left Label
    var designer = "디자이너"
    let sh = ["서혁", "ghsspower@gmail.com", "spemer","http://spemer.com"] // Designer Seo Hyouk's Info
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension DesignerViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DHeaderCell")
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.5
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return designer
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DesignerCell") as! DesignerTableViewCell
        cell.left_label.text = llb[indexPath.row]
        cell.right_label.text = sh[indexPath.row]
        return cell
    }
}
