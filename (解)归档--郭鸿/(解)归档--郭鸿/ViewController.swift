//
//  ViewController.swift
//  (解)归档--郭鸿
//
//  Created by 易无解 on 01/11/2017.
//  Copyright © 2017 易无解. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        1.创建对象
        let person = Person()
        person.age = 21
        person.name = "郭鸿"
        person.height = 178.00
        
//        2.获取路径
        let pathStr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
        let path = pathStr.strings(byAppendingPaths: ["user.plist"]).last!
        
//        3.归档
        NSKeyedArchiver.archiveRootObject(person, toFile: path)
        
//        4.解档
        let person2 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! Person
        print(person2.age, person2.name!, person2.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

