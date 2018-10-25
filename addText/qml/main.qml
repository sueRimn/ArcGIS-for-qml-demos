import QtQuick 2.6
import QtQuick.Controls 1.4
import Esri.ArcGISRuntime 100.3

ApplicationWindow {
    id: appWindow
    property Point addTextPoint  //地图上显示的文本坐标点
    property var textSymbol   //文本图层符号
    width: 800
    height: 600
    title: "AddText"

    //创建图形
    function createGraphic(geometry,symbol){
        return ArcGISRuntimeEnvironment.createObject("Graphic",{
                                                         geometry:geometry,
                                                         symbol:symbol
                                                     });
    }

    // add a mapView component
    MapView {
        id:mapView
        anchors.fill: parent
        // set focus to enable keyboard navigation
        focus: true

        // add a map to the mapview
        Map {
            // add the BasemapImageryWithLabels basemap to the map
            BasemapImageryWithLabels {}
        }
        //容纳文本的图层
        GraphicsOverlay{
            id:textGraphicOverlay
            //文本图形
        }
        onMouseClicked: {
            addTextPoint = mouse.mapPoint
            console.log("添加文本坐标点：",addTextPoint)
            textIpt.visible = true;
            textSymbol = ArcGISRuntimeEnvironment.createObject("TextSymbol")
            textSymbol.size = 15;
            textSymbol.color = "yellow";
            textGraphicOverlay.graphics.append(createGraphic(addTextPoint,textSymbol))
        }
    }
    Button{
        id:addTextBtn
        anchors{
            top:mapView.top
            left: mapView.left
            margins: 5
        }

        width: 100
        height: 45
        text: "addText"
        onClicked: textIpt.visible = true
    }
    TextField{
        id:textIpt
        visible: false
        anchors{
            top:addTextBtn.bottom
            left: mapView.left
            margins: 5
        }
        width: 100
        height: 40
        Keys.enabled: true
        Keys.onReturnPressed: {
            textSymbol.text = textIpt.text
            textIpt.text = ""
            textIpt.visible = false

        }
    }
}
