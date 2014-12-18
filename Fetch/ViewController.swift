//
//  ViewController.swift
//  Fetch
//
//  Created by Kanishka Goel on 2014-12-15.
//  Copyright (c) 2014 Kanishka Goel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IMDbAPIControllerDelegate{

    @IBOutlet var titleLabel        : UILabel?      //movie title
    @IBOutlet var releasedLabel     : UILabel?      //movie release date
    @IBOutlet var ratingLabel       : UILabel?      //movie rating
    @IBOutlet var plotLabel         : UILabel?      //movie plot
    @IBOutlet var posterImageView   : UIImageView?  //movie poster
    
    lazy var apiController: IMDbAPIController = IMDbAPIController(delegate: self)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.apiController.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        self.apiController.searchIMDb("Interstellar")
        
    }
    
    func didFinishIMDbSearch(result: Dictionary<String, String>) {
        
        self.titleLabel?.text       = result["Title"]
        self.releasedLabel?.text    = result["Released"]
        self.ratingLabel?.text      = result["Rated"]
        self.plotLabel?.text        = result["Plot"]
        
        if let foundPosterURL = result["Poster"]?{
            
            self.formatImageFromPath(foundPosterURL)
            
        }
        
    }
    
    func formatImageFromPath(path: String) {
        
        var posterURL                       = NSURL(string: path)
        var posterImageData                 = NSData(contentsOfURL: posterURL!)
        self.posterImageView?.clipsToBounds = true
        self.posterImageView?.image         = UIImage(data: posterImageData!)
        
    }

}

