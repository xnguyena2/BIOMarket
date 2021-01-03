//
//  CategoryViewController.swift
//  BOMarket
//
//  Created by Nguyen Phong on 27/11/2020.
//  Copyright © 2020 Buffchalo. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    let AllCategory:[CategoryDrinks] = [
        CategoryDrinks(Title: "Đồ Uống Có Cồn", ImageName: "alcohol_drinks", DrinkType: .Alcohol),
        CategoryDrinks(Title: "Nước Giải Khát", ImageName: "beverage", DrinkType: .Beverage),
        CategoryDrinks(Title: "Nước Lọc", ImageName: "fresh_water", DrinkType: .FreshWater),
        CategoryDrinks(Title: "Đồ Uống Nhập Ngoại", ImageName: "internationnal_drinks", DrinkType: .International),
        CategoryDrinks(Title: "Nước Ép Trái Cây", ImageName: "juice_fruit", DrinkType: .JuiceFruit)
    ]
    
    private lazy var childVC:UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        return vc
    }()
    
    private lazy var childVC2:subVC = {
        let vc = subVC()
        return vc
    }()
    
    @IBOutlet weak var tableCategory: UITableView!
    
    @IBOutlet weak var ContainerSubCategory: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableCategory.delegate = self
        tableCategory.dataSource = self
        tableCategory.register(UINib(nibName: CategoryTableViewCell.Identity, bundle: nil), forCellReuseIdentifier: "CategoryCellIdentifier")
        tableCategory.tableFooterView = UIView()
        
        setupLayout()
        addVC(childVC)
    }
    
    func setupLayout(){
        //self.view.backgroundColor = .systemGray5
    }
    
    func addVC(_ childVC : UIViewController){
        childVC.willMove(toParent: self)
        addChild(childVC)
        
        view.addSubview(childVC.view)
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childVC.view.leadingAnchor.constraint(equalTo: ContainerSubCategory.leadingAnchor),
            childVC.view.topAnchor.constraint(equalTo: ContainerSubCategory.topAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: ContainerSubCategory.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: ContainerSubCategory.bottomAnchor)
        ])
        childVC.view.frame = ContainerSubCategory.frame
        
        childVC.didMove(toParent: self)
    }
    
    func removeVC(_ childVC : UIViewController){
        childVC.willMove(toParent: self)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
        childVC.didMove(toParent: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class subVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath) as! CategoryTableViewCell
        cell.Config(config: AllCategory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cellSelected = tableView.cellForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
