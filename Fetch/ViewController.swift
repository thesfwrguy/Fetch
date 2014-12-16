//
//  ViewController.swift
//  Fetch
//
//  Created by Kanishka Goel on 2014-12-15.
//  Copyright (c) 2014 Kanishka Goel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var titleLabel        : UILabel?      //movie title
    @IBOutlet var releasedLabel     : UILabel?      //movie release date
    @IBOutlet var ratingLabel       : UILabel?      //movie rating
    @IBOutlet var plotLabel         : UILabel?      //movie plot
    @IBOutlet var posterImageView   : UIImageView?  //movie poster
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        self.titleLabel!.text       = "Interstellar"
        self.releasedLabel!.text    = "2014"
        self.ratingLabel!.text      = "PG"
        self.plotLabel!.text        = "A team of explorers travel through a wormhole in an attempt to ensure humanity's survival"
        self.posterImageView!.image = UIImage(named: "Interstellar.jpg")
        
    }
    

}

