//
//  ViewController.swift
//  ParqueFarroupilha
//
//  Created by IOS SENAC on 04/05/2019.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate {
   
    
    
    @IBOutlet weak var listaCodigo: UIPickerView!
    @IBOutlet weak var onibusSearchBar: UISearchBar!
    
    @IBOutlet weak var nomeOnibusTextView: UITextField!
    

    
    
    var onibus: [Onibus] = []
    var filtroOnibus: [Onibus] = []
    var idlinha: String = ""
    var dadosLinha: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.listaCodigo.delegate = self
        self.listaCodigo.dataSource = self
        onibusSearchBar.delegate = self
       loadNewOnibus()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func verItinerario(_ sender: Any) {
        loadNewLinha()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtroOnibus = searchText.isEmpty ? onibus : onibus.filter { (item: Onibus) -> Bool in
            // If dataItem matches the searchText, return true to include it
            
            if item.codigo.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil  ||
                item.nome.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil{
                return true
            }else{
                return false
            }
            
            
            
        }
        
        listaCodigo.reloadAllComponents()
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue"{
            let viewController = segue.destination as? MapViewController
           viewController?.onibus = onibus
        }
        
        
    }*/
    
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filtroOnibus.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(filtroOnibus[row].codigo) - \(filtroOnibus[row].nome)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.idlinha = self.filtroOnibus[row].id
    }

func loadNewOnibus(){
    Service.getOnibus{ onibus in
        if let onibus = onibus {
            self.onibus = onibus
            self.filtroOnibus = onibus
            
            //let dataImage = try? Data(contentsOf: onibus.picture)
            //if let imageData = dataImage, let image = UIImage(data: imageData) {
            
        }
        OperationQueue.main.addOperation {
            self.listaCodigo.reloadAllComponents()
        }
        
        
    }
}
    
   
    func loadNewLinha(){
        let configuration = URLSessionConfiguration.default
        //Setar para aguardar conexão
        configuration.waitsForConnectivity = true
        
        //Criar uma sessão com a configuração
        let session = URLSession(configuration: configuration)
        let url = URL(string: "http://www.poatransporte.com.br/php/facades/process.php?a=il&p=\(self.idlinha)")!
        let task = session.dataTask(with: url){ (data,response,error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else{
                    
                    return
            }
            guard let data = data else{
                return
            }
            if let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
                self.dadosLinha = result
               
                print(self.dadosLinha)
            }
        }
        task.resume()
    }
}
struct Service {
    
    static func getOnibus(completion: @escaping ([Onibus]?) -> Void){
        
        
        
        let configuration = URLSessionConfiguration.default
        //Setar para aguardar conexão
        configuration.waitsForConnectivity = true
        
        //Criar uma sessão com a configuração
        let session = URLSession(configuration: configuration)
        let url = URL(string: "http://www.poatransporte.com.br/php/facades/process.php?a=nc&t=o")!
        let task = session.dataTask(with: url){ (data,response,error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else{
                    
                    return
            }
            guard let data = data else{
                return
            }
            /*if let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
                
                print(result)
            }*/
            do{
                let decoder = JSONDecoder()
                let onibus = try decoder.decode([Onibus].self, from: data)
                //print(onibus)
                completion(onibus)
            }catch{
                print("Error \(error)")
            }
        }
        task.resume()
        
        
    }
    
    func getLinha(){
        
    }
}


struct Onibus: Codable{
    let id: String
    let codigo: String
    let nome: String
    
    
    private enum CodingKeys: String, CodingKey {
        case id, codigo, nome
    }
}


@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

@IBDesignable
class DesignableImage: UIImageView {
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
}





