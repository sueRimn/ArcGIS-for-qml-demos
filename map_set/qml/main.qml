import QtQuick 2.6
import QtQuick.Controls 1.4
import Esri.ArcGISRuntime 100.3

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    title: "Map_set"

    // 添加MapView组件
    MapView {
        anchors.fill: parent
        focus: true

        // 添加地图在MapView中
        Map {
            id:map;
            BasemapImageryWithLabels {}//在线地图
            ViewpointCenter{//视域中心
                id:viewPointCenter;
                center:  Point{//双流机场 ZUUU
                    id:viewPoint;
                    x: 11571365.80492
                    y: 3578092.33803
                    spatialReference: SpatialReference{wkid:3857}

                }
                targetScale:250000;//数值越大 范围越大
            }
        }
    }

}
