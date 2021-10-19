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
    
    lazy var sesionesChart:PieChartView = {
        let ChartView = PieChartView()
        return ChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieView.addSubview(sesionesChart)
        sesionesChart.center(in: pieView)
        sesionesChart.width(to: pieView)
        sesionesChart.heightToWidth(of: pieView)
        
        usuarioControlador.getSexo(){ (result) in
            switch result{
            case .success(let sexo): self.sesionesChartActualiza(sexo);
                
            case .failure(let error):self.displayError(error, title: "No se pudo obtener el usuario")
            }
        }
       
        // Do any additional setup after loading the view.
    }
    
    func sesionesChartActualiza(_ variables:[Int]){

        
        let punto1 = PieChartDataEntry(value:Double(variables[0]),label:"Masculino")
        let punto2 = PieChartDataEntry(value:Double(variables[1]),label:"Femenino")
        let punto3 = PieChartDataEntry(value:Double(variables[2]),label:"Otro")
        
        var sesionesDataSet = PieChartDataSet(entries: [punto1,punto2,punto3])
        var data = PieChartData(dataSet: sesionesDataSet)
        

        
        var colors: [UIColor] = []


          
 
        let color1 = UIColor(red: CGFloat(50/255), green: CGFloat(255/255), blue: CGFloat(0/255), alpha: 1)
        let color2 = UIColor(red: CGFloat(50/255), green: CGFloat(55/255), blue: CGFloat(255/255), alpha: 1)
        let color3 = UIColor(red: CGFloat(255/255), green: CGFloat(0/255), blue: CGFloat(255/255), alpha: 1)
        colors.append(color1)
        colors.append(color2)
        colors.append(color3)
         
        
        sesionesDataSet.colors = colors
        
        sesionesChart.data = data
        sesionesChart.chartDescription?.text = "Porcentaje de sexo de los usuarios"
        sesionesChart.notifyDataSetChanged()
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
