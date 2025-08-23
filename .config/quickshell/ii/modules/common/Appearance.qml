import QtQuick
import Quickshell
import qs.modules.common.functions
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root

    // =================================================================================
    // ===== customColors CONFIGURATION ================================================
    // =================================================================================
    //
    // ¡Hola! Aquí puedes personalizar los colores de tu interfaz.
    // Simplemente cambia los códigos de color hexadecimales por los que prefieras.
    //
    // Formato: "#RRGGBB" (ej. "#FF0000" para rojo)
    //
    // =================================================================================

    property QtObject customColors: QtObject {
        // -- Colores principales --
        property color primary: "#8c8c8cff"      // Color de acento principal (botones, sliders, etc.)
        property color background: "#161217"   // Color de fondo general
        property color outline: "#988E97"      // Color para bordes y separadores

        // -- Fondos de Panel --
        // Formato: "#AARRGGBB" donde AA es la transparencia (00=transparente, FF=opaco)
        property color panelBackground: "#B3000000"   // Fondo para paneles laterales y barra. (Negro con 70% opacidad por defecto)
        property color raycastBackground: "#BF000000" // Fondo del AppLauncher (75% opacidad)

        // -- Colores específicos por sección --
        property color leftPanelTabs: "#a0a0a0"         // Pestañas activas del panel izquierdo
        property color rightPanelToggles: "#725FCE"     // Toggles activos del panel derecho
        property color volumeBar: "#725FCE"             // Barra de progreso de volumen/brillo
        property color sessionButtons: "#523CC3"        // Botones del menú de sesión (apagar, etc.)
        property color dockIcons: "#725FCE"             // Iconos activos en el dock

        // -- Colores de Acento y Elementos Específicos --
        property color accentLine: "#000000"             // Línea bajo la pestaña activa en los paneles
        property color volumeMixerBar: "#725FCE"         // Barras de volumen individuales en el mezclador
        property color rightPanelIcon: "#a0a0a0"        // Iconos activos en el panel derecho (WiFi, etc.)
        property color rightPanelIconHover: "#523CC3"    // Fondo al pasar el ratón sobre esos iconos
        
        // -- Colores del Panel Derecho - Calendario --
        property color calendarToday: "#3d3d3d"          // Color para el día actual en el calendario
        property color calendarTodayText: "#FFFFFF"      // Color del texto del día actual
        property color calendarDayText: "#E0E0E0"        // Color del texto de días normales
        property color calendarWeakDayText: "#888888"    // Color del texto de días fuera del mes actual
        property color calendarHeaderText: "#E0E0E0"     // Color del texto del header del calendario
        property color calendarNavButtons: "#725FCE"     // Color de los botones de navegación
        
        // -- Colores del Panel Derecho - Todo --
        property color todoTabActive: "#8E44AD"          // Color de la pestaña activa del todo
        property color todoTabInactive: "#666666"        // Color de las pestañas inactivas
        property color todoItemBackground: "#2A2A2A"     // Fondo de los elementos del todo
        property color todoItemText: "#E0E0E0"           // Color del texto de los elementos
        property color todoActionButtons: "#725FCE"      // Color de los botones de acción (marcar, eliminar)
        property color todoAddButton: "#8E44AD"          // Color del botón de agregar tarea
        property color todoDialogBackground: "#3A3A3A"   // Fondo del diálogo de agregar tarea
        
        // -- Colores para los iconos de navegación (Calendar y Todo) --
        property color navigationRailSelected: "#3d3d3d"    // Color de fondo cuando está seleccionado (Calendar/Todo)
        property color navigationRailSelectedHover: "#3d3d3d" // Color de fondo cuando está seleccionado y hover
        property color navigationRailSelectedActive: "#3d3d3d" // Color de fondo cuando está seleccionado y activo
        property color navigationRailIcon: "#FFFFFF"        // Color del icono cuando está seleccionado
        property color navigationRailIconInactive: "#888888" // Color del icono cuando no está seleccionado
        
        // -- Efectos de Blur para Paneles --
        property real leftPanelBlur: 0.0                 // Intensidad del blur para el panel izquierdo (0.0 = sin blur, 1.0 = blur máximo)
        property real rightPanelBlur: 0.0                // Intensidad del blur para el panel derecho (0.0 = sin blur, 1.0 = blur máximo)
        
        // -- Configuración de Bordes de Paneles --
        property real leftPanelBorderWidth: 1.0         // Grosor del borde del panel izquierdo (0.0 = sin borde)
        property real rightPanelBorderWidth: 1.0        // Grosor del borde del panel derecho (0.0 = sin borde)
        property color leftPanelBorderColor: "#000000"   // Color del borde del panel izquierdo
        property color rightPanelBorderColor: "#000000"  // Color del borde del panel derecho
    }

    // =================================================================================
    // =================================================================================
    // =================================================================================

    property QtObject m3colors
    property QtObject animation
    property QtObject animationCurves
    property QtObject colors
    property QtObject rounding
    property QtObject font
    property QtObject sizes
    property string syntaxHighlightingTheme

    // Extremely conservative transparency values for consistency and readability
    property real transparency: Config.options?.appearance.transparency ? (m3colors.darkmode ? 0.1 : 0.07) : 0
    property real contentTransparency: Config.options?.appearance.transparency ? (m3colors.darkmode ? 0.55 : 0.55) : 0

    m3colors: QtObject {
        property bool darkmode: false
        property bool transparent: false
        property color m3primary_paletteKeyColor: "#91689E"
        property color m3secondary_paletteKeyColor: "#837186"
        property color m3tertiary_paletteKeyColor: "#9D6A67"
        property color m3neutral_paletteKeyColor: "#7C757B"
        property color m3neutral_variant_paletteKeyColor: "#7D747D"
        property color m3background: customColors.background
        property color m3onBackground: "#EAE0E7"
        property color m3surface: customColors.background
        property color m3surfaceDim: customColors.background
        property color m3surfaceBright: "#3D373D"
        property color m3surfaceContainerLowest: "#110D12"
        property color m3surfaceContainerLow: "#1F1A1F"
        property color m3surfaceContainer: "#231E23"
        property color m3surfaceContainerHigh: "#2D282E"
        property color m3surfaceContainerHighest: "#383339"
        property color m3onSurface: "#EAE0E7"
        property color m3surfaceVariant: "#4C444D"
        property color m3onSurfaceVariant: "#CFC3CD"
        property color m3inverseSurface: "#EAE0E7"
        property color m3inverseOnSurface: "#342F34"
        property color m3outline: customColors.outline
        property color m3outlineVariant: "#4C444D"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3surfaceTint: customColors.primary
        property color m3primary: customColors.primary
        property color m3onPrimary: "#2E0A3C"
        property color m3primaryContainer: "#5B4860"
        property color m3onPrimaryContainer: "#E8C0F3"
        property color m3inversePrimary: "#775084"
        property color m3secondary: "#D5C0D7"
        property color m3onSecondary: "#392C3D"
        property color m3secondaryContainer: "#5B4860"
        property color m3onSecondaryContainer: "#ECCBF5"
        property color m3tertiary: "#F5B7B3"
        property color m3onTertiary: "#4C2523"
        property color m3tertiaryContainer: "#BA837F"
        property color m3onTertiaryContainer: "#000000"
        property color m3error: "#FFB4AB"
        property color m3onError: "#690005"
        property color m3errorContainer: "#93000A"
        property color m3onErrorContainer: "#FFDAD6"
        property color m3primaryFixed: "#F9D8FF"
        property color m3primaryFixedDim: "#E5B6F2"
        property color m3onPrimaryFixed: "#2E0A3C"
        property color m3onPrimaryFixedVariant: "#5D386A"
        property color m3secondaryFixed: "#F2DCF3"
        property color m3secondaryFixedDim: "#D5C0D7"
        property color m3onSecondaryFixed: "#241727"
        property color m3onSecondaryFixedVariant: "#514254"
        property color m3tertiaryFixed: "#FFDAD7"
        property color m3tertiaryFixedDim: "#F5B7B3"
        property color m3onTertiaryFixed: "#331110"
        property color m3onTertiaryFixedVariant: "#663B39"
        property color m3success: "#B5CCBA"
        property color m3onSuccess: "#213528"
        property color m3successContainer: "#374B3E"
        property color m3onSuccessContainer: "#D1E9D6"
        property color term0: "#EDE4E4"
        property color term1: "#B52755"
        property color term2: "#A97363"
        property color term3: "#AF535D"
        property color term4: "#A67F7C"
        property color term5: "#B2416B"
        property color term6: "#8D76AD"
        property color term7: "#272022"
        property color term8: "#0E0D0D"
        property color term9: "#B52755"
        property color term10: "#A97363"
        property color term11: "#AF535D"
        property color term12: "#A67F7C"
        property color term13: "#B2416B"
        property color term14: "#8D76AD"
        property color term15: "#221A1A"
    }

    colors: QtObject {
        // -- Colores específicos por sección (usando customColors) --
        property color leftPanelTabsActive: customColors.leftPanelTabs ?? m3colors.m3primary
        property color rightPanelTogglesActive: customColors.rightPanelToggles ?? m3colors.m3secondary
        property color volumeBarActive: customColors.volumeBar ?? m3colors.m3primary
        property color sessionButtonsActive: customColors.sessionButtons ?? m3colors.m3secondary
        property color dockIconsActive: customColors.dockIcons ?? m3colors.m3primary

        // -- Colores de Acento y Elementos Específicos --
        property color accentLine: customColors.accentLine ?? m3colors.m3primary
        property color volumeMixerBar: customColors.volumeMixerBar ?? m3colors.m3primary
        property color rightPanelIcon: customColors.rightPanelIcon ?? m3colors.m3secondary
        property color rightPanelIconHover: customColors.rightPanelIconHover ?? m3colors.m3surfaceContainer
        
        // -- Colores del Panel Derecho - Calendario --
        property color calendarToday: customColors.calendarToday ?? m3colors.m3primary
        property color calendarTodayText: customColors.calendarTodayText ?? m3colors.m3onPrimary
        property color calendarDayText: customColors.calendarDayText ?? m3colors.m3onSurface
        property color calendarWeakDayText: customColors.calendarWeakDayText ?? m3colors.m3outline
        property color calendarHeaderText: customColors.calendarHeaderText ?? m3colors.m3onSurface
        property color calendarNavButtons: customColors.calendarNavButtons ?? m3colors.m3secondary
        
        // -- Colores del Panel Derecho - Todo --
        property color todoTabActive: customColors.todoTabActive ?? m3colors.m3primary
        property color todoTabInactive: customColors.todoTabInactive ?? m3colors.m3outline
        property color todoItemBackground: customColors.todoItemBackground ?? m3colors.m3surfaceContainer
        property color todoItemText: customColors.todoItemText ?? m3colors.m3onSurface
        property color todoActionButtons: customColors.todoActionButtons ?? m3colors.m3secondary
        property color todoAddButton: customColors.todoAddButton ?? m3colors.m3primary
        property color todoDialogBackground: customColors.todoDialogBackground ?? m3colors.m3surfaceContainerHigh
        
        // -- Colores para los iconos de navegación (Calendar y Todo) --
        property color navigationRailSelected: customColors.navigationRailSelected ?? m3colors.m3secondaryContainer
        property color navigationRailSelectedHover: customColors.navigationRailSelectedHover ?? ColorUtils.mix(customColors.navigationRailSelected ?? m3colors.m3secondaryContainer, "#FFFFFF", 0.9)
        property color navigationRailSelectedActive: customColors.navigationRailSelectedActive ?? ColorUtils.mix(customColors.navigationRailSelected ?? m3colors.m3secondaryContainer, "#000000", 0.9)
        property color navigationRailIcon: customColors.navigationRailIcon ?? m3colors.m3onSecondaryContainer
        property color navigationRailIconInactive: customColors.navigationRailIconInactive ?? m3colors.m3onSurfaceVariant
        
        // -- Efectos de Blur para Paneles --
        property real leftPanelBlur: customColors.leftPanelBlur ?? 0.0
        property real rightPanelBlur: customColors.rightPanelBlur ?? 0.0
        
        // -- Configuración de Bordes de Paneles --
        property real leftPanelBorderWidth: customColors.leftPanelBorderWidth ?? 1.0
        property real rightPanelBorderWidth: customColors.rightPanelBorderWidth ?? 1.0
        property color leftPanelBorderColor: customColors.leftPanelBorderColor ?? m3colors.m3outlineVariant
        property color rightPanelBorderColor: customColors.rightPanelBorderColor ?? m3colors.m3outlineVariant

        // -- Colores base del tema (derivados de m3colors) --
        property color colSubtext: m3colors.m3outline
        property color colLayer0: customColors.panelBackground
        property color colOnLayer0: m3colors.m3onBackground
        property color colLayer0Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer0, colOnLayer0, 0.9, root.contentTransparency))
        property color colLayer0Active: ColorUtils.transparentize(ColorUtils.mix(colLayer0, colOnLayer0, 0.8, root.contentTransparency))
        property color colLayer1: ColorUtils.transparentize(ColorUtils.mix(m3colors.m3surfaceContainerLow, m3colors.m3background, 0.8), root.contentTransparency);
        property color colOnLayer1: m3colors.m3onSurfaceVariant;
        property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45);
        property color colLayer2: ColorUtils.transparentize(ColorUtils.mix(m3colors.m3surfaceContainer, m3colors.m3surfaceContainerHigh, 0.1), root.contentTransparency)
        property color colOnLayer2: m3colors.m3onSurface;
        property color colOnLayer2Disabled: ColorUtils.mix(colOnLayer2, m3colors.m3background, 0.4);
        property color colLayer3: ColorUtils.transparentize(ColorUtils.mix(m3colors.m3surfaceContainerHigh, m3colors.m3onSurface, 0.96), root.contentTransparency)
        property color colOnLayer3: m3colors.m3onSurface;
        property color colLayer1Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer1, colOnLayer1, 0.92), root.contentTransparency)
        property color colLayer1Active: ColorUtils.transparentize(ColorUtils.mix(colLayer1, colOnLayer1, 0.85), root.contentTransparency);
        property color colLayer2Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer2, colOnLayer2, 0.90), root.contentTransparency)
        property color colLayer2Active: ColorUtils.transparentize(ColorUtils.mix(colLayer2, colOnLayer2, 0.80), root.contentTransparency);
        property color colLayer2Disabled: ColorUtils.transparentize(ColorUtils.mix(colLayer2, m3colors.m3background, 0.8), root.contentTransparency);
        property color colLayer3Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer3, colOnLayer3, 0.90), root.contentTransparency)
        property color colLayer3Active: ColorUtils.transparentize(ColorUtils.mix(colLayer3, colOnLayer3, 0.80), root.contentTransparency);
        property color colPrimary: m3colors.m3primary
        property color colOnPrimary: m3colors.m3onPrimary
        property color colPrimaryHover: ColorUtils.mix(colors.colPrimary, colLayer1Hover, 0.87)
        property color colPrimaryActive: ColorUtils.mix(colors.colPrimary, colLayer1Active, 0.7)
        property color colPrimaryContainer: m3colors.m3primaryContainer
        property color colPrimaryContainerHover: ColorUtils.mix(colors.colPrimaryContainer, colLayer1Hover, 0.7)
        property color colPrimaryContainerActive: ColorUtils.mix(colors.colPrimaryContainer, colLayer1Active, 0.6)
        property color colOnPrimaryContainer: m3colors.m3onPrimaryContainer
        property color colSecondary: m3colors.m3secondary
        property color colSecondaryHover: ColorUtils.mix(m3colors.m3secondary, colLayer1Hover, 0.85)
        property color colSecondaryActive: ColorUtils.mix(m3colors.m3secondary, colLayer1Active, 0.4)
        property color colSecondaryContainer: m3colors.m3secondaryContainer
        property color colSecondaryContainerHover: ColorUtils.mix(m3colors.m3secondaryContainer, m3colors.m3onSecondaryContainer, 0.90)
        property color colSecondaryContainerActive: ColorUtils.mix(m3colors.m3secondaryContainer, colLayer1Active, 0.54)
        property color colOnSecondaryContainer: m3colors.m3onSecondaryContainer
        property color colSurfaceContainerLow: ColorUtils.transparentize(m3colors.m3surfaceContainerLow, root.contentTransparency)
        property color colSurfaceContainer: ColorUtils.transparentize(m3colors.m3surfaceContainer, root.contentTransparency)
        property color colSurfaceContainerHigh: ColorUtils.transparentize(m3colors.m3surfaceContainerHigh, root.contentTransparency)
        property color colSurfaceContainerHighest: ColorUtils.transparentize(m3colors.m3surfaceContainerHighest, root.contentTransparency)
        property color colSurfaceContainerHighestHover: ColorUtils.mix(m3colors.m3surfaceContainerHighest, m3colors.m3onSurface, 0.95)
        property color colSurfaceContainerHighestActive: ColorUtils.mix(m3colors.m3surfaceContainerHighest, m3colors.m3onSurface, 0.85)
        property color colTooltip: m3colors.darkmode ? ColorUtils.mix(m3colors.m3background, "#3C4043", 0.5) : "#3C4043" // m3colors.m3inverseSurface in the specs, but the m3 website actually uses #3C4043
        property color colOnTooltip: "#F8F9FA" // m3colors.m3inverseOnSurface in the specs, but the m3 website actually uses this color
        property color colScrim: ColorUtils.transparentize(m3colors.m3scrim, 0.5)
        property color colShadow: ColorUtils.transparentize(m3colors.m3shadow, 0.7)
        property color colOutlineVariant: m3colors.m3outlineVariant
    }

    rounding: QtObject {
        property int unsharpen: 2
        property int unsharpenmore: 6
        property int verysmall: 8
        property int small: 12
        property int normal: 17
        property int large: 23
        property int verylarge: 30
        property int full: 9999
        property int screenRounding: large
        property int windowRounding: 18
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: "Rubik"
            property string title: "Gabarito"
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: "SpaceMono NF"
            property string monospace: "JetBrains Mono NF"
            property string reading: "Readex Pro"
            property string expressive: "Space Grotesk"
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: huge
        }
    }

    animationCurves: QtObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1] // Default, 350ms
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1] // Default, 500ms
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1] // Default, 650ms
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1] // Default, 200ms
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        readonly property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property real expressiveFastSpatialDuration: 350
        readonly property real expressiveDefaultSpatialDuration: 500
        readonly property real expressiveSlowSpatialDuration: 650
        readonly property real expressiveEffectsDuration: 200
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
            property Component colorAnimation: Component {
                ColorAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }
        property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }
        property QtObject elementMoveExit: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedAccel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveExit.duration
                    easing.type: root.animation.elementMoveExit.type
                    easing.bezierCurve: root.animation.elementMoveExit.bezierCurve
                }
            }
        }
        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property int velocity: 850
            property Component colorAnimation: Component { ColorAnimation {
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
            property Component numberAnimation: Component { NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
        }

        property QtObject clickBounce: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveFastSpatial
            property int velocity: 850
            property Component numberAnimation: Component { NumberAnimation {
                    duration: root.animation.clickBounce.duration
                    easing.type: root.animation.clickBounce.type
                    easing.bezierCurve: root.animation.clickBounce.bezierCurve
            }}
        }
        property QtObject scroll: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
        }
        property QtObject menuDecel: QtObject {
            property int duration: 350
            property int type: Easing.OutExpo
        }
    }

    sizes: QtObject {
        property real baseBarHeight: 40
        property real barHeight: Config.options.bar.cornerStyle === 1 ? 
            (baseBarHeight + Appearance.sizes.hyprlandGapsOut * 2) : baseBarHeight
        property real barCenterSideModuleWidth: Config.options?.bar.verbose ? 360 : 140
        property real barCenterSideModuleWidthShortened: 280
        property real barCenterSideModuleWidthHellaShortened: 190
        property real barShortenScreenWidthThreshold: 1200 // Shorten if screen width is at most this value
        property real barHellaShortenScreenWidthThreshold: 1000 // Shorten even more...
        property real sidebarWidth: 460
        property real sidebarWidthExtended: 750
        property real osdWidth: 200
        property real mediaControlsWidth: 440
        property real mediaControlsHeight: 160
        property real notificationPopupWidth: 410
        property real searchWidthCollapsed: 260
        property real searchWidth: 450
        property real hyprlandGapsOut: 5
        property real elevationMargin: 10
        property real fabShadowRadius: 5
        property real fabHoveredShadowRadius: 7
    }

    syntaxHighlightingTheme: Appearance.m3colors.darkmode ? "Monokai" : "ayu Light"
}