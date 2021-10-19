//
//  pieViewController.swift
//  GestionCETAC
//
//  Created by Diógenes Grajales Corona on 16/10/21.
//

import UIKit
import Charts
import TinyConstraints

class pieViewController: UIViewController {
    
    let usuarioControlador = usuarioController()
    

    @IBOutlet weak var pieView: UIView!
    
    @IBOutlet weak var edadView: UIView!
    
    
    lazy var userSexoChart:PieChartView = {
        let ChartView = PieChartView()
        return ChartView
    }()
    
    lazy var topFiveEdades: PieChartView = {
        let ChartView = PieChartView()
        return ChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieView.addSubview(userSexoChart)
        userSexoChart.center(in: pieView)
        userSexoChart.width(to: pieView)
        userSexoChart.heightToWidth(of: pieView)
        
        edadView.addSubview(topFiveEdades)
        topFiveEdades.center(in: edadView)
        topFiveEdades.width(to: edadView)
        topFiveEdades.heightToWidth(of: edadView)
        
        
        
        usuarioControlador.getSexo(){ (result) in
            switch result{
            case .success(let sexos): self.userSexoChartActualiza(sexos);
                
            case .failure(let error):self.displayError(error, title: "No se pudo obtener el usuario")
            }
        }
        
        usuarioControlador.fetchEdades(){(result) in
            switch result{
            case.success(let edades): self.topFiveEdades(edades);
            case.failure(let error): print(error)
            }
        }
       
        // Do any additional setup after loading the view.
    }
    
    func userSexoChartActualiza(_ variables:[Int]){

        
        let punto1 = PieChartDataEntry(value:Double(variables[0]),label:"Masculino")
        let punto2 = PieChartDataEntry(value:Double(variables[1]),label:"Femenino")
        let punto3 = PieChartDataEntry(value:Double(variables[2]),label:"Otro")
        
        var sesionesDataSet = PieChartDataSet(entries: [punto1,punto2,punto3],label: "Porcentaje de usuarios por sexo")
        var data = PieChartData(dataSet: sesionesDataSet)
        
        
        var colors: [NSUIColor] = []

        let color1 = NSUIColor(red: 255/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
        let color2 = NSUIColor(red: 0/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
        let color3 = NSUIColor(red: 64/255.0, green: 89/255.0, blue: 128/255.0, alpha: 1.0)
        
        colors.append(color1)
        colors.append(color2)
        colors.append(color3)
         
        sesionesDataSet.colors = colors
        
        userSexoChart.data = data
        userSexoChart.notifyDataSetChanged()
    }
    
    func topFiveEdades(_ motivos:[(key:Int, value:Int)]){
        
        var total = 0
        let sliceOne = PieChartDataEntry(value: Double(motivos[0].value), label:String(motivos[0].key) )
        let sliceTwo = PieChartDataEntry(value: Double(motivos[1].value), label:String(motivos[1].key ))
        let sliceThree = PieChartDataEntry(value: Double(motivos[2].value), label:String(motivos[2].key))
        let sliceFour = PieChartDataEntry(value: Double(motivos[3].value), label:String(motivos[3].key))
        let sliceFive = PieChartDataEntry(value: Double(motivos[4].value), label:String(motivos[4].key))
        for i in 5..<motivos.count{
            total += motivos[i].value
        }
        
        let sliceSix = PieChartDataEntry(value: Double(total), label:"Otros" )
        let dataSet = PieChartDataSet(entries:[sliceOne,sliceTwo,sliceThree,sliceFour,sliceFive,sliceSix], label: "Top 5 Edades")
        
        dataSet.colors = ChartColorTemplates.pastel()
        
        let data = PieChartData(dataSet:dataSet)
        topFiveEdades.data = data
        topFiveEdades.notifyDataSetChanged()
    }
    
    
    
    
    func displayError(_ error: Error, title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
