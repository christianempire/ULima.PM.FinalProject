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

class Profile {
    let name : String
    let code : String
    let carrera : String
    let foto : String
    
    init(name : String, code : String, carrera : String, foto : String) {
        self.name = name
        self.code = code
        self.carrera = carrera
        self.foto = foto
    }
}

class Book {
    let title : String
    let author : String
    let career : Int
    let image : String
    
    init(title : String, author : String, career : Int, image : String) {
        self.title = title
        self.author = author
        self.career = career
        self.image = image
    }
}

class Firebase_Access {
    func GetProfile(userName: String, completition:@escaping (Profile)->Void) {
        Database.database().reference().child("users").child(userName).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            completition(Profile.init(name: value?["name"] as! String, code: userName, carrera: value?["carrera"] as! String, foto: value?["foto"] as! String))
        })
    }
    
    func GetBooks(_ completition:@escaping ([Book])->Void) {
        Database.database().reference().child("books").observe(.value, with: { (snapshot) in
            var books = [Book]()
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let bookRaw = snap.value as? NSDictionary
                
                books.append(Book(title: bookRaw?["title"] as! String, author: bookRaw?["author"] as! String, career: bookRaw?["career"] as! Int, image: bookRaw?["image"] as! String))
            }
            
            completition(books)
        })
    }
    
    func retrieve_book(barcode : String, completition:@escaping (Bool)->Void) {
        var return_value : Bool = false

        let rootRef = Database.database().reference()

        let booksRef: DatabaseReference = rootRef.child("books")
        let retrbookRef : DatabaseReference = booksRef.child(barcode)
        retrbookRef.observeSingleEvent(of: .value, with: { (snapshot) in
   
            if (snapshot.value as? NSDictionary) != nil{
                /*for value in val{
                    print(value)
                }*/
                return_value = true
                print("monkaS \(return_value)")
            } else {
                print("no")
            }
            completition(return_value)
        })
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
    
   /* func get_user_books(username: String, completition:@escaping ([Book])->Void) {
        Database.database().reference().child("users").child(username).child("prestamos").observe(.value, with: { (snapshot) in
            var books = [Book]()
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let bookRaw = snap.value as? NSDictionary
                let id = bookRaw?["id"] as! String
                
                self.get_book_info(book_id: id, completition: { (book) in
                    books.append(book)
                })
            }
            
            completition(books)
        })
    }*/
    
    func get_book_info(book_id : String, completition:@escaping (Book)->Void) {
        Database.database().reference().child("books").child(book_id).observe(.value, with: { (snapshot) in
            var book : Book
            let bookRaw = snapshot.value as? NSDictionary
            book = Book(title: bookRaw?["title"] as! String, author: bookRaw?["author"] as! String, career: bookRaw?["career"] as! Int, image: bookRaw?["image"] as! String)
      
            completition(book)
        })
    }
    
    func get_user_books() -> [Book]{
        var books : [Book] = []
        books.append(Book(title: "Ejemplo", author: "Chulls", career: 0, image: "https://firebasestorage.googleapis.com/v0/b/examen-final-moviles.appspot.com/o/9786074427059.jpg?alt=media&token=ca93adb5-c9af-4bfd-86bf-9717c7672fbc"))
        return books
    }
    
    
}

