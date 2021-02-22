//
//  ViewController.swift
//  KCalendar
//
//  Created by mav on 22/02/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var centerConstraintr: NSLayoutConstraint!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        monthLabel.text = "\(monthsArr[currentMonthIndex-1])  \(currentYear)"
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        dateCollectionView.delegate=self
        dateCollectionView.dataSource=self
        dateCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
       
        return day
    }
    
    
    
    @IBAction func showAction(_ sender: Any) {
        guard let monthText = monthTextField.text , let yearText = yearTextField.text else {
            showAlert()
            return
        }
   
        guard let month = Int(monthText) , let year = Int(yearText) else {
            showAlert()
            return
        }
      
        if month > 12 || month < 1 {
            showAlert()
            return
        }
        
        currentMonthIndex = month
        currentYear = year
        
        yearTextField.text = nil
        yearTextField.resignFirstResponder()
        monthTextField.text = nil
        monthTextField.resignFirstResponder()
        
        centerConstraintr.constant = 0
        view.layoutIfNeeded()
        
        monthLabel.text = "\(monthsArr[currentMonthIndex-1])  \(currentYear)"
        showCalender(monthIndex: month)
        
    }
    
    func showCalender(monthIndex: Int) {
      
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        dateCollectionView.reloadData()
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Wrong date..", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: -  Calander Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            if calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.backgroundColor = .red
                cell.lbl.textColor = .white
            } else {
                cell.backgroundColor = .white
                cell.lbl.textColor = .black
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    

}



//MARK: - Date extension
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//MARK: - get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        centerConstraintr.constant = -(self.view.frame.height/2)
        view.layoutIfNeeded()
    }
}
