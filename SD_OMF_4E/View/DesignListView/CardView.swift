//
//  CardView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct CardView: View {
    let design: Design

    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Steel  Connection")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Text(" \(design.connectionType) OMF AISC")
            }
            HStack{
                Label("\(design.creationDate.formattedDate)", systemImage: "clock.badge.checkmark")
                    .font(.caption)
                    .labelStyle(.trailingIcon)
                Spacer()
                Text("id: \(design.id)")
                    .bold()
            }
            HStack {
                Text("Project:")
                    .bold()
                    .accessibilityLabel("Project Name: \(design.project)")
                Text("\(design.project)")
                Spacer()
                Label("Designer: \(design.designers.count)", systemImage: "person.fill.checkmark")
                    .accessibilityLabel("\(design.designers.count) Designers")

            }
            .font(.caption)
        }
        .foregroundColor(design.theme.accentColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var design = Design.sampleData[0]
    static var previews: some View {
        CardView(design: design)
            .background(design.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
