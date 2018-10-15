//
//  ViewController.swift
//  ColourMemory
//
//  Created by Elie Melki on 19/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit

class GameViewCell : UICollectionViewCell {
    
    @IBOutlet weak var cardView: CardView!
    
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameBarView: GameBarView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var userViewController : UserViewController?
    
    fileprivate let itemsPerRow: CGFloat = 4
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var presenter: GamePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DefaultGamePresenter(gameDataSource: DefaultGameDataSource(), scoreDataSource: DefaultScoreDataSource())
        self.presenter.attach(view: self)
        self.gameBarView.rightActionBtn.addTarget(self, action: #selector(didTapActionBtn), for: .touchUpInside)
        
    }

   
    
    @objc open func didTapActionBtn() {
       self.performSegue(withIdentifier: "gotoHighScores", sender: nil)
    }
    
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override  var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override  var shouldAutorotate: Bool {
        return true
    }
 
 
}

extension GameViewController : UserViewDelegate {
    func didSave(user: String) {
        self.presenter.saveUser(user: user)
    }
    
}

extension GameViewController : GameView {
    
    
    func showUserUI(with message: String) {
  
        guard let userViewController = self.storyboard?.instantiateViewController(withIdentifier: "usercontroller") as? UserViewController else {
            return
        }
        
        userViewController.delegate = self
        self.addChildViewController(userViewController)
        self.userViewController = userViewController
        let userView = userViewController.view!
        userViewController.showMessage(message)
        userView.translatesAutoresizingMaskIntoConstraints = false
       
        
        self.view.addSubview(userView)
        let widthConstraint = NSLayoutConstraint(item: userView, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300)
        
        
        let xConstraint = NSLayoutConstraint(item: userView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: userView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)

     
        self.view.addConstraints([widthConstraint, xConstraint, yConstraint])
        userView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            userView.alpha = 1
        }
    }
    
    func reloadGame() {
        self.collectionView.reloadData()
        if let userviewController = self.userViewController {
            userviewController.removeFromParentViewController()
            userviewController.view.removeFromSuperview()
            self.userViewController = nil
        }
    }
    
    func openCard(at: Int) {
        if let cell = self.collectionView.cellForItem(at: IndexPath(row: at, section: 0)) as? GameViewCell {
            cell.cardView.openCard(animated: true)
        }
    }
    
    func closeCard(at: Int) {
        if let cell = self.collectionView.cellForItem(at: IndexPath(row: at, section: 0)) as? GameViewCell {
            cell.cardView.closeCard(animated: true)
        }
    }
    
    func showScore(value: Int) {
        self.gameBarView.titleLabel.text = String(value)
    }
    
    func blockView() {
        self.collectionView.isUserInteractionEnabled = false
    }
    
    func unblockView() {
         self.collectionView.isUserInteractionEnabled = true
    }
}

extension GameViewController : UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
       return self.presenter.cardsCount()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell",
                                                      for: indexPath)
        if let cell = cell as? GameViewCell {
            let image = self.presenter.cardImage(at: indexPath.row)
            let uiimage = UIImage(named: image)
            cell.cardView.openedImage = uiimage
            
            if (self.presenter.isCardOpened(at: indexPath.row)) {
                cell.cardView.openCard(animated: false)
            }else {
                cell.cardView.closeCard(animated: false)
            }
        }
        
        
        return cell
    }
}

extension GameViewController : UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.openCard(at: indexPath.row)

    }
}

extension GameViewController : UICollectionViewDelegateFlowLayout {
   
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 4/3)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
 
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}



