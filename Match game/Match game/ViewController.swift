//
//  ViewController.swift
//  Match game
//
//  Created by Владимир Потапов on 12/11/20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var timerLabel: UILabel!
    
    var model = CardModel ()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 40 * 1000 //50 секунд на выполнение
    
    var newGame = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray = model.getCards()

        collectionView.delegate = self
        collectionView.dataSource = self
         
        //Создаём таймер
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    //MARK: -Timer methods
    @objc func timerElapsed() {
        milliseconds -= 1
        
        //преобразуем значение времени в секунды
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //Задаём label
        timerLabel.text = "Time remaining: \(seconds)"
        
        //По достижении нуля
        if milliseconds == 0 {
            
            //Остановка таймера
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //Проверяем остались ли карточки
            checkGameEnded()
        }
    }
    
    //MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Получаем объект CardCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Получаем карточку, запрашиваемую для отображения
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        //cell.show()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        //Проверяем, осталось ли время
        if milliseconds <= 0 {
            return
        }
        
        
        let cell = collectionView.cellForItem(at:indexPath) as! CardCollectionViewCell
        
        //Получаем карточку выбранную пользователем
        let card = cardArray[indexPath.row]
        
        //
        if card.isFlipped == false && card.isMatched == false {
            //Переворачиваем карточку
            cell.flip()
            //Изменяем состояние карточки
            card.isFlipped = true
            
            //Определяем первая ли карточка
            if firstFlippedCardIndex == nil {
                
                //Помечаем первую выбранную карточку
                firstFlippedCardIndex = indexPath
    
            }
            else {
                checkForMatches(indexPath)
            }
        }
    }
    
    //MARK: - Game logic Methods

    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        
        //Получаем клетки двух проявленных карточек
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //Получаем карточки соответственно
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //Сравниваем карточки
        if cardOne.imageName == cardTwo.imageName {
            
            //Совпадение
            
            //Задаём статусы карточек
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //Пробуем удалить карточку
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //Проверяем остались ли еще карточки
            checkGameEnded()
            
        }
        else {
            
            //Несовпадение
            
            //Задаём статусы карточек
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //Пробуем перевернуть карточки назад
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()

        }
        
        //Перезагружаем карточку, если она нуль
        /*if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }*/
        
        //Сбрасываем значение первой карточки
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        
        //Определение наличия карточек
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        //Переменные хранения данных для отображения сообщения
        var title = ""
        var message = ""
        
        //Победа, если карточек не осталось
        if isWon == true {
            
            //Останавливаем таймер
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title  = "Поздравляем!"
            message = "Вы победили"
            newGame = true
        }
        else {
            //Если время кончилось - проигрыш
            if milliseconds > 0 {
                return
            }
            
            title  = "Игра окончена"
            message = "Вы проиграли"
            newGame = true
        }
        
        //Отображаем сообщение
        showAlert(title, message: message)
    }
    
    func showAlert(_ title:String, message:String) {
        
        //Отображаем сообщение
        let alert = UIAlertController (title: title,message: message, preferredStyle: .alert)
        let alertAction1 = UIAlertAction (title: "Ок", style: .default, handler: nil)
        let alertAction2 = UIAlertAction (title: "Заного", style: .default, handler: {_ in self.reset()})

        
        alert.addAction(alertAction1)
        alert.addAction(alertAction2)
        
        present(alert, animated: true, completion: nil)
    }
    
    func reset () {
        if newGame {
                    
            model = CardModel()
            cardArray = [Card]()
            cardArray = model.getCards()
            milliseconds = 40 * 1000
            timerLabel.textColor = UIColor.black
            collectionView.reloadData()
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .common)
        }
    }
} //Конец ViewController

