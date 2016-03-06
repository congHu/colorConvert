//
//  ViewController.swift
//  colorConvert
//
//  Created by David on 15/11/15.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate, UIActionSheetDelegate {
    lazy var documentsPath: String = {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths.first! as! String
        }()
    var statusBar:UIStatusBarStyle = UIStatusBarStyle.LightContent
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBar
    }
    @IBAction func about(sender: UIBarButtonItem) {
        UIAlertView(title: "颜色转换", message: "v1.12\n聪哥编写", delegate: self, cancelButtonTitle: "好").show()
    }
    var hexString = "000000"
    var subView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hexValue.backgroundColor = self.view.backgroundColor
        hexValue.textColor = UIColor.whiteColor()
        redInput.backgroundColor = self.view.backgroundColor
        redInput.textColor = UIColor.whiteColor()
        greenInput.backgroundColor = self.view.backgroundColor
        greenInput.textColor = UIColor.whiteColor()
        blueInput.backgroundColor = self.view.backgroundColor
        blueInput.textColor = UIColor.whiteColor()
        hexValue.text = hexString
        convertA(hexString)
        if subView{
            bookmarkItem.enabled = false
        }
        
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let themeColorPath = "\(documentsPath)/themeColor.plist"
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(themeColorPath){
            var temp:NSArray = ["23AAA4"]
            temp.writeToFile(themeColorPath, atomically: true)
        }
        var themeColor = NSArray(contentsOfFile: themeColorPath)
        var themeHex = themeColor?.objectAtIndex(0) as! String
        navigationController?.navigationBar.barTintColor = convertReturnColorOnly(themeHex)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet var hexValue: UITextField!
    @IBOutlet var redInput: UITextField!
    @IBOutlet var greenInput: UITextField!
    @IBOutlet var blueInput: UITextField!
    @IBOutlet var bColor: UIView!
    @IBOutlet var aColor: UIView!
    @IBOutlet var redStp: UIStepper!
    @IBOutlet var greenStp: UIStepper!
    @IBOutlet var blueStp: UIStepper!
    @IBOutlet var historyLabel: UILabel!
    @IBOutlet var currentLabel: UILabel!
    @IBOutlet var clearItem: UIBarButtonItem!
    @IBOutlet var bookmarkItem: UIBarButtonItem!
    
    func convertA(var hex:String){
        var strArray:[Int] = []
        for hexChar in hex{
            strArray.append(convert(String(hexChar)))
        }
        var redFloat:CGFloat = CGFloat(strArray[0]*16 + strArray[1])
        var greenFloat:CGFloat = CGFloat(strArray[2]*16 + strArray[3])
        var blueFloat:CGFloat = CGFloat(strArray[4]*16 + strArray[5])
        hexValue.text = hex
        bColor.backgroundColor = aColor.backgroundColor
        aColor.backgroundColor = UIColor(red: redFloat/255, green: greenFloat/255, blue: blueFloat/255, alpha: 1.0)
        historyLabel.textColor = currentLabel.textColor
        if detectDeepColor(redFloat, g: greenFloat, b: blueFloat){
            currentLabel.textColor = UIColor.whiteColor()
        }else{
            currentLabel.textColor = UIColor.blackColor()
        }
        redInput.text = String(Int(redFloat))
        blueInput.text = String(Int(blueFloat))
        greenInput.text = String(Int(greenFloat))
        redStp.value = Double(redFloat)
        greenStp.value = Double(greenFloat)
        blueStp.value = Double(blueFloat)
    }
    func convertReturnColorOnly(var hex:String) ->UIColor{
        var strArray:[Int] = []
        for hexChar in hex{
            strArray.append(convert(String(hexChar)))
        }
        var redFloat:CGFloat = CGFloat(strArray[0]*16 + strArray[1])
        var greenFloat:CGFloat = CGFloat(strArray[2]*16 + strArray[3])
        var blueFloat:CGFloat = CGFloat(strArray[4]*16 + strArray[5])
        return UIColor(red: redFloat/255, green: greenFloat/255, blue: blueFloat/255, alpha: 1.0)
    }
    func detectDeepColor(var r:CGFloat, var g:CGFloat, var b:CGFloat) ->Bool{
        var grayLevel = r * 0.299 + g * 0.587 + b * 0.114
        if grayLevel >= 192{
            return false
        }else{
            return true
        }
    }
    var historyHex0 = "FFFFFF"
    var historyHex1 = "000000"
    @IBAction func hexEditing(sender: UITextField) {
        sender.text = sender.text.uppercaseString
        if count(sender.text) < 6{
            sender.textColor = UIColor.grayColor()
        }else{
            if count(sender.text) == 6{
                var hexError = false
                for c in sender.text{
                    if c == "1" || c == "2" || c == "3" || c == "4" || c == "5" || c == "6" || c == "7" || c == "8" || c == "9" || c == "0" || c == "A" || c == "B" || c == "C" || c == "D" || c == "E" || c == "F" {
                        sender.textColor = UIColor.whiteColor()
                    }else{
                        hexError = true
                        sender.textColor = UIColor.redColor()
                        break
                    }
                }
                if !hexError {
                    convertA(sender.text)
                    historyHex0 = historyHex1
                    historyHex1 = sender.text
                }
            }else{
                if count(sender.text) > 6{
                    sender.textColor = UIColor.redColor()
                }
            }
        }
    }
    func convertBack(){
        if redInput.text.toInt() != nil && greenInput.text.toInt() != nil && blueInput.text.toInt() != nil{
            if redInput.text.toInt() <= 255 && redInput.text.toInt() >= 0 && blueInput.text.toInt() <= 255 && blueInput.text.toInt() >= 0 && greenInput.text.toInt() <= 255 && greenInput.text.toInt() >= 0{
                var strOutArray:[String] = []
                var strOut = ""
                strOut += convertB(redInput.text.toInt()!/16)
                strOut += convertB(redInput.text.toInt()!%16)
                strOut += convertB(greenInput.text.toInt()!/16)
                strOut += convertB(greenInput.text.toInt()!%16)
                strOut += convertB(blueInput.text.toInt()!/16)
                strOut += convertB(blueInput.text.toInt()!%16)
                hexValue.text = strOut
                historyHex0 = historyHex1
                historyHex1 = strOut
                bColor.backgroundColor = aColor.backgroundColor
                aColor.backgroundColor = UIColor(red: CGFloat(redInput.text.toInt()!)/255.0, green: CGFloat(greenInput.text.toInt()!)/255.0, blue: CGFloat(blueInput.text.toInt()!)/255.0, alpha: 1.0)
                historyLabel.textColor = currentLabel.textColor
                if detectDeepColor(CGFloat(redInput.text.toInt()!), g: CGFloat(greenInput.text.toInt()!), b: CGFloat(blueInput.text.toInt()!)){
                    currentLabel.textColor = UIColor.whiteColor()
                }else{
                    currentLabel.textColor = UIColor.blackColor()
                }
            }
        }
    }
    @IBAction func redEditing(sender: UITextField){
        if redInput.text.toInt() != nil{
            if redInput.text.toInt()! <= 255 && redInput.text.toInt()! >= 0{
                redInput.textColor = UIColor.whiteColor()
                convertBack()
                redStp.value = Double(redInput.text.toInt()!)
            }else{
                redInput.textColor = UIColor.redColor()
            }
        }
    }
    @IBAction func greenEditing(sender: UITextField) {
        if greenInput.text.toInt() != nil{
            if greenInput.text.toInt()! <= 255 && greenInput.text.toInt()! >= 0{
                greenInput.textColor = UIColor.whiteColor()
                convertBack()
                greenStp.value = Double(greenInput.text.toInt()!)
            }else{
                greenInput.textColor = UIColor.redColor()
            }
        }
    }
    @IBAction func blueEditing(sender: UITextField) {
        if blueInput.text.toInt() != nil{
            if blueInput.text.toInt()! <= 255 && blueInput.text.toInt()! >= 0{
                blueInput.textColor = UIColor.whiteColor()
                convertBack()
                blueStp.value = Double(blueInput.text.toInt()!)
            }else{
                blueInput.textColor = UIColor.redColor()
            }
        }
    }
    @IBAction func redStpChange(sender: UIStepper) {
        redInput.text = String(stringInterpolationSegment: Int(sender.value))
    }
    @IBAction func greenStpChange(sender: UIStepper) {
        greenInput.text = String(stringInterpolationSegment: Int(sender.value))
    }
    @IBAction func blueStpChange(sender: UIStepper) {
        blueInput.text = String(stringInterpolationSegment: Int(sender.value))
    }
    @IBAction func redStpExit(sender: UIStepper) {
        if sender.value != 255 && sender.value != 0{
            convertBack()
        }
        
    }
    @IBAction func blueStpExit(sender: UIStepper) {
        if sender.value != 255 && sender.value != 0{
            convertBack()
        }
    }
    @IBAction func greenStpExit(sender: UIStepper) {
        if sender.value != 255 && sender.value != 0{
            convertBack()
        }
    }
    @IBAction func blankClick1(sender: UITapGestureRecognizer) {
        hideKeyboard()
    }
    @IBAction func blackClick2(sender: UITapGestureRecognizer) {
        hideKeyboard()
    }
    @IBAction func hexReturn(sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func redReturn(sender: UITextField) {
        if sender.text == ""{
            sender.text = "0"
        }
    }
    @IBAction func greenReturn(sender: UITextField) {
        if sender.text == ""{
            sender.text = "0"
        }
    }
    @IBAction func blueReturn(sender: UITextField) {
        if sender.text == ""{
            sender.text = "0"
        }
    }
    @IBAction func redBegin(sender: UITextField) {
        if sender.text == "0"{
            sender.text = ""
        }
    }
    @IBAction func greenBegin(sender: UITextField) {
        if sender.text == "0"{
            sender.text = ""
        }
    }
    @IBAction func blueBegin(sender: UITextField) {
        if sender.text == "0"{
            sender.text = ""
        }
    }
    @IBAction func make0red(sender: UITextField) {
        if greenInput.text == ""{
            greenInput.text = "0"
        }
        if blueInput.text == ""{
            blueInput.text = "0"
        }
    }
    @IBAction func make0green(sender: UITextField) {
        if redInput.text == ""{
            redInput.text = "0"
        }
        if blueInput.text == ""{
            blueInput.text = "0"
        }
    }
    @IBAction func make0blue(sender: UITextField) {
        if greenInput.text == ""{
            greenInput.text = "0"
        }
        if redInput.text == ""{
            redInput.text = "0"
        }
    }
    func hideKeyboard(){
        if redInput.text == ""{
            redInput.text = "0"
        }
        if greenInput.text == ""{
            greenInput.text = "0"
        }
        if blueInput.text == ""{
            blueInput.text = "0"
        }
        hexValue.resignFirstResponder()
        redInput.resignFirstResponder()
        greenInput.resignFirstResponder()
        blueInput.resignFirstResponder()
    }
    @IBAction func clearAll(sender: UIBarButtonItem) {
        UIActionSheet(title: "还原初始状态", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "还原").showFromBarButtonItem(clearItem, animated: true)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0{
            bColor.backgroundColor = UIColor.whiteColor()
            aColor.backgroundColor = UIColor.blackColor()
            hexValue.text = "000000"
            redInput.text = "0"
            greenInput.text = "0"
            blueInput.text = "0"
            redStp.value = 0.0
            blueStp.value = 0.0
            greenStp.value = 0.0
            historyLabel.textColor = UIColor.blackColor()
            currentLabel.textColor = UIColor.whiteColor()
            historyHex0 = "FFFFFF"
            historyHex1 = "000000"
        }
    }
    @IBAction func addItem(sender: UIBarButtonItem) {
        var alert = UIAlertView(title: "添加到色板", message: "输入颜色名称", delegate: self, cancelButtonTitle: "取消")
        alert.addButtonWithTitle("好")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1{
            let namePath = "\(documentsPath)/ColorName.plist"
            let hexPath = "\(documentsPath)/ColorHex.plist"
            let fileManager = NSFileManager.defaultManager()
            if !fileManager.fileExistsAtPath(namePath){
                var tempAry:NSArray = []
                tempAry.writeToFile(namePath, atomically: true)
            }
            if !fileManager.fileExistsAtPath(hexPath){
                var tempAry:NSArray = []
                tempAry.writeToFile(hexPath, atomically: true)
            }
            var colorNameAry = NSMutableArray(contentsOfFile: namePath)!
            var colorHexAry = NSMutableArray(contentsOfFile: hexPath)!
            var userColorName = alertView.textFieldAtIndex(0)!.text
            if userColorName == ""{
                userColorName = hexValue.text
            }
            if alertView.textFieldAtIndex(0)?.text != nil{
                colorNameAry.addObject(userColorName)
                colorNameAry.writeToFile(namePath, atomically: true)
                colorHexAry.addObject(hexValue.text)
                colorHexAry.writeToFile(hexPath, atomically: true)
            }
        }
        
    }
    @IBAction func restoreHistoryColor(sender: UITapGestureRecognizer) {
        var tempHex = historyHex1
        historyHex1 = historyHex0
        historyHex0 = tempHex
        hexValue.text = historyHex1
        convertA(historyHex1)
    }
    func convert(var x:String) -> Int{
        switch(x){
        case "A":
            return 10
            
        case "B":
            return 11
            
        case "C":
            return 12
            
        case "D":
            return 13
            
        case "E":
            return 14
            
        case "F":
            return 15
            
        default:
            return x.toInt()!
            
        }
    }
    
    func convertB(var x:Int) -> String{
        switch(x){
        case 10:
            return "A"
            
        case 11:
            return "B"
            
        case 12:
            return "C"
            
        case 13:
            return "D"
            
        case 14:
            return "E"
            
        case 15:
            return "F"
            
        default:
            return String(x)
            
        }
    }
}

