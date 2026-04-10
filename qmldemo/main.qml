import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {
    id: window
    width: 800
    height: 480
    visible: true
    color: "#1a1a2e"
    title: "Vehicle Speed Gauge"

    // 速度变量（0-100km/h），对应20格刻度
    property real speed: 0
    // 每格对应5km/h，30格总跨度270°，指针旋转角度映射
    property real anglePerUnit: 360 / 30
    /*property real bIsOrder: 1
    // 每3秒转动1格，定时器间隔
    property int timerInterval: 1000

    // 定时器控制指针转动
    Timer {
        id: speedTimer
        interval: timerInterval
        running: true
        repeat: true
        onTriggered: {
            if(speed == 0)
            {
                bIsOrder = 1
            }
            else if(speed == 100)
            {
                bIsOrder = 0
            }
            if(bIsOrder)
            {
                speed += 5
            }
            else
            {
                speed -= 5
            }
            console.log("timer add，speed:",speed)
        }
    }*/

    // 仪表盘背景图片（替换为你自己的表盘图）
    Image {
        id: gaugeBackground
        source: "./res/cluster_speed.png" // 替换为实际路径
        anchors.centerIn: parent
        width: 310
        height: 310
    }

    // 指针图片（替换为你自己的指针图）
    Image {
        id: needle
        source: "./res/cluster_needle.png" // 替换为实际路径
        anchors.centerIn: gaugeBackground
        width: 112
        height: 213
        transformOrigin: Item.Center
        // 速度0对应-135°，100km/h对应+135°，线性映射角度
        rotation: -120 + (vehicleData.speed / 5) * 12 // 每5km/h对应9°（270°/30格）
    }
    // ========== 侧边弹窗面板 ==========
    // 左侧弹出按钮（固定在左侧边缘）
    Button {
        id: sidebarToggle
        text: "📊 状态"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        width: 60
        height: 60
        background: Rectangle {
            color: "#2d2d44"
            border.color: "#4a4a7a"
            border.width: 1
            radius: 12
        }
        contentItem: Text {
            text: sidebarToggle.text
            color: "#ffffff"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: sidebarPopup.open()
    }

    // 弹窗内容：使用 Popup 组件实现侧滑动画
    Popup {
        id: sidebarPopup
        x: -280  // 初始隐藏在左侧外
        y: 0
        width: 280
        height: parent.height
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: "#161625"
            border.color: "#3a3a66"
            border.width: 1
        }

        // 弹窗内容区域
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "车辆状态"
                color: "#ffffff"
                font.pixelSize: 20
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            /*Divider {
                width: parent.width
                color: "#4a4a7a"
            }*/

            // 故障码显示
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "故障码："
                    color: "#cccccc"
                    font.pixelSize: 14
                }
                Text {
                    text: "P0123"
                    color: "#ff6b6b"
                    font.pixelSize: 14
                    font.bold: true
                }
            }

            // 油量
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "油量："
                    color: "#cccccc"
                    font.pixelSize: 14
                }
                Text {
                    text: vehicleData.oilPercent + "%"
                    color: "#51e296"
                    font.pixelSize: 14
                    font.bold: true
                }
            }

            // 胎压
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "胎压： "
                    color: "#cccccc"
                    font.pixelSize: 14
                }
                Text {
                    text: vehicleData.tirePressure.toFixed(2) + "%"
                    color: "#f6f844"
                    font.pixelSize: 14
                    font.bold: true
                }
            }

            // 驾驶建议
            Text {
                text: "建议：当前车速偏高，建议减速至80km/h以下"
                color: "#e0e0ff"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            // 分隔线
            /*Divider {
                width: parent.width
                color: "#4a4a7a"
            }*/

            // 关闭按钮
            Button {
                text: "关闭"
                width: parent.width
                background: Rectangle {
                    color: "#3a3a66"
                    border.color: "#5a5a99"
                    border.width: 1
                    radius: 8
                }
                onClicked: sidebarPopup.close()
            }
        }

        // 侧滑动画：从左滑入
        Behavior on x {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        // 淡入淡出背景遮罩
        /*overlay: Rectangle {
            color: "black"
            opacity: sidebarPopup.visible ? 0.4 : 0
            anchors.fill: parent
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }*/
    }

    // ========== 弹窗显示状态指示器（可选）==========
    Text {
        text: sidebarPopup.visible ? "弹窗已打开" : "点击左侧按钮打开状态面板"
        color: "#888888"
        font.pixelSize: 12
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 16
    }
}

