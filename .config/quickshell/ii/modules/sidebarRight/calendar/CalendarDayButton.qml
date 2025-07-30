import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Layouts

RippleButton {
    id: button
    property string day
    property int isToday
    property bool bold

    Layout.fillWidth: false
    Layout.fillHeight: false
    implicitWidth: 38; 
    implicitHeight: 38;

    toggled: (isToday == 1)
    buttonRadius: Appearance.rounding.small
    colBackground: (isToday == 1) ? Appearance.colors.calendarToday : "transparent"
    colBackgroundToggled: (isToday == 1) ? Appearance.colors.calendarToday : Appearance.colors.colPrimary
    colBackgroundHover: (isToday == 1) ? ColorUtils.mix(Appearance.colors.calendarToday, "#FFFFFF", 0.9) : Appearance.colors.colLayer2Hover
    colBackgroundToggledHover: (isToday == 1) ? ColorUtils.mix(Appearance.colors.calendarToday, "#FFFFFF", 0.9) : Appearance.colors.colPrimaryHover
    colRipple: (isToday == 1) ? ColorUtils.mix(Appearance.colors.calendarToday, "#FFFFFF", 0.8) : Appearance.colors.colLayer2Active
    
    contentItem: StyledText {
        anchors.fill: parent
        text: day
        horizontalAlignment: Text.AlignHCenter
        font.weight: bold ? Font.DemiBold : Font.Normal
        color: (isToday == 1) ? Appearance.colors.calendarTodayText : 
            (isToday == 0) ? Appearance.colors.calendarDayText : 
            Appearance.colors.calendarWeakDayText

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }
}

