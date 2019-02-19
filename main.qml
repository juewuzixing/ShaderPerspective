import QtQuick 2.9

Rectangle {
    width: 640
    height: 480
    color: "black"

    Item {
        id: textItem
        width: 300
        height: 480
        Text {
            id: num
            text: "666"
            color: "lightblue"
            font.pixelSize: 90
        }
    }
    Perspective {
        x: 280
        y: 150
        trans: true
        rangeX: 0.3
        rangeY: 0.4
        lOrR: 0
        w: textItem.width
        h: textItem.height
        sourceItem: textItem
    }
}
