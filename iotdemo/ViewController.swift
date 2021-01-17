//
//  ViewController.swift
//  iotdemo
//
//  Created by Ankit Batra on 03/01/21.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var roomSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var light1Room1Switch: UISwitch!
    @IBOutlet weak var light2Room1Switch: UISwitch!
    @IBOutlet weak var AcRoom1Switch: UISwitch!
    @IBOutlet weak var fanRoom1Switch: UISwitch!
    
    @IBOutlet weak var light1Room2Switch: UISwitch!
    @IBOutlet weak var light2Room2Switch: UISwitch!
    @IBOutlet weak var fanRoom2Switch: UISwitch!
    
    @IBOutlet weak var light1Room1ImageView: UIImageView!
    @IBOutlet weak var fancylightRoom1ImageView: UIImageView!
    @IBOutlet weak var acRoom1ImageView: UIImageView!
    @IBOutlet weak var fan1Room1ImageView: UIImageView!
    
    @IBOutlet weak var room1ContainerView: UIView!
    @IBOutlet weak var light1Room2ImageView: UIImageView!
    @IBOutlet weak var light2Room2ImageView: UIImageView!
    @IBOutlet weak var fan1Room2ImageView: UIImageView!
    @IBOutlet weak var room2ContainerView: UIView!
    
    @IBOutlet weak var wifiNameTextField: UITextField!
    @IBOutlet weak var wifiPassTextField: UITextField!
    @IBOutlet weak var settingsContainerView: UIView!
    
    @IBOutlet weak var roomsScrollView: UIScrollView!
    
    @IBOutlet weak var fanspeedSliderView: UISlider!
    //
    var ref: DatabaseReference!
    
    @IBOutlet weak var fanSpeedLabel: UILabel!
    var board1ValuesDict : [String : AnyObject]  = [:]
    var board1Ref: DatabaseReference?
    
    var board2ValuesDict : [String : AnyObject]  = [:]
    var board2Ref: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        roomsScrollView.delegate = self
        //
        ref = Database.database().reference()
        board1Ref = ref.child("Device1").child("LAPROOM").child("Board1")
        _ =  board1Ref?.observe(.value, with: { [weak self] (snapshot) in
            self?.board1ValuesDict = snapshot.value as? [String : AnyObject] ?? [:]
            //
            let button1Status = self?.board1ValuesDict["Button1"] as! Int
            self?.light1Room1Switch.setOn((button1Status == 1 ? true : false), animated: false)
            self?.light1Room1ImageView.isHighlighted = (button1Status == 1 ? true : false)
            let button2Status = self?.board1ValuesDict["Button2"] as! Int
            self?.light2Room1Switch.setOn(button2Status == 1 ? true : false, animated: false)
            self?.fancylightRoom1ImageView.isHighlighted = (button2Status == 1 ? true : false)
            let button3Status = self?.board1ValuesDict["Button3"] as! Int
            self?.AcRoom1Switch.setOn(button3Status == 1 ? true : false, animated: false)
            self?.acRoom1ImageView.isHighlighted = (button3Status == 1 ? true : false)
            let button4Status = self?.board1ValuesDict["Button4"] as! Int
            self?.fanRoom1Switch.setOn(button4Status >= 1 ? true : false, animated: false)
            if button4Status >= 1 {
                self?.fanspeedSliderView.isHidden = false
                self?.fanSpeedLabel.isHidden = false
                self?.fanspeedSliderView.setValue(Float(button4Status), animated: true)
                self?.fanSpeedLabel.text = "\(button4Status)"
            } else {
                self?.fanspeedSliderView.isHidden = true
                self?.fanSpeedLabel.isHidden = true
            }
            self?.fan1Room1ImageView.isHighlighted = (button4Status == 1 ? true : false)

        })
        
        board2Ref = ref.child("Device2").child("LAPROOM").child("Board1")
        _ =  board2Ref?.observe(.value, with: { [weak self] (snapshot) in
            self?.board2ValuesDict = snapshot.value as? [String : AnyObject] ?? [:]
            //
            let button1Status = self?.board2ValuesDict["Button1"] as! Int
            self?.light1Room2Switch.setOn((button1Status == 1 ? true : false), animated: false)
            self?.light1Room2ImageView.isHighlighted = (button1Status == 1 ? true : false)

            let button2Status = self?.board2ValuesDict["Button2"] as! Int
            self?.light2Room2Switch.setOn(button2Status == 1 ? true : false, animated: false)
            self?.light2Room2ImageView.isHighlighted = (button2Status == 1 ? true : false)

            let button3Status = self?.board2ValuesDict["Button3"] as! Int
            self?.fanRoom2Switch.setOn(button3Status == 1 ? true : false, animated: false)
            self?.fan1Room2ImageView.isHighlighted = (button3Status == 1 ? true : false)

        })
    }

    @IBAction func light1Room1SwitchTapped(_ sender: UISwitch) {
        let intVal = sender.isOn == true ? 1 : 0
        light1Room1ImageView.isHighlighted = sender.isOn
        board1Ref?.child("Button1").setValue(intVal) { (error, ref) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    @IBAction func fancylight1SwitchTapped(_ sender: UISwitch) {
        let intVal = sender.isOn == true ? 1 : 0
        fancylightRoom1ImageView.isHighlighted = sender.isOn
        board1Ref?.child("Button2").setValue(intVal) { (error, ref) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    @IBAction func acRoom1SwitchTapped(_ sender: UISwitch) {
        let intVal = sender.isOn == true ? 1 : 0
        acRoom1ImageView.isHighlighted = sender.isOn
        board1Ref?.child("Button3").setValue(intVal) { (error, ref) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    @IBAction func fan1SwitchTapped(_ sender: UISwitch) {
        let intVal = sender.isOn == true ? 1 : 0
        fan1Room1ImageView.isHighlighted = sender.isOn
        if intVal >= 1 {
            fanspeedSliderView.isHidden = false
            fanSpeedLabel.isHidden = false
            fanSpeedLabel.text = "\(intVal)"
        } else {
            fanspeedSliderView.isHidden = true
            fanSpeedLabel.isHidden = true
        }
        board1Ref?.child("Button4").setValue(intVal) { (error, ref) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    
    @IBAction func light1Room2SwitchTapped(_ sender: UISwitch) {
        let intVal = sender.isOn == true ? 1 : 0
        light1Room2ImageView.isHighlighted = sender.isOn
        board2Ref?.child("Button1").setValue(intVal) { (error, ref) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    @IBAction func lights2Room2SwitchTapped(_ sender: UISwitch) {
        let intVal = sender.isOn == true ? 1 : 0
        light2Room2ImageView.isHighlighted = sender.isOn
        board2Ref?.child("Button2").setValue(intVal) { (error, ref) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    @IBAction func fan1Room2SwitchTapped(_ sender: UISwitch) {
        let intVal = sender.isOn == true ? 1 : 0
        fan1Room2ImageView.isHighlighted = sender.isOn
        board2Ref?.child("Button3").setValue(intVal) { (error, ref) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    @IBAction func updaButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func roomChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            roomsScrollView.scrollRectToVisible(room1ContainerView.frame, animated: true)
        case 1:
            roomsScrollView.scrollRectToVisible(room2ContainerView.frame, animated: true)
        case 2:
            roomsScrollView.scrollRectToVisible(settingsContainerView.frame, animated: true)
        default:
            break
        }
       
    }
    
    @IBAction func fanSpeedValueChanged(_ sender: UISlider) {
        fanSpeedLabel.text = "\(Int(sender.value))"
        board1Ref?.child("Button4").setValue(Int(sender.value)) { (error, ref) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
}


extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let currentPage = Int(offset / view.bounds.size.width)
        roomSegmentControl.selectedSegmentIndex = currentPage
    }
}
