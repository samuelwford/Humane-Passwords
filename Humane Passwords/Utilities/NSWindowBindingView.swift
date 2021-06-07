//
//  NSWindowReader.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/7/21.
//

import SwiftUI

extension View {
    /// Reads the `NSWindow` containing the view.
    /// - Parameter reader: closure passed the `NSWindow` containing the view
    func windowReader(_ reader: @escaping (NSWindow) -> Void) -> some View {
        modifier(NSWindowReaderModifier(reader: reader))
    }
}

/// View modifer that takes a closure and passes the `NSWindow` containing the view being modified.
struct NSWindowReaderModifier: ViewModifier {
    @State private var window: NSWindow?
    
    /// Reader function passed an optional `NSWindow`.
    let reader: (NSWindow) -> Void

    func body(content: Content) -> some View {
        content
            .background(NSWindowBindingView($window))
            .onChange(of: window, perform: { window in
                if let window = window {
                    reader(window)
                }
            })
    }
}

/// A non-visible view that reads the containing `NSWindow` it is placed into.
struct NSWindowBindingView: NSViewRepresentable {
    private final class NSWindowCapturingView: NSView {
        @Binding var capturedWindow: NSWindow?
        
        /// Creates a non-visible view that reads the `NSWindow` the view is placed into and
        /// updates the binding passed.
        /// - Parameter window: binding to an `NSWindow`
        init(window: Binding<NSWindow?>) {
            self._capturedWindow = window
            super.init(frame: .zero)
        }

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            capturedWindow = window
        }

        required init?(coder: NSCoder) {
            fatalError()
        }
    }

    @Binding var window: NSWindow?
    
    /// Creates a non-visible view that reads the `NSWindow` it is placed into
    /// updating the binding supplied.
    /// - Parameter window: the current `NSWindow` containing the view
    init(_ window: Binding<NSWindow?>) {
        self._window = window
    }

    func makeNSView(context: Context) -> NSView {
        NSWindowCapturingView(window: $window)
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}
