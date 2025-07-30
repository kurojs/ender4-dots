import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick

RippleButton {
    id: button
    property string buttonText: ""
    property string tooltipText: ""
    property bool forceCircle: false

    implicitHeight: 30
    implicitWidth: forceCircle ? implicitHeight : (contentItem.implicitWidth + 10 * 2)
    Behavior on implicitWidth {
        SmoothedAnimation {
            velocity: Appearance.animation.elementMove.velocity
        }
    }

    background.anchors.fill: button
    buttonRadius: Appearance.rounding.full
    colBackground: forceCircle ? "transparent" : Appearance.colors.colLayer2
    colBackgroundHover: forceCircle ? ColorUtils.mix(Appearance.colors.calendarNavButtons, "#FFFFFF", 0.9) : Appearance.colors.colLayer2Hover
    colRipple: forceCircle ? ColorUtils.mix(Appearance.colors.calendarNavButtons, "#FFFFFF", 0.8) : Appearance.colors.colLayer2Active

    contentItem: StyledText {
        text: buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Appearance.font.pixelSize.larger
        color: forceCircle ? Appearance.colors.calendarNavButtons : Appearance.colors.calendarHeaderText
    }

    StyledToolTip {
        content: tooltipText
        extraVisibleCondition: tooltipText.length > 0
    }
}