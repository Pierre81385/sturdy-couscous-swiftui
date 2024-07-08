//
//  VShiftLayout.swift
//  fluffy-tribble
//
//  Created by m1_air on 7/7/24.
//

import Foundation
import SwiftUI

struct VShiftLayout: View {
    
    @Namespace private var animation
    @State private var togglePanel: Bool = true
    
    var body: some View {
        GeometryReader { proxy in
            VStack{
                    ZStack{
                        Color(.black)
                        GroupBox(content: {
                            HStack{
                                Spacer()
                                VStack{
                                    Spacer()
                                    if(!togglePanel){
                                        Button(action: {
                                            withAnimation {
                                                togglePanel.toggle()
                                            }
                                        }, label: {
                                            Image(systemName: "chevron.down").tint(.black)
                                        })
                                    } else {
                                        TOTPView()
                                    }
                                }
                                Spacer()
                            }
                        }).groupBoxStyle(CardGroupBoxStyleTop())
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: -4, trailing: 0))
                    .ignoresSafeArea()
                    ZStack{
                        Color(.white)
                        GroupBox(content: {
                            HStack{
                                Spacer()
                                VStack{
                                    if(togglePanel) {
                                        Button(action: {
                                            withAnimation {
                                                togglePanel.toggle()
                                            }
                                        }, label: {
                                            Image(systemName: "chevron.up").tint(.white)
                                        })
                                    } else {
                                        QRCodeGen()
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                        }).groupBoxStyle(CardGroupBoxStyleBottom())
                            .ignoresSafeArea()
                    }.frame(width: proxy.size.width, height: togglePanel ? proxy.size.height * 0.20 : proxy.size.height * 0.8)
                    .padding(EdgeInsets(top: -4, leading: 0, bottom: 0, trailing: 0))
                        
            }
        }
    }
}

#Preview {
    VShiftLayout()
}

struct CardGroupBoxStyleTop: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
        .background(Color.white)
        .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 75, topTrailingRadius: 0))
    }
}

struct CardGroupBoxStyleBottom: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
        .background(Color.black)
        .clipShape(.rect(topLeadingRadius: 75, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 0))
    }
}

