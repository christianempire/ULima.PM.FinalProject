//
//  Firebase_Access.swift
//  EFProgramacion
//
//  Created by Rodrigo on 7/19/18.
//  Copyright © 2018 E4409. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class User {
    let UserId : Int
    let Career : Career
    let Name : String
    let Photo : String
    
    init(userId : Int, career : Career, name : String, photo : String) {
        UserId = userId
        Career = career
        Name = name
        Photo = photo
    }
}

class Book {
    let BookId : Int
    let Author : String
    let Career : Career
    let Image : String
    let Title : String
    
    init(bookId : Int, author : String, career : Career, image : String, title : String) {
        BookId = bookId
        Author = author
        Career = career
        Image = image
        Title = title
    }
}

class Career {
    let CareerId : Int
    let Name : String
    
    init(careerId : Int, name : String) {
        CareerId = careerId
        Name = name
    }
}

class Lending {
    let LendingId : Int
    let Book : Book
    let ExpiringDate : String
    let Returned : Bool
    let Transferred : Bool
    let User : User
    
    init(lendingId : Int, book : Book, expiringDate : String, returned : Bool, transferred : Bool, user : User) {
        LendingId = lendingId
        Book = book
        ExpiringDate = expiringDate
        Returned = returned
        Transferred = transferred
        User = user
    }
}

class Firebase_Access {
    func GetUsers(_ completition:@escaping ([User])->Void) {
        
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            var users = [User]()
            var counter = 0
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let userRaw = snap.value as? NSDictionary
                let userId = Int(snap.key)!
                let careerId = userRaw?["career_id"] as! Int
                let name = userRaw?["name"] as! String
                let photo = userRaw?["photo"] as! String
                
                self.GetCareerById(careerId: careerId) { (career) in
                    users.append(User(userId: userId, career: career, name: name, photo: photo))
                    
                    counter = counter + 1
                    
                    if counter == snapshot.childrenCount {
                        completition(users);
                    }
                }
            }
        })
    }
    
    func GetUserById(userId: Int, completition:@escaping (User)->Void) {
    Database.database().reference().child("users").child(String(userId)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let careerId = value?["career_id"] as! Int
            let name = value?["name"] as! String
            let photo = value?["photo"] as! String
        
            self.GetCareerById(careerId: careerId) { (career) in
                completition(User(userId: userId, career: career, name: name, photo: photo))
            }
        })
    }
    
    func GetBooks(_ completition:@escaping ([Book])->Void) {
        
        Database.database().reference().child("books").observe(.value, with: { (snapshot) in
            var books = [Book]()
            var counter = 0
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let bookRaw = snap.value as? NSDictionary
                let bookId = Int(snap.key)!
                let author = bookRaw?["author"] as! String
                let careerId = bookRaw?["career_id"] as! Int
                let image = bookRaw?["image"] as! String
                let title = bookRaw?["title"] as! String
                
                self.GetCareerById(careerId: careerId) { (career) in
                    books.append(Book(bookId: bookId, author: author, career: career, image: image, title: title))
                    
                    counter = counter + 1
                    
                    if counter == snapshot.childrenCount {
                        completition(books);
                    }
                }
            }
        })
    }
    
    func GetBookById(bookId: Int, completition:@escaping (Book)->Void) {
    Database.database().reference().child("books").child(String(bookId)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let bookId = Int(snapshot.key)!
            let author = value?["author"] as! String
            let careerId = value?["career_id"] as! Int
            let image = value?["image"] as! String
            let title = value?["title"] as! String
        
            self.GetCareerById(careerId: careerId) { (career) in
                completition(Book(bookId: bookId, author: author, career: career, image: image, title: title))
            }
        })
    }
    
    func GetCareers(_ completition:@escaping ([Career])->Void) {
        
        Database.database().reference().child("careers").observe(.value, with: { (snapshot) in
            var careers = [Career]()
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let careerRaw = snap.value as? NSDictionary
                let careerId = Int(snap.key)!
                let name = careerRaw?["name"] as! String
                
                careers.append(Career(careerId: careerId, name: name))
            }
            
            completition(careers)
        })
    }
    
    func GetCareerById(careerId: Int, completition:@escaping (Career)->Void) {
    Database.database().reference().child("careers").child(String(careerId)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let careerId = Int(snapshot.key)!
            let name = value?["name"] as! String

            completition(Career(careerId: careerId, name: name))
        })
    }
    
    func GetLendings(completition:@escaping ([Lending])->Void) {
        Database.database().reference().child("lendings").observe(.value, with: { (snapshot) in
            var lendings = [Lending]()
            var counter = 0
        
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let lendingRaw = snap.value as? NSDictionary
                let lendingId = Int(snap.key)!
                let bookId = lendingRaw?["book_id"] as! Int
                let expiringDate = lendingRaw?["expiringDate"] as! String
                let returned = lendingRaw?["returned"] as! Int
                let transferred = lendingRaw?["transferred"] as! Int
                let userId = lendingRaw?["user_id"] as! Int
                
                self.GetBookById(bookId: bookId) { (book) in
                    self.GetUserById(userId: userId) { (user) in
                        lendings.append(Lending(lendingId: lendingId, book: book, expiringDate: expiringDate, returned: returned == 1, transferred: transferred == 1, user: user))
                        
                        counter = counter + 1
                        
                        if counter == snapshot.childrenCount {
                            completition(lendings);
                        }
                    }
                }
            }
        })
    }
    
    func LendBookToUser(bookId : Int, userId : Int, completition:@escaping (Lending)->Void) {
        let lendingId = Int(Date().timeIntervalSince1970)
        let newLending = Database.database().reference().child("lendings").child(String(lendingId))
        let formatter  = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy"
        
        let expiringDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
        
        newLending.child("book_id").setValue(bookId)
        newLending.child("expiring_date").setValue(formatter.string(from: expiringDate!))
        newLending.child("returned").setValue(0)
        newLending.child("transferred").setValue(0)
        newLending.child("user_id").setValue(userId)
        
        self.GetBookById(bookId: bookId) { (book) in
            self.GetUserById(userId: userId) { (user) in
                completition(Lending(lendingId: lendingId, book: book, expiringDate: formatter.string(from: expiringDate!), returned: false, transferred: false, user: user))
            }
        }
    }
    
    func TransferLendingToUser(lendingkId : Int, userId : Int, completition:@escaping (Lending)->Void) {
        
    }
    
    func register_checkout(book_id : String, username : String){
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        let checkout = ref.child("users").child(username).child("prestamos").child(book_id)

        let checkoutdate = checkout.child("f_caducidad")
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let days = 5
        
        let newDate = Calendar.current.date(byAdding: .day, value: days, to: Date())
        let id = checkout.child("id")
        id.setValue(book_id)
        let result = formatter.string(from: newDate!)
        
        checkoutdate.setValue(result)
        
    }

}

