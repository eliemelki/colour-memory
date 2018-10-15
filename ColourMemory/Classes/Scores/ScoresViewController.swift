//
//  ScoresViewController.swift
//  ColourMemory
//
//  Created by Elie Melki on 20/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit

class ScoreCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
}

class ScoresViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var barView: GameBarView!
    
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    var data = [String]()
    var presenter: ScorePresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DefaultScorePresenter(dataSource: DefaultScoreDataSource())
        self.presenter.attach(view: self)
        self.barView.rightActionBtn.addTarget(self, action: #selector(didTapActionBtn), for: .touchUpInside)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    @objc open func didTapActionBtn() {
        self .dismiss(animated: true, completion: nil)
    }
    
}

extension ScoresViewController : ScoreView {
    func showScores(scores: [GameScore]) {
        for (index,score) in scores.enumerated() {
            self.data.append(String(index+1))
            self.data.append(score.username)
            self.data.append(String(score.score))
            
        }
    }
}

extension ScoresViewController : UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        
        return self.data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoreCell",
                                                      for: indexPath)
        if let cell = cell as? ScoreCollectionViewCell {
            cell.labelText.text = self.data[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let  headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    
}

extension ScoresViewController : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem/2)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

