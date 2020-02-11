//
//  ViewController.swift
//  CameraFilter
//
//  Created by Fernando Martin Garcia Del Angel on 27/01/20.
//  Copyright © 2020 Fernando Martin Garcia Del Angel. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var applyFilterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
            let photosCVC = navigationController.viewControllers.first as? PhotosCollectionViewController else {
                fatalError("Segue destination is not available")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: {[weak self] photo in
            self?.updateUI(with: photo)
            
            }).disposed(by: disposeBag)
        
    }
    
    @IBAction func applyFilterButtonPressed(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.photoImageView.image = filteredImage
            }
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        DispatchQueue.main.async {
            self.photoImageView.image = image
            self.applyFilterButton.isHidden = false
        }
    }


}

