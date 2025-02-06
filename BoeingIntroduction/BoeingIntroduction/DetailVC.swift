//
//  DetailVC.swift
//  BoeingIntroduction
//
//  Created by batuhan on 5.02.2025.
//

import UIKit

class DetailVC: UIViewController {
    
    
    var page : Page
    
    init(page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
     
        set()

    }
    
    
    func set(){
        let image = page.images
        let imageView =  UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive   = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive                = true
        
     
        let headerView           = UILabel()
        headerView.text          = page.title
        headerView.font          = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerView.numberOfLines = 0
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 30).isActive      = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive            = true
        headerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        let textView           = UILabel()
        textView.text          = page.desc
        textView.font          = UIFont.systemFont(ofSize: 16, weight: .medium)
        textView.textColor     = UIColor.black.withAlphaComponent(0.6)
        textView.numberOfLines = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: headerView.bottomAnchor,constant: 10).isActive        = true
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive    = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
}



enum Page {
    case screen
    case seats
    case cabinPressure
    case economySeats
    case foodService
    
    
    var images : UIImage {
        switch self {
        case .screen:
           return UIImage(named: "screen")!
        case .seats:
            return UIImage(named:"seats")!
        case .cabinPressure:
            return UIImage(named:"ecoseats")!
        case .economySeats:
            return UIImage(named:"ecoseats")!
        case .foodService :
            return UIImage(named:"foodService")!
        }
    }
    
    var title : String {
        switch self {
        case .screen:
            "Uçak içi eğlence sistemi"
        case .seats:
            "Rahat koltuklar"
        case .cabinPressure:
            "Geliştirilmiş kabin basıncı"
        case .economySeats:
            "Konforlu yolculuk"
        case .foodService:
            "Uçak içi ikram"
        }
    }
    
    var desc : String {
        switch  self {
        case .screen:
            "Uçak içi eğlence sistemimizde yer verdiğimiz en yeni içeriklerle arşivimizi daha da zenginleştirdik. Farklı zevklere hitap eden en eğlenceli filmler, müzikler, oyunlar ve daha birçok yeni içerikle yolculuk keyfiniz katlanarak artacak!"
        case .seats:
            "Business Class kabindeki yatağa dönüşebilen koltuklar sayesinde Boeing 777-300ER ile uçmak çok rahat."
        case .cabinPressure:
            "Geliştirilmiş kabin basıncı ile Boeing 777-300ER, yolcu konforunu maksimuma çıkarır. Seyahatinizin ardından daha dinç hissetmeye hazırlanın."
        case .economySeats :
            "Ferah kabini, geniş koltuk aralığı ve diz mesafesi ile ödüllü uçak, size konforlu bir uçuş deneyimi yaşatacak."
        case .foodService:
            "Bulutların üstünde dünyanın en iyi lezzetlerini Türk Hava Yolları farkıyla keşfetmeye ne dersiniz? Türk konukseverliğini, uçan şeflerimiz tarafından hazırlanan dünya ve Türk mutfağından en özel tatlarla birleştiriyor, yolcularımıza eşsiz bir uçuş deneyimi sunuyoruz. Lüks restoranlara rakip olabilecek ödüllü lezzetlerimizle tanışın, konforlu yolculuğun keyfini ikiye katlayın!"
        }
    }
}
