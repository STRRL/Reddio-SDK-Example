//
//  AssetSwitchView.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/6.
//

import SwiftUI

enum AssetType: String, CaseIterable, Identifiable {
    case Layer1
    case Layer2
    var id: Self { self }
}

struct AssetSwitchView: View {
    @Binding var selectedAssetType: AssetType

    var body: some View {
        Picker("Asset Type", selection: $selectedAssetType) {
            ForEach(AssetType.allCases) { item in
                Text(item.rawValue.capitalized).tag(item.rawValue)
            }
        }.pickerStyle(.segmented)
    }
}

struct AssetSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selected = AssetType.Layer2
        AssetSwitchView(selectedAssetType: $selected)
    }
}
