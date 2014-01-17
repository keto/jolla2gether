import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property SilicaListView flickable: parent
    property int threshold: 1500
    property bool _activeUp
    property bool _activeDown
    signal upScrolling
    signal downScrolling

    BackgroundItem {
        visible: opacity > 0
        y: 40
        width: flickable.width
        height: Theme.itemSizeLarge
        highlighted: pressed
        opacity: _activeUp ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
        }

        Rectangle {
            width: 64
            height: 64
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            anchors.verticalCenter: parent.verticalCenter
            radius: 75
            color: Theme.highlightBackgroundColor
            opacity: 0.8
            Image {
                id: upImg
                anchors.centerIn: parent
                source: "image://theme/icon-l-up"
            }
        }

        onPressed: {
            flickable.scrollToTop();
        }
    }

    BackgroundItem {
        visible: opacity > 0
        y: flickable.height - 40
        width: flickable.width
        height: Theme.itemSizeLarge
        highlighted: pressed
        opacity: _activeDown ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
        }

        Rectangle {
            width: 64
            height: 64
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            anchors.verticalCenter: parent.verticalCenter
            radius: 75
            color: Theme.highlightBackgroundColor
            opacity: 0.8
            Image {
                anchors.centerIn: parent
                source: "image://theme/icon-l-down"
            }
        }

        onPressed: {
            flickable.scrollToBottom();
        }
    }

    Connections {
        target: flickable

        onVerticalVelocityChanged: {
            //console.log("velocity: " + target.verticalVelocity);

            if (target.verticalVelocity < 0)
            {
                _activeDown = false;
            }
            else
            {
                _activeUp = false;
            }

            if (target.verticalVelocity < -threshold &&
                target.contentHeight > 3 * target.height)
            {
                _activeUp = true;
                _activeDown = false;
                upScrolling();
            }
            else if (target.verticalVelocity > threshold &&
                     target.contentHeight > 3 * target.height)
            {
                _activeUp = false;
                _activeDown = true;
                downScrolling();
            }
            else if (Math.abs(target.verticalVelocity) < 10)
            {
                _activeUp = false;
                _activeDown = false;
            }
        }
    }
}
