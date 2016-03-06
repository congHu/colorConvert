//
//  TableViewController.swift
//  colorConvert
//
//  Created by David on 16/1/4.
//  Copyright (c) 2016年 David. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController, UIAlertViewDelegate {
    var colorNameAry = ["黑色","白色","红色","绿色","蓝色","黄色","青色","粉红","紫色"]
    var rgbAry = ["000000","FFFFFF","FF0000","00FF00","0000FF","FFFF00","00FFFF","FF00FF","9600FF"]
    lazy var documentsPath: String = {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as! String
        return paths
        }()
    @IBOutlet var editItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let namePath = "\(documentsPath)/ColorName.plist"
        if !NSFileManager.defaultManager().fileExistsAtPath(namePath){
            var tempAry:NSArray = []
            tempAry.writeToFile(namePath, atomically: true)
        }
        var colorNameAry = NSMutableArray(contentsOfFile: namePath)!
        if colorNameAry.count == 0{
            editItem.enabled = false
        }
        
        let themeColorPath = "\(documentsPath)/themeColor.plist"
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(themeColorPath){
            var temp:NSArray = ["23AAA4"]
            temp.writeToFile(themeColorPath, atomically: true)
        }
        var themeColor = NSArray(contentsOfFile: themeColorPath)
        var themeHex = themeColor?.objectAtIndex(0) as! String
        navigationController?.navigationBar.barTintColor = showColor(themeHex)
    }
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    @IBAction func closeView(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section{
        case 0:
            let namePath = "\(documentsPath)/ColorName.plist"
            if !NSFileManager.defaultManager().fileExistsAtPath(namePath){
                var tempAry:NSArray = []
                tempAry.writeToFile(namePath, atomically: true)
            }
            var colorNameAry = NSMutableArray(contentsOfFile: namePath)!
            if colorNameAry.count == 0{
                return 0
            }else{
                return colorNameAry.count
            }
        case 1:
            return colorNameAry.count
        default:
            return 1
        }
        
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            let namePath = "\(documentsPath)/ColorName.plist"
            if !NSFileManager.defaultManager().fileExistsAtPath(namePath){
                var tempAry:NSArray = []
                tempAry.writeToFile(namePath, atomically: true)
            }
            var colorNameAry = NSMutableArray(contentsOfFile: namePath)!
            if colorNameAry.count == 0{
                return ""
            }else{
                return "我的色板"
            }
            
        case 1:
            return "标准色板"
        default:
            return "色板"
        }
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
    func showColor(var x:String) ->UIColor{
        var strArray:[Int] = []
        for c in x{
            strArray.append(convert(String(c)))
        }
        var redFloat:CGFloat = CGFloat(strArray[0]*16 + strArray[1])
        var greenFloat:CGFloat = CGFloat(strArray[2]*16 + strArray[3])
        var blueFloat:CGFloat = CGFloat(strArray[4]*16 + strArray[5])
        
        return UIColor(red: redFloat/255, green: greenFloat/255, blue: blueFloat/255, alpha: 1.0)
    }
    //读取数据
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
//        let cell1 = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier1", forIndexPath: indexPath) as! UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as! UITableViewCell
        let cell1 = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier1") as! UITableViewCell

        // Configure the cell...

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
        var mycolorNameAry = NSMutableArray(contentsOfFile: namePath)!
        var colorHexAry = NSMutableArray(contentsOfFile: hexPath)!
        
        var text1 = cell.viewWithTag(1) as! UILabel
        var text2 = cell.viewWithTag(2) as! UILabel
        var colorView = cell.viewWithTag(3)
        
        var actext1 = cell1.viewWithTag(4) as! UILabel
        var actext2 = cell1.viewWithTag(5) as! UILabel
        var accolorView = cell1.viewWithTag(6)
        
        if indexPath.section == 1{
            if detectDeepColor(rgbAry[indexPath.row]){
                actext1.text = colorNameAry[indexPath.row]
                actext2.text = "#" + rgbAry[indexPath.row]
                accolorView?.backgroundColor = showColor(rgbAry[indexPath.row])
                return cell1
            }else{
                text1.text = colorNameAry[indexPath.row]
                text2.text = "#" + rgbAry[indexPath.row]
                colorView?.backgroundColor = showColor(rgbAry[indexPath.row])
                return cell
            }
            
        }else{
            if detectDeepColor(colorHexAry.objectAtIndex(indexPath.row) as! String){
                actext1.text = (mycolorNameAry.objectAtIndex(indexPath.row) as! String)
                actext2.text = "#" + (colorHexAry.objectAtIndex(indexPath.row) as! String)
                accolorView?.backgroundColor = showColor(colorHexAry.objectAtIndex(indexPath.row) as! String)
                return cell1
            }else{
                text1.text = (mycolorNameAry.objectAtIndex(indexPath.row) as! String)
                text2.text = "#" + (colorHexAry.objectAtIndex(indexPath.row) as! String)
                colorView?.backgroundColor = showColor(colorHexAry.objectAtIndex(indexPath.row) as! String)
                return cell
            }
            
        }
        
        //return cell
    }
    
    //点按操作
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let hexPath = "\(documentsPath)/ColorHex.plist"
        
        if !NSFileManager.defaultManager().fileExistsAtPath(hexPath){
            var tempAry:NSArray = []
            tempAry.writeToFile(hexPath, atomically: true)
        }
        var colorHexAry = NSMutableArray(contentsOfFile: hexPath)!
        var firstView =  storyboard?.instantiateViewControllerWithIdentifier("firstview") as! ViewController
        var returnStr:String
        if indexPath.section == 0{
            returnStr = colorHexAry.objectAtIndex(indexPath.row) as! String
        }else{
            returnStr = rgbAry[indexPath.row]
        }
        firstView.hexString = returnStr
        firstView.historyHex1 = returnStr
        firstView.subView = true
        navigationController?.pushViewController(firstView, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.section == 0{
            return true
        }else{
            return false
        }
    }
    
    @IBAction func editClick(sender: UIBarButtonItem) {
        self.setEditing(!self.editing, animated: true)
        if(self.editing){
            sender.title = "完成"
        }else{
            sender.title = "编辑"
        }
    }
    var themeHex:NSString = ""
    func detectDeepColor(var x:String) ->Bool{
        var strArray:[Int] = []
        for c in x{
            strArray.append(convert(String(c)))
        }
        var r:CGFloat = CGFloat(strArray[0]*16 + strArray[1])
        var g:CGFloat = CGFloat(strArray[2]*16 + strArray[3])
        var b:CGFloat = CGFloat(strArray[4]*16 + strArray[5])
        var grayLevel = r * 0.299 + g * 0.587 + b * 0.114
        if grayLevel >= 192{
            return false
        }else{
            return true
        }
    }
    
    /*
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            let hexPath = "\(documentsPath)/ColorHex.plist"
            var colorHexAry = NSMutableArray(contentsOfFile: hexPath)!
            themeHex = colorHexAry.objectAtIndex(indexPath.row) as! String
        }else{
            themeHex = rgbAry[indexPath.row]
        }
        
        var alert = UIAlertView(title: "设置为主题色？", message: themeHex as String, delegate: self, cancelButtonTitle: "取消")
        alert.addButtonWithTitle("好")
        alert.show()
    }
    */
    
    /*
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1{
            if detectDeepColor(themeHex as String){
                
                let themeColorPath = "\(documentsPath)/themeColor.plist"
                var themeColor = NSMutableArray(contentsOfFile: themeColorPath)
                themeColor?.replaceObjectAtIndex(0, withObject: themeHex)
                themeColor?.writeToFile(themeColorPath, atomically: true)
                navigationController?.navigationBar.barTintColor = showColor(themeHex as String)
                var firstview = storyboard?.instantiateViewControllerWithIdentifier("firstview") as! ViewController
                firstview.navigationController?.navigationBar.barTintColor = showColor(themeHex as String)
            }
            
        }
    }
    */
    
    //重载默认按钮文字
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }

    
    //重载删除操作 Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let namePath = "\(documentsPath)/ColorName.plist"
            let hexPath = "\(documentsPath)/ColorHex.plist"
            var mycolorNameAry = NSMutableArray(contentsOfFile: namePath)!
            var colorHexAry = NSMutableArray(contentsOfFile: hexPath)!
            mycolorNameAry.removeObjectAtIndex(indexPath.row)
            colorHexAry.removeObjectAtIndex(indexPath.row)
            mycolorNameAry.writeToFile(namePath, atomically: true)
            colorHexAry.writeToFile(hexPath, atomically: true)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if mycolorNameAry.count == 0{
                editItem.enabled = false
            }
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let namePath = "\(documentsPath)/ColorName.plist"
        let hexPath = "\(documentsPath)/ColorHex.plist"
        var mycolorNameAry = NSMutableArray(contentsOfFile: namePath)!
        var colorHexAry = NSMutableArray(contentsOfFile: hexPath)!
        var movingName = mycolorNameAry.objectAtIndex(fromIndexPath.row) as! String
        var movingHex = colorHexAry.objectAtIndex(fromIndexPath.row) as! String
        mycolorNameAry.removeObjectAtIndex(fromIndexPath.row)
        mycolorNameAry.insertObject(movingName, atIndex: toIndexPath.row)
        colorHexAry.removeObjectAtIndex(fromIndexPath.row)
        colorHexAry.insertObject(movingHex, atIndex: toIndexPath.row)
        mycolorNameAry.writeToFile(namePath, atomically: true)
        colorHexAry.writeToFile(hexPath, atomically: true)
        tableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.section == 0{
            return true
        }else{
            return false
        }
        
    }
    
    @IBAction func cellLongPress(sender: UILongPressGestureRecognizer) {
        print("longpress!")
        var menu = UIMenuController()
        menu.menuItems = [UIMenuItem(title: "设置", action: "setColor")]
        menu.setMenuVisible(true, animated: true)
    }
    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let hexPath = "\(documentsPath)/ColorHex.plist"
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(hexPath){
            var tempAry:NSArray = []
            tempAry.writeToFile(hexPath, atomically: true)
        }
        var colorHexAry = NSMutableArray(contentsOfFile: hexPath)!
        
        if indexPath.section == 1{
            if detectDeepColor(rgbAry[indexPath.row]){
                return true
            }else{
                return false
            }
            
        }else{
            if detectDeepColor(colorHexAry.objectAtIndex(indexPath.row) as! String){
                return true
            }else{
                return false
            }
        }
    }
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) -> Bool {
        if action == Selector("copy:"){
            let hexPath = "\(documentsPath)/ColorHex.plist"
            let fileManager = NSFileManager.defaultManager()
            if !fileManager.fileExistsAtPath(hexPath){
                var tempAry:NSArray = []
                tempAry.writeToFile(hexPath, atomically: true)
            }
            var colorHexAry = NSMutableArray(contentsOfFile: hexPath)!
            
            if indexPath.section == 1{
                if detectDeepColor(rgbAry[indexPath.row]){
                    return true
                }else{
                    return false
                }
                
            }else{
                if detectDeepColor(colorHexAry.objectAtIndex(indexPath.row) as! String){
                    return true
                }else{
                return false
                }
            }
        }else{
            return false
        }
    }
    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        
        let themeColorPath = "\(documentsPath)/themeColor.plist"
        var themeColor = NSMutableArray(contentsOfFile: themeColorPath)
        themeColor?.replaceObjectAtIndex(0, withObject: themeHex)
        themeColor?.writeToFile(themeColorPath, atomically: true)
        navigationController?.navigationBar.barTintColor = showColor(themeHex as String)
        var firstview = storyboard?.instantiateViewControllerWithIdentifier("firstview") as! ViewController
        firstview.navigationController?.navigationBar.barTintColor = showColor(themeHex as String)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
