import qs.modules.common
import QtQuick;

/**
 * Represents a message in an AI conversation. (Kind of) follows the OpenAI API message structure.
 */
QtObject {
    property string id
    property string role
    property string content
    property string rawContent
    property string model
    property string agent
    property var timestamp: Date.now()
    property bool thinking: true
    property bool done: false
    property var annotations: []
    property var annotationSources: []
    property string functionName
    property string functionCall
    property string functionResponse
    property bool visibleToUser: true
}
