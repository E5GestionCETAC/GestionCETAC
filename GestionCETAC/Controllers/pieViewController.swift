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
    
    let colors = [NSUIColor(red: 121/255, green: 173/255, blue: 220/255, alpha: 1),NSUIColor(red: 255/255, green: 192/255, blue: 159/255, alpha: 1),NSUIColor(red: 255/255, green: 238/255, blue: 147/255, alpha: 1),NSUIColor(red: 252/255, green: 245/255, blue: 199/255, alpha: 1),NSUIColor(red: 160/255, green: 206/255, blue: 217/255, alpha: 1),NSUIColor(red: 137/255, green: 247/255, blue: 182/255, alpha: 1)]
    
    @IBOutlet weak var pieView: UIView!
    
    @IBOutlet weak var edadView: UIView!
    
    
    lazy var userSexoChart:PieChartView = {
        let ChartView = PieChartView()
        ChartView.holeColor = .clear
        ChartView.legend.enabled = false
        return ChartView
    }()
    
    lazy var topFiveEdades: PieChartView = {
        let ChartView = PieChartView()
        ChartView.holeColor = .clear
        ChartView.legend.enabled = false
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
            case .success(let sexos):self.userSexoChartActualiza(sexos)
            case .failure(let error):print(error)
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 100
        let total:Double = Double(variables[0]) + Double(variables[1]) + Double(variables[2])
        let punto1 = PieChartDataEntry(value:Double(variables[0])/total,label:"Masculino")
        let punto2 = PieChartDataEntry(value:Double(variables[1])/total,label:"Femenino")
        let punto3 = PieChartDataEntry(value:Double(variables[2])/total,label:"Otro")
        
        let sesionesDataSet = PieChartDataSet(entries: [punto1,punto2,punto3])
        sesionesDataSet.colors = colors
        sesionesDataSet.colors = colors
        sesionesDataSet.valueFont = .boldSystemFont(ofSize: 14)
        sesionesDataSet.valueTextColor = .darkGray
        sesionesDataSet.entryLabelFont = .boldSystemFont(ofSize: 14)
        sesionesDataSet.entryLabelColor = .darkGray
        let data = PieChartData(dataSet: sesionesDataSet)
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        userSexoChart.data = data
        userSexoChart.notifyDataSetChanged()
    }
    
    func topFiveEdades(_ motivos:[(key:Int, value:Int)]){
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 100
        var total:Double = 0
        for i in 0..<motivos.count{
            total += Double(motivos[i].value)
        }
        let sliceOne = PieChartDataEntry(value: Double(motivos[0].value)/total, label:"\(motivos[0].key)")
        let sliceTwo = PieChartDataEntry(value: Double(motivos[1].value)/total, label:"\(motivos[1].key)")
        let sliceThree = PieChartDataEntry(value: Double(motivos[2].value)/total, label:"\(motivos[2].key)")
        let sliceFour = PieChartDataEntry(value: Double(motivos[3].value)/total, label:"\(motivos[3].key)")
        let sliceFive = PieChartDataEntry(value: Double(motivos[4].value)/total, label:"\(motivos[4].key)" )
        
        let sliceSix = PieChartDataEntry(value: (Double(total) - Double(motivos[0].value) - Double(motivos[1].value) - Double(motivos[2].value) - Double(motivos[3].value) - Double(motivos[4].value))/total, label:"Otros" )
        let dataSet = PieChartDataSet(entries:[sliceOne,sliceTwo,sliceThree,sliceFour,sliceFive,sliceSix])
        dataSet.colors = colors
        dataSet.valueFont = .boldSystemFont(ofSize: 14)
        dataSet.valueTextColor = .darkGray
        dataSet.entryLabelFont = .boldSystemFont(ofSize: 14)
        dataSet.entryLabelColor = .darkGray
        let data = PieChartData(dataSet:dataSet)
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
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
