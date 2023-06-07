//
//  RTSelectCurrencyView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/6.
//

import SwiftUI

struct RTSelectCurrencyView: View {
    //MARK: - PROPERTIES
    
    
    //MARK: - VIEW
    var body: some View {
        List{
            
            ForEach(AllDollars.allCases, id:\.self){ dollar in
                Text("\(dollar.rawValue)")
            }
        }
    }
}


//MARK: - PREVIEW
struct RTSelectCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        RTSelectCurrencyView()
    }
}
