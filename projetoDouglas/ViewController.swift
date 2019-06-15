//
//  ViewController.swift
//  Projeto Douglas
//
//  Created by IOS SENAC on 04/05/2019.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var onibusPickerView: UIPickerView!
    
    @IBOutlet weak var filtroSearchBar: UISearchBar!
    
    
    
    
    var onibus: [Onibus] = []
    var qtdeOnibus = 1
    var filtroOnibus: [Onibus] = []
    var linha: [Onibus] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
       
        
       loadNewOnibus()
        onibusPickerView.delegate = self
        onibusPickerView.dataSource = self
        filtroSearchBar.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itinerarioSegue"{
            let viewController = segue.destination as? MapViewController
           viewController?.onibus = linha
        }
        
        
    }
    
    @IBAction func verItnerarioButton(_ sender: Any) {
        carregarItinerario(linha: Onibus)
    }
    
    
    func carregarItinerario(linha:Onibus){
        Service.getItinerario{ linha in
            if let linha = linha{
                
            }
            
        }
    }

    func loadNewOnibus(){
        Service.getOnibus{ onibus in
            if let onibus = onibus {
            
            let queue = OperationQueue.main
            queue.addOperation {
                self.onibus = onibus
                self.filtroOnibus = onibus
                self.onibusPickerView.reloadAllComponents()
            }
            
            //let dataImage = try? Data(contentsOf: onibus.picture)
            //if let imageData = dataImage, let image = UIImage(data: imageData) {
            
        }
        
        
    }
}
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return self.filtroOnibus.count
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
       
            return self.filtroOnibus[row].codigo + " - " + self.filtroOnibus[row].nome
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        linha = [self.onibus[row]]
        print(self.onibus[row])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        filtroOnibus = searchText.isEmpty ? onibus : onibus.filter { (item: Onibus) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let pesquisaCodigo = item.codigo.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            let pesquisaNome = item.nome.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            
            if(pesquisaNome || pesquisaCodigo){
                return true
            }
            else{
                return false
            }
            
           
            
        }
        
        onibusPickerView.reloadAllComponents()
        
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
           // if let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
                //print(result)
                
            //}
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
    
    static func getItinerario(linha:Onibus){
        let configuration = URLSessionConfiguration.default
        //Setar para aguardar conexão
        configuration.waitsForConnectivity = true
        
        //Criar uma sessão com a configuração
        let session = URLSession(configuration: configuration)
        let url = URL(string: "http://www.poatransporte.com.br/php/facades/process.php?a=il&p="+linha.id)!
        let task = session.dataTask(with: url){ (data,response,error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else{
                    
                    return
            }
            guard let data = data else{
                return
            }
             if let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
            print(result)
            
            }
        }
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






