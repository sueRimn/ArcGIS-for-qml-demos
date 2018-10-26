import QtQuick 2.6
import QtQuick.Controls 1.4
import Esri.ArcGISRuntime 100.3

ApplicationWindow {
    id: appWindow
    property int clickNum:0
    property string distanceText  //距离显示文字
    property Point dis_startPoint //起始点
    property Point dis_endPoint   //终点
    width: 800
    height: 600
    title: "Distance"

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
        GraphicsOverlay{
            id:distanceGraphicsOverlayer;
            //测距图形层
            Graphic{//测距-起点图形
                id:dis_startGraphic;

                symbol: startMarkSymbol
            }
            Graphic{//测距-路径图形
                id:pathGraphic;
                symbol: pathSymbol
            }

            Graphic{//测距-终点图形
                id:dis_endGraphic;
                symbol: endMarkSymbol;
            }

        }
        onMouseClicked: {
            clickNum++
            if(clickNum == 1){//鼠标点击第一次 确实起点位置 并添加图形
                console.log(clickNum)
                dis_startPoint = mouse.mapPoint
                //graphicsOverlayer.graphics.append(createGraphic(dis_startPoint,startMarkSymbol))
                var dis_start = GeometryEngine.project(dis_startPoint,spatialReference.createWgs84())
                dis_startGraphic.geometry = dis_start
                console.log(dis_startPoint)
            }
            if(clickNum == 2){//鼠标点击第二次 确定终点位置 并添加图形
                console.log(clickNum)
                clickNum = 0;
                dis_endPoint = mouse.mapPoint
                var dis_end = GeometryEngine.project(dis_endPoint,spatialReference.createWgs84())
                dis_endGraphic.geometry = dis_end
                console.log(dis_endPoint)
                //创建路径线
                var polylineBuilder = ArcGISRuntimeEnvironment.createObject("PolylineBuilder", {spatialReference:SpatialReference.createWgs84()});
                polylineBuilder.addPoints([dis_startGraphic.geometry,dis_endGraphic.geometry])
                var polyline = polylineBuilder.geometry;

                //生成路径线
                var maxSegmentLength = 1;
                var unitOfMeasurement = ArcGISRuntimeEnvironment.createObject("LinearUnit", {linearUnitId: Enums.LinearUnitIdKilometers});
                var curveType = Enums.GeodeticCurveTypeGeodesic;
                var pathGeometry = GeometryEngine.densifyGeodetic(polyline, maxSegmentLength, unitOfMeasurement, curveType);

                pathGraphic.geometry = pathGeometry;
                //计算距离
                distanceText = GeometryEngine.lengthGeodetic(pathGeometry,unitOfMeasurement,curveType).toFixed(2)
                console.log("polyline builded",distanceText + "km")
            }
        }
    }
    //鼠标点击两点测距 符号
    SimpleLineSymbol{//测距路径线
        id:pathSymbol
        color: "yellow";
        width: 5;
        style: Enums.SimpleLineSymbolStyleDash
    }
    SimpleMarkerSymbol{//测距起点
        id:startMarkSymbol;
        color: "yellow";
        size: 5;
        style: Enums.SimpleMarkerSymbolStyleCircle
    }
    SimpleMarkerSymbol{//测距终点
        id:endMarkSymbol;
        color: "yellow";
        size: 5;
        style: Enums.SimpleMarkerSymbolStyleCircle
    }
    //测距距离显示文本
    Text{
        anchors{
            right: mapView.right;
            top:mapView.top;
            margins: 10
        }
        text: "%1 km".arg(distanceText);
        visible: distanceText.length>0;
        font.pointSize: 17;
        color: "yellow"
    }
}
