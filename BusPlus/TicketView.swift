//
//  TicketView.swift
//  TicketView
//
//  Created by Robin Phillips on 13/09/2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins


struct TicketView: View {
    enum Field {
        case firstName
        case lastName
        case ticketNumber
    }
    
    
    @EnvironmentObject private var ticketInfo: TicketInfo
    
    @FocusState private var focusField: Field?
    
    @State private var context = CIContext()
    @State private var filter = CIFilter.qrCodeGenerator()
    
    var qrCode: Image {
        let id = ticketInfo.firstName + ticketInfo.lastName + ticketInfo.ticketNumber
        let data = Data(id.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimg = UIImage(cgImage: cgimg)
                return Image(uiImage: uiimg)
            }
            
        }
        return Image(systemName: "xmark.circle")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("First name", text: $ticketInfo.firstName)
                        .focused($focusField, equals: .firstName)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                    TextField("Last name", text: $ticketInfo.lastName)
                        .focused($focusField, equals: .lastName)
                        .textContentType(.familyName)
                        .submitLabel(.next)
                    TextField("Ticket number", text: $ticketInfo.ticketNumber)
                        .focused($focusField, equals: .ticketNumber)
                        .keyboardType(.numberPad)
                        .submitLabel(.done)
                    
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    focusField = nil
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                }
                .onSubmit {
                    switch focusField {
                    case .firstName: focusField = .lastName
                    case .lastName: focusField = .ticketNumber
                    default: focusField = nil
                    }
                }
                
                Section {
                    qrCode
                        .resizable()
                        .interpolation(Image.Interpolation.none)
                        .scaledToFit()
                }
                .navigationTitle("Ticket")
            }
        }
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView()
    }
}
