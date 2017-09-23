//
//  ViewController.swift
//  CustomCalendar
//
//  Created by APPLE-HOME on 21/09/17.
//  Copyright © 2017 Encureit system's pvt.ltd. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol getDateDelegate {
    func selectedDate(date: String)
}

class CalendarViewController: UIViewController {

    var delegate: getDateDelegate!
    
    let outsideMonthColor = UIColor(hex: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(hex: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(hex: 0x4e3f5d)
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCalendarView()
        setDate(date: Date())
        setupLabels()
    }
    
    func setupLabels() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        yearView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        selectedDate.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            yearView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            yearView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            yearView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
  
            monthLabel.centerYAnchor.constraint(equalTo: self.yearView.centerYAnchor),
            monthLabel.trailingAnchor.constraint(equalTo: self.yearView.centerXAnchor, constant: -8),
            
            yearLabel.centerYAnchor.constraint(equalTo: self.yearView.centerYAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: self.yearView.centerXAnchor, constant: 8),
            
            dateView.topAnchor.constraint(equalTo: self.yearLabel.bottomAnchor, constant: 8),
            dateView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            selectedDate.centerYAnchor.constraint(equalTo: self.dateView.centerYAnchor),
            selectedDate.centerXAnchor.constraint(equalTo: self.dateView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: 4),
        ])
    }
    
    func setupCalendarView() {
        
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup labels
        
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
        
    }
    
    func setDate(date: Date) {
        let formatters = DateFormatter()
        formatters.dateFormat = "dd MMM yyyy"
        selectedDate.text = formatters.string(from: date)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
   
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
                
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
  
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        self.delegate?.selectedDate(date: selectedDate.text!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState, date: Date) {
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.dateBelongsTo != .thisMonth {
            validCell.dateLabel.text = ""
            validCell.isUserInteractionEnabled = false
            validCell.selectedView.isHidden = true
        } else if date.isSmaller(to: Date()) && !preDateSelectable {
            validCell.dateLabel.text = "-"
//            self.dayLabel.textColor = UIColor.white
            validCell.isUserInteractionEnabled = false
            validCell.selectedView.isHidden = true
        } else {
            view?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(
                withDuration: 0.5,
                delay: 0, usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.1,
                options: UIViewAnimationOptions.beginFromCurrentState,
                animations: {
                    view?.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
                completion: { _ in
//                    validCell.selectedView.isHidden = false
//                    validCell.isUserInteractionEnabled = true
            })

            validCell.isUserInteractionEnabled = true
            if cellState.isSelected {
                validCell.selectedView.isHidden = false
            } else {
                validCell.selectedView.isHidden = true
            }
            validCell.dateLabel.text = cellState.text
//            dayLabel.textColor = selectableDateColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = Date()
        let endDate = formatter.date(from: "2050 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!)
        
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    // Display Cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        setDate(date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}
