//
//  SegmentedControl.swift
//  ChatApp
//
//  Created by Sugandhi Hansika Kalansooriya on 2023-06-03.
//
import SwiftUI
import UIKit

struct ColoredSegmentedControl: UIViewRepresentable {
    @Binding var selectedSegment: Int
    var titles: [String]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.selectedSegmentIndex = selectedSegment
        segmentedControl.addTarget(context.coordinator, action: #selector(Coordinator.updateSelectedSegment(sender:)), for: .valueChanged)
        return segmentedControl
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = selectedSegment
        uiView.selectedSegmentTintColor = .red // Set the color you want here.
    }
    
    class Coordinator: NSObject {
        var control: ColoredSegmentedControl
        
        init(_ control: ColoredSegmentedControl) {
            self.control = control
        }
        
        @objc func updateSelectedSegment(sender: UISegmentedControl) {
            control.selectedSegment = sender.selectedSegmentIndex
        }
    }
}
