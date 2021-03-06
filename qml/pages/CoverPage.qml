/*
    Copyright (C) 2016-19 Sebastian J. Wolf

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
import Sailfish.Silica 1.0
import "."

CoverBackground {
    Image {
        source: "../../images/background.png"
        anchors {
            verticalCenter: parent.verticalCenter

            bottom: parent.bottom
            bottomMargin: Theme.paddingMedium

            right: parent.right
            rightMargin: Theme.paddingMedium
        }

        fillMode: Image.PreserveAspectFit
        opacity: 0.3
    }

    SilicaListView {
        id: coverListView
        anchors {
            top: parent.top
            topMargin: Theme.paddingMedium
            left: parent.left
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
            bottom: parent.bottom
        }
        model: heinzelnisseModel
        delegate: ListItem {
            anchors {
                topMargin:  Theme.paddingMedium
            }
            height: resultLabelNorwegian.height + resultLabelGerman.height + Theme.paddingSmall
            opacity: index < 5 ? 1.0 - index * 0.15 : 0.0
            Label {
                id: resultLabelNorwegian
                maximumLineCount: 1
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: display.wordLeft
                truncationMode: TruncationMode.Fade
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }
            Label {
                id: resultLabelGerman
                maximumLineCount: 1
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: display.wordRight
                truncationMode: TruncationMode.Fade
                anchors {
                    top: resultLabelNorwegian.bottom
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }

}


