//
//  CardModel.swift
//  Match game
//
//  Created by Владимир Потапов on 12/11/20.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card]{
        
        //Массив с уже полученными рандомными числами
        var generatedNumbersArray = [Int]()
        //Массив для хранения сгенерированных карточек
        var generatedCardsArray = [Card]()
        
        //Рандомно генерируем набор карточек
        while generatedNumbersArray.count < 8 {
            
            //Получаем рандомное число
            let randomNumber = arc4random_uniform(13)+1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                //Выводим полученное число
                print(randomNumber)
                
                //Сохраняем полученное в массив полученных чисел
                generatedNumbersArray.append(Int(randomNumber))
                let  cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                //добавляем полученную карточку
                generatedCardsArray.append(cardOne)
                
                let  cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                //добавляем полученную карточку
                generatedCardsArray.append(cardTwo)
            }
    

        }
        
        for i in 0...generatedCardsArray.count - 1 {
            //Выбираем рандомное число
            let  randomNumber = arc4random_uniform(UInt32(generatedCardsArray.count))
            
            //Меняем карточки  местами
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[Int(randomNumber)]
            generatedCardsArray[Int(randomNumber)] = temporaryStorage
        }
        
        //return array
        return generatedCardsArray
    }
    
}
