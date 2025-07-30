import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick

RippleButton {
    id: button
    property string buttonText: ""
    property string tooltipText: ""

    implicitHeight: 30
    implicitWidth: implicitHeight

    Behavior on implicitWidth {
        SmoothedAnimation {
            velocity: Appearance.animation.elementMove.velocity
        }
    }

    buttonRadius: Appearance.rounding.small
    colBackground: "transparent"
    colBackgroundHover: ColorUtils.mix(Appearance.colors.todoActionButtons, "#FFFFFF", 0.9)
    colRipple: ColorUtils.mix(Appearance.colors.todoActionButtons, "#FFFFFF", 0.8)

    contentItem: StyledText {
        text: buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Appearance.font.pixelSize.larger
        color: Appearance.colors.todoActionButtons
    }

    StyledToolTip {
        content: tooltipText
        extraVisibleCondition: tooltipText.length > 0
    }
}