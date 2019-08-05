/*
    Copyright (C) 2016-19 Sebastian J. Wolf
                  2019    Mirian Margiani

    This file is part of Dictionary.

    Dictionary is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Dictionary is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dictionary. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtMultimedia 5.6
import Sailfish.Silica 1.0
import "../components"

Page {
    id: titlePage
    allowedOrientations: Orientation.All

    property bool interactionHintDisplayed : dictionaryModel.isInteractionHintDisplayed()

    function toggleBusyIndicator() {
        busyIndicator.running = heinzelnisseModel.isSearchInProgress()
        busyIndicatorColumn.opacity = heinzelnisseModel.isSearchInProgress() ? 1 : 0
        listView.opacity = heinzelnisseModel.isSearchInProgress() ? 0 : 1
        noResultsColumn.opacity = heinzelnisseModel.isEmpty() ? 1 : 0
    }

    AppNotification {
        id: titleNotification
    }

    Timer {
        id: searchTimer
        interval: 800
        running: false
        repeat: false
        onTriggered: {
            heinzelnisseModel.search(searchField.text)
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: parent.height
        contentWidth: parent.width

        PullDownMenu {
            MenuItem {
                text: qsTr("About Dictionary")
                onClicked: pageStack.push(aboutPage)
            }
            MenuItem {
                text: qsTr("Dictionaries")
                onClicked: pageStack.push(dictionariesPage)
            }
        }


        Column {
            id: overviewColumn
            Behavior on opacity { NumberAnimation {} }
            width: parent.width
            height: parent.height

            Item {
                id: dictionariesView
                width: parent.width
                height: parent.height

                Timer {
                    interval: 4000
                    running: titlePage.interactionHintDisplayed
                    repeat: false
                    onTriggered: {
                        interactionHint.opacity = 0
                        interactionHintLabel.opacity = 0
                        searchColumn.opacity = 1
                    }
                }

                TouchInteractionHint {
                    id: interactionHint
                    running: titlePage.interactionHintDisplayed
                    interactionMode: TouchInteraction.Pull
                    direction: TouchInteraction.Down
                    Behavior on opacity { NumberAnimation {} }
                    opacity: titlePage.interactionHintDisplayed
                }

                InteractionHintLabel {
                    id: interactionHintLabel
                    text: qsTr("Pull down the menu to import and change your dictionaries")
                    invert: true
                    Behavior on opacity { NumberAnimation {} }
                    opacity: titlePage.interactionHintDisplayed
                }

                Column {
                    x: listView.x
                    y: listView.y
                    height: titlePage.height - header.height - searchField.height - ( 2 * Theme.paddingLarge )
                    width: parent.width

                    id: busyIndicatorColumn
                    Behavior on opacity { NumberAnimation {} }
                    opacity: heinzelnisseModel.isSearchInProgress() ? 1 : 0

                    BusyIndicator {
                        id: busyIndicator
                        anchors.horizontalCenter: parent.horizontalCenter
                        running: heinzelnisseModel.isSearchInProgress()
                        size: BusyIndicatorSize.Medium
                    }

                    Label {
                        id: busyIndicatorLabel
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Searching...")
                        color: Theme.highlightColor
                    }

                    Connections {
                        target: heinzelnisseModel
                        onSearchStatusChanged: {
                            toggleBusyIndicator()
                        }
                    }
                }

                Column {
                    x: listView.x
                    y: listView.y
                    height: titlePage.height - header.height - searchField.height - ( 2 * Theme.paddingLarge )
                    width: parent.width

                    id: noResultsColumn
                    Behavior on opacity { NumberAnimation {} }
                    opacity: heinzelnisseModel.isEmpty() ? 1 : 0

                    Label {
                        id: noResultsLabel
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("No results found")
                        color: Theme.secondaryColor
                    }
                }

                Column {
                    id: searchColumn

                    Behavior on opacity { NumberAnimation {} }
                    opacity: titlePage.interactionHintDisplayed ? 0 : 1

                    width: parent.width

                    SilicaFlickable {
                        id: header
                        width: parent.width
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: headerDictionaryBox.height + Theme.paddingMedium

                        ComboBox {
                            id: headerDictionaryBox
                            y: Theme.paddingSmall
                            currentIndex: dictionaryModel.getSelectedDictionaryIndex()
                            label: qsTr("Active Dictionary:")
                            width: parent.width
                            menu: ContextMenu {
                                Repeater {
                                    model: dictionaryModel
                                    delegate: MenuItem {
                                        text: display.languages
                                    }
                                }
                                onActivated: {
                                    dictionaryModel.selectDictionary(index);
                                }
                            }

                            Connections {
                                // If dictionary is changed from DictionariesPage, we have to update index and search.
                                target: dictionaryModel
                                onDictionaryChanged: {
                                    headerDictionaryBox.currentIndex = dictionaryModel.getSelectedDictionaryIndex()
                                    heinzelnisseModel.search(searchField.text)
                                }
                            }
                        }

                        Separator {
                            id: headerSeparator
                            anchors.top: headerDictionaryBox.bottom
                            width: parent.width
                            color: Theme.primaryColor
                            horizontalAlignment: Qt.AlignHCenter
                        }

                    }

                    SearchField {
                        id: searchField
                        width: parent.width
                        placeholderText: qsTr("Search in dictionary...")
                        focus: true

                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        EnterKey.onClicked: focus = false

                        onTextChanged: {
                            searchTimer.stop()
                            searchTimer.start()
                        }
                    }

                    SilicaListView {

                        id: listView

                        height: titlePage.height - header.height - searchField.height
                        width: parent.width
                        anchors.left: parent.left
                        anchors.right: parent.right

                        Behavior on opacity { NumberAnimation {} }
                        opacity: heinzelnisseModel.isSearchInProgress() ? 0 : 1

                        clip: true

                        model: heinzelnisseModel

                        delegate: ListItem {
                            contentHeight: wordRow.height + Theme.paddingMedium
                            contentWidth: parent.width

                            menu: ContextMenu {
                                MenuItem {
                                    text: qsTr("Copy to clipboard")
                                    onClicked: {
                                        Clipboard.text = display.clipboardText
                                    }
                                }
                                MenuItem {
                                    text: qsTr("Search for '%1'").arg(display.wordLeft)
                                    onClicked: {
                                        searchField.text = display.wordLeft
                                    }
                                }
                                MenuItem {
                                    text: qsTr("Search for '%1'").arg(display.wordRight)
                                    onClicked: {
                                        searchField.text = display.wordRight
                                    }
                                }
                            }

                            Row {
                                id: wordRow
                                width: parent.width
                                spacing: Theme.paddingMedium
                                anchors.verticalCenter: parent.verticalCenter
                                Column {
                                    id: columnLeft
                                    width: parent.width / 2 - ( 2 * Theme.paddingMedium )
                                    Label {
                                        color: Theme.primaryColor
                                        width: parent.width
                                        font.pixelSize: Theme.fontSizeSmall
                                        x: Theme.horizontalPageMargin
                                        wrapMode: Text.Wrap
                                        truncationMode: TruncationMode.Fade
                                        text: display.wordLeft + " " + display.genderLeft
                                    }

                                    Label {
                                        color: Theme.primaryColor
                                        width: parent.width
                                        font.pixelSize: Theme.fontSizeExtraSmall
                                        x: Theme.horizontalPageMargin
                                        wrapMode: Text.Wrap
                                        truncationMode: TruncationMode.Fade
                                        text: display.otherLeft
                                    }
                                }
                                Column {
                                    id: columnRight
                                    width: parent.width / 2 - ( 2 * Theme.paddingMedium )
                                    Label {
                                        width: parent.width
                                        color: Theme.highlightColor
                                        font.pixelSize: Theme.fontSizeSmall
                                        x: Theme.horizontalPageMargin
                                        wrapMode: Text.Wrap
                                        truncationMode: TruncationMode.Fade
                                        text: display.wordRight + " " + display.genderRight
                                    }
                                    Label {
                                        width: parent.width
                                        color: Theme.highlightColor
                                        font.pixelSize: Theme.fontSizeExtraSmall
                                        x: Theme.horizontalPageMargin
                                        wrapMode: Text.Wrap
                                        truncationMode: TruncationMode.Fade
                                        text: display.otherRight
                                    }
                                }
                            }
                        }

                        VerticalScrollDecorator {}
                    }
                }
            }
        }
    }
}
