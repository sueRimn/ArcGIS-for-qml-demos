import QtQuick 2.6
import QtQuick.Controls 1.4
import Esri.ArcGISRuntime 100.3

ApplicationWindow {
    id: appWindow
    property Point addTextPoint
    property var textGraphic
    width: 800
    height: 600
    title: "Untitled1"

    // add a mapView component
    MapView {
        id:mapView;
        anchors.fill: parent
        // set focus to enable keyboard navigation
        focus: true

        Map {
            //BasemapTopographic {}
            BasemapImageryWithLabels {}
        }
        onMouseClicked: {
            console.log("clicked:",mouse.button);
            if(mouse.button === 1){//鼠标左键
                textGraphic = ArcGISRuntimeEnvironment.createObject("Graphic");
                textGraphic.geometry = mouse.mapPoint;
                textGraphic.symbol = textSymbol;
                addTextGraphicsOverlayer.graphics.append(textGraphic);

            }
        }
        onMousePressed: {
            if(mouse.buttons === 2){
                textGraphic.geometry = mouse.mapPoint;
            }
        }
        onMouseReleased: {
            if(mouse.buttons === 2){
                textGraphic.geometry = mouse.mapPoint;
            }
        }

        GraphicsOverlay{
            id:addTextGraphicsOverlayer;

        }
        TextSymbol{
            id:textSymbol;
            size: 15;
            color: "yellow"
            text: "我可以在地图上走两步（。＾▽＾）"
        }

        //图层上的挪动

        //屏幕上的挪动
        Text{
            id:tex;
            text: "我还可以再挪两步(●ˇ∀ˇ●)";
            font.pointSize: 15;
            color: "yellow";
            //font.bold: true;

        }
        MouseArea{
            id:dragArea;
            anchors.fill: tex;
            drag.target: tex;
            acceptedButtons: Qt.RightButton;
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 0
            drag.maximumX: mapView.width - tex.width
            drag.minimumY: 0
            drag.maximumY: mapView.height - tex.height
        }
    }
}
