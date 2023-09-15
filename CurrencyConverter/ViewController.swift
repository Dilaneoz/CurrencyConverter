//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Atil Samancioglu on 6.08.2019.
//  Copyright © 2019 Atil Samancioglu. All rights reserved.
//

import UIKit

// api larla birlikte bir sunucudan bir programa ya da bir mobil uygulamaya veri aktarımını kolay bir şekilde yapabiliyoruz. cloud da duran bir web sitesinden, portaldan, facebooktan vs büyük portallardan bize bazı veriler sağlanabiliyor. illa büyük olmasına da gerek yok sırf bunun için kurulmuş bir şirkette olabilir. bu verileri alıp kendi uygulamamızda işleyebiliyoruz. mesela facebook for developers ile face i kullanarak facebooktaki verileri çekebiliriz. bu şirketlerin bunu yapmasının sebebi, geliştiriciler mesela facebookla ilgili bir işlem ya da bunlara yardımcı olan uygulamalar yapmak istediklerinde kolaylık sağlamak.bu verileri api lar aracılığıyla bize ulaştırıyolar. biz de aldığımız verileri kendi uygulamamızda işleyerek kullanıcıya sunabiliyoruz. sadece facebook vs değil mesela hava durumu api ıda var, döviz çevirme api ıda var. döviz çevirme api ını googlea currency converter api yazarak fixer.io isimli siteden ücretsiz çekmiş hoca. ücretsizde ayda sadece 1000 sorgu yapma izni veriyor, güncellemeyi saatte bir yapıyor. paralı alınırsa daha özellikler artıyor
// json ise javascript obje gösterme formatıdır, yani veri gösterme, veri alışverişi yapma formatı. karmaşık verileri yapısal bir şekilde göstermeye yarayan bir gösterim formatı. fixer a üye olduktan sonra your api access key i kullanarak json dosyasını çekicez. bu verileri aldıktan sonra işleyebilmek için dictionary leri kullanıcaz. fixer da ducumentation a gelip append your api key kısmındaki web sayfasını arama çubuğuna kopyalayıyoruz. sonundaki API_KEY kısmını silip your api access key i yapıştırıyoruz. burada uygulamamıza aktarıcağımız veriler olucak. uygulamamızda bir request oluşturucaz. sonra internete gidip bu verileri alıcak ve bize yazdırıcak. sonrasında biz bunu bir dictioary gibi kaydedicez ve tek tek istediğimiz değerleri çekicez. json beautifier programları ile json verilerini daha düzgün ve sıralı göstertebiliriz
// info plist e app transport security settings i ekliyoruz. sonra solunda çıkan oka tıklıyoruz. ok aşağı yöne dönücek. sonra tekrar artıya basıyoruz. orada allow arbitrary loads u ekliyoruz. sağda da no yu yes yapıyoruz. bunu yapınca http bağlantılara izin vermiş oluyoruz

class ViewController: UIViewController {
    
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func getRatesClicked(_ sender: Any) {
        
        // 1) Request & Session -> veri çekerken üç aşama vardır. ilki ilgili web adresine gitmek için talep oluşturma
        // 2) Response & Data -> bu isteği almak
        // 3) Parsing & JSON Serialization -> bu datayı işleme. parsing ya da JSON Serialization deniyor işleme işlemine
        
        
        // 1. data için istekte bulunduk
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=4a990ae1cc0ef5a920e4c7e9eeb1123c") // ilgili url ye istekte bulunuyoruz
        
        let session = URLSession.shared // istediğimiz ağa gidip veri alışverisi yapmak için URLSession bunu kullanırız. URLSession ın bir singleton objesini oluşturucaz. yani uygulama içerisinde buu nereden çağırırsak çağıralım bu sınıftan bu objeyi çağırmış olucak. o yüzden birden fazla aynı anda bir sürü istek yaparsak karışıklık yaşanmıycak. hep aynı obje üzerinden gidecek bu istekler
        
        //Closure
        
        let task = session.dataTask(with: url!) { (data, response, error) in // completion handler yapısı. with: url! bu kısımda bir input veriliyor. bunun karşılığında (data, response, error)/veri,cevap ve hata bu kısım bir output vericek. bu sayede cevap geldi mi gelmedi mi hata mı verdi gibi kontrolleri yapabilicez. yani bu fonksiyonu çağırıyoruz ve karşılığında bir çıktı bekliyoruz o bize çıktıyı bir closure içinde veriyor
            if error != nil { // eğer hata mesajı varsa
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil) // hata mesajını göstericek
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else { // hata mesajı yoksa
                // 2. datayı aldık işliycez
                if data != nil { // data boş değilse
                    do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any> // bir json result objesi oluşturuyoruz. json formatını işlemek için. JSONSerialization json ı alıp objeleri tek tek oluşturuyor. mutableContainers ile sözlükleri kullanıyoruz.
                        
                        //ASYNC
                        
                        DispatchQueue.main.async { // bu işlem arka planda yapılıyor. internetten bir veri indirdiğimiz için bunu aynı traitte yapamıyoruz çünkü kullanıcı arayüzü kilitlenebilir. daha önce de count down timer ler kullanmıştık arka planda dönmesi için
                            if let rates = jsonResponse["rates"] as? [String : Any] {
                                //print(rates)
                                
                                if let cad = rates["CAD"] as? Double { // para birimlerinin değerlerini alıyoruz. bunları classlar ya da modeller oluşturarak da yapabilirdik. mantığını anlamamız için hoca bu şekilde yaptı
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                
                                if let chf = rates["CHF"] as? Double {
                                    self.chfLabel.text = "CHF: \(chf)"
                                }
                                
                                if let gbp = rates["GBP"] as? Double {
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                                
                                if let jpy = rates["JPY"] as? Double {
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                                
                                if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                
                                if let turkish = rates["TRY"] as? Double {
                                    self.tryLabel.text = "TRY: \(turkish)"
                                }
                            }
                        }
                    } catch {
                       print("error")
                    }
                }
            }
        }
        task.resume() // bunu demeden işlem başlamaz
    }

}

