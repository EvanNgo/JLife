//
//  JobListViewController.swift
//  test
//
//  Created by ゴ　ハイ　バン on 2017/08/18.
//  Copyright © 2017 ゴ　ハイ　バン. All rights reserved.
//

import UIKit

protocol JobListDelegate {
    func putJobType(_ jobType:String)
}

class JobListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let joblist = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity","Khác"]

    var delegate : JobListDelegate? = nil
    var navBar = UINavigationBar()
    let tableView:UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = nil
        return tbv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setNavigationBar()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TextCell")

        tableView.delegate = self
        tableView.dataSource = self
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView(){
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joblist.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath as IndexPath)
        cell.textLabel?.text = joblist[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.putJobType(joblist[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setNavigationBar() {
        let navItem = UINavigationItem(title: "")
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(cancel))
        navItem.leftBarButtonItem = cancelItem
        navBar.setItems([navItem], animated: false)
        navBar.tintColor = UIColor.white
        navBar.barTintColor = UIColor.init(rgb: 0x1C547A)
        self.view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
