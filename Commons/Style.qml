pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // Spacing values (inspired by Caelestia's Appearance.spacing)
    readonly property int spacingSmall: 4
    readonly property int spacingNormal: 8
    readonly property int spacingLarge: 12

    // Padding values
    readonly property int paddingSmall: 6
    readonly property int paddingNormal: 10
    readonly property int paddingLarge: 16

    // Rounding/radius values
    readonly property int radiusSmall: 8
    readonly property int radiusNormal: 12
    readonly property int radiusLarge: 16
    readonly property int radiusFull: 500  // For pill shapes (effectively height/2)

    // Animation durations (ms)
    readonly property int animationFast: 150
    readonly property int animationNormal: 300
    readonly property int animationSlow: 450

    // Animation easing curves (Caelestia-inspired bezier curves)
    readonly property var easingStandard: [0.2, 0, 0, 1]  // Standard Material curve
    readonly property var easingEmphasized: [0.05, 0.7, 0.1, 1]  // Emphasized deceleration

    // Bar dimensions
    readonly property int barHeight: 40
    readonly property int barPadding: 8

    // Pill dimensions
    readonly property int pillHeight: 32
    readonly property int pillPaddingHorizontal: 12
    readonly property int pillMinWidth: 32

    // Font sizes
    readonly property int fontSizeSmall: 10
    readonly property int fontSizeNormal: 12
    readonly property int fontSizeLarge: 14

    // Opacity levels
    readonly property real opacityDisabled: 0.5
    readonly property real opacityHidden: 0.0
    readonly property real opacityFull: 1.0
}
