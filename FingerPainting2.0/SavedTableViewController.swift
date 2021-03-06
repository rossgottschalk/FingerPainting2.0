//
//  SavedTableViewController.swift
//  FingerPainting2.0
//
//  Created by Ross Gottschalk on 8/26/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit
import CoreData

class SavedTableViewController: UITableViewController
{
    @IBOutlet weak var savedTableView: UITableView!
    
        var paintings = [NSManagedObject]()
    
    
    @IBAction func donePressed(sender: UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
//    @IBAction func addName(sender: AnyObject)
//    {
//        let alert = UIAlertController(title: "Add Title",
//                                      message: "Add a title to your painting",
//                                      preferredStyle: .Alert)
//        
////        let saveAction = UIAlertAction(title: "Save",
////                                       style: .Default,
////                                       handler: { (action:UIAlertAction) -> Void in
////                                        
////                                        let textField = alert.textFields!.first
////                                        self.paintings.append(textField!.text!)
////                                        self.tableView.reloadData()
//        let saveAction = UIAlertAction(title: "Save",
//                                       style: .Default,
//                                       handler: { (action:UIAlertAction) -> Void in
//                                        
//                                        let textField = alert.textFields!.first
//                                        self.saveName(textField!.text!)
//                                        self.tableView.reloadData()
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .Default) { (action: UIAlertAction) -> Void in
//        }
//        
//        alert.addTextFieldWithConfigurationHandler {
//            (textField: UITextField) -> Void in
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        presentViewController(alert,
//                              animated: true,
//                              completion: nil)
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addName()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func addName()
    {
        let alert = UIAlertController(title: "Add Title",
                                      message: "Add a title to your painting",
                                      preferredStyle: .Alert)
        
        //        let saveAction = UIAlertAction(title: "Save",
        //                                       style: .Default,
        //                                       handler: { (action:UIAlertAction) -> Void in
        //
        //                                        let textField = alert.textFields!.first
        //                                        self.paintings.append(textField!.text!)
        //                                        self.tableView.reloadData()
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveName(textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return paintings.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("savedCells", forIndexPath: indexPath) as! CustomCell

        let painting = paintings[indexPath.row]
        
        cell.nameLabel?.text = painting.valueForKey("name") as? String
        let imageData = painting.valueForKey("paintingImage") as? NSData
        let aPaintingImage = UIImage(data: imageData!)
        cell.paintingImage.image = aPaintingImage
        
        return cell
    }
    
    func saveName(name: String) {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Painting",
                                                        inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        //3
        person.setValue(name, forKey: "name")
    

        
        //4
        do {
            try managedContext.save()
            //5
            paintings.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Painting")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            paintings = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let paintingToDelete = paintings[indexPath.row]
            paintings.removeAtIndex(indexPath.row)
            managedContext.deleteObject(paintingToDelete)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            do
            {
                try managedContext.save()
            } catch
            {
                let error = error as NSError
                print("Could not save to Core Data: \(error.localizedDescription)")
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
