//
//  PageContentViewController.swift
//  UIPageViewController
//
//  Created by Edward Muya on 22/01/2018.
//  Copyright © 2018 com.einmuya. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    // MARK: Properties
    var pageIndex: Int?
    var pageImage: UIImage?
    
    // MARK: Outlets
    @IBOutlet weak var pageImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load page images
        self.pageImageView.image = pageImage
    }

}
