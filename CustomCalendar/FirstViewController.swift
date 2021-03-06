//
//  FirstViewController.swift
//  CustomCalendar
//
//  Created by APPLE-HOME on 23/09/17.
//  Copyright © 2017 Encureit system's pvt.ltd. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, getDateDelegate {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.view.addSubview(dateLabel)
        self.view.addSubview(button)
        
        button.layer.cornerRadius = 4
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            dateLabel.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -8),
            dateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            button.widthAnchor.constraint(equalToConstant: 80),
            button.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 8),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func getDatePressed(_ sender: Any) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        if dateLabel.text! != "date" {
            vc.selected = self.selectedDate
        }
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
   
    func selectedDate(date: String, selected: Date) {
        self.dateLabel.text = date
        self.selectedDate = selected
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
