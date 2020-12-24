//
//  CardCollectionViewCell.swift
//  Match game
//
//  Created by Владимир Потапов on 12/11/20.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        
        
        //Определяем карточку
        self.card = card
        
        //Удостоверяемся, что использованные карточки сохранят состояние при повторном использовании клеток
        if card.isMatched == true {
            //Использованные - точно невидимы
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else  {
            //Неиспользованные - точно видимы
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        
        frontImageView.image = UIImage (named: card.imageName)
        
        //определяем состояние карточки
        if card.isFlipped == true {
            //Удостоверяемся в состоянии карточки "перевернута"
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromTop], completion: nil)
        }
        else {
            //Удостоверяемся в состоянии карточки "не перевернута"
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromBottom], completion: nil)
        }
    }
    
    func show() {
        frontImageView.alpha = 1
        backImageView.alpha = 1
    }
    
    func flip() {
        //Переворачиваем карточку
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromBottom, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        //Организовывем переворот карточки обратно, с задержкой
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.34) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromTop, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove() {
        
        //Удаление совпадающих карточек из view с небольшой задержкой
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.28, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0;
            
        }, completion: nil)

    }
}
