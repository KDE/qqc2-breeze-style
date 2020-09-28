import QtQuick 2.15
Rectangle {
    id: raisedGradient
    property real baseRadius: 0
    anchors.fill: parent
    gradient: Gradient {
        GradientStop {
            position: 0
            color: Qt.rgba(1,1,1,0.03125)
        }
        GradientStop {
            position: 1
            color: Qt.rgba(0,0,0,0.0625)
        }
    }
    radius: baseRadius
}
