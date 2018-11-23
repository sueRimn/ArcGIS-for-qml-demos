
// Copyright 2016 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the Sample code usage restrictions document for further information.
//

import QtQuick 2.6
import QtQuick.Controls 1.4
import Esri.ArcGISRuntime 100.3

ApplicationWindow {
    id: appWindow
    property var polyBuilder:[]//线段
    property var polygonFill   //多边形填充
    property var polygonGeometry//多边形几何
    property string areaText
    width: 800
    height: 600
    title: "Area"
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
        GraphicsOverlay{
            id:graphicsOverlay
        }

        onMouseClicked: {
            //声明多边形
            polyBuilder = ArcGISRuntimeEnvironment.createObject("PolygonBuilder",{spatialReference:SpatialReference.createWgs84()})
            polyBuilder.addPoint(mouse.mapPoint)
            //多边形填充选择
            polygonFill = ArcGISRuntimeEnvironment.createObject("SimpleFillSymbol",{
                                                                    style:Enums.SimpleFillSymbolStyleSolid,
                                                                    color:"yellow"

                                                                })
            var polygonCount = graphicsOverlay.graphics.rowCount()
            if(polygonCount > 0){
                graphicsOverlay.graphics.get(polygonCount-1).geometry = polyBuilder.geometry

            }else{
                //添加到图层
                var polygon = polyBuilder.geometry
                graphicsOverlay.graphics.append(createGraphic(polygon,polygonFill))
            }
            var maxSegmentLength = 1;
            var unitOfMeasurement = ArcGISRuntimeEnvironment.createObject("AreaUnit", {linearUnitId: Enums.AreaUnitIdSquareKilometers});
            var curveType = Enums.GeodeticCurveTypeGeodesic;
            var pathGeometry = GeometryEngine.densifyGeodetic(polygon, maxSegmentLength, unitOfMeasurement, curveType);
            areaText = GeometryEngine.areaGeodetic(pathGeometry,unitOfMeasurement,curveType).toFixed(2);

        }
    }
//    Button{
//        id:areaBtn
//        anchors{
//            top:mapView.top
//            right: MapView.right
//        }
//    }

    //面积显示文本
    Text{
        anchors{
            right: mapView.right
            top: mapView.top
            margins: 10
        }
        text: "%1 km²".arg(areaText)
        visible: areaText.length>0
        font.pointSize: 17
        color: "yellow"
    }


}
