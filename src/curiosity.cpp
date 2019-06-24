/*
    Copyright (C) 2016-19 Sebastian J. Wolf

    This file is part of Wunderfitz.

    Wunderfitz is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Wunderfitz is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Wunderfitz. If not, see <http://www.gnu.org/licenses/>.
*/

#include "curiosity.h"
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QDirIterator>
#include <QStandardPaths>
#include <QList>
#include <QImageReader>
#include <QImage>
#include <QMatrix>
#include <QRect>
#include <QJsonObject>

// from cloudapi.h
#include <QObject>
#include <QUrl>
#include <QUrlQuery>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QList>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QVariantMap>
#include <QFile>

const char SETTINGS_SOURCE_LANGUAGE[] = "settings/sourceLanguage";
const char SETTINGS_TARGET_LANGUAGE[] = "settings/targetLanguage";
const char SETTINGS_USE_CLOUD[] = "settings/useCloud";

Curiosity::Curiosity(QObject *parent) : QObject(parent)
{
    this->networkAccessManager = new QNetworkAccessManager(this);
    QString tempDirectoryString = getTemporaryDirectoryPath();
    QDir myDirectory(tempDirectoryString);
    if (!myDirectory.exists()) {
        qDebug() << "[Curiosity] Creating temporary directory";
        if (myDirectory.mkdir(tempDirectoryString)) {
            qDebug() << "[Curiosity] Directory " + tempDirectoryString + " successfully created!";
        } else {
            qDebug() << "[Curiosity] Error creating directory " + tempDirectoryString + "!";
        }
    } else {
        qDebug() << "[Curiosity] Cleaning temporary files...";
        removeTemporaryFiles();
    }
}

QString Curiosity::getTemporaryDirectoryPath()
{
    return QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/harbour-wunderfitz";
}

void Curiosity::removeTemporaryFiles()
{
    QDirIterator temporaryDirectoryIterator(getTemporaryDirectoryPath(), QDir::Files, QDirIterator::Subdirectories);
    while (temporaryDirectoryIterator.hasNext()) {
        QString weRemoveThisOne = temporaryDirectoryIterator.next();
        qDebug() << "[Curiosity] Removing " << weRemoveThisOne;
        QFile::remove(weRemoveThisOne);
    }
}

void Curiosity::captureRequested(const int &orientation, const int &viewfinderDimension, const int &offset)
{
    qDebug() << "[Curiosity] Capture requested" << orientation << viewfinderDimension << offset;
    this->translatedText = "";
    this->captureOrientation = orientation;
    this->captureViewfinderDimension = viewfinderDimension;
    this->captureOffset = offset;
}

void Curiosity::captureCompleted(const QString &path)
{
    qDebug() << "[Curiosity] Capture completed" << path;
    this->capturePath = path;
}

QString Curiosity::getSourceLanguage()
{
    return settings.value(SETTINGS_SOURCE_LANGUAGE, "unk").toString();
}

void Curiosity::setSourceLanguage(const QString &sourceLanguage)
{
    qDebug() << "[Curiosity] Set source language" << sourceLanguage;
    settings.setValue(SETTINGS_SOURCE_LANGUAGE, sourceLanguage);
}

QString Curiosity::getTargetLanguage()
{
    return settings.value(SETTINGS_TARGET_LANGUAGE, "en").toString();
}

void Curiosity::setTargetLanguage(const QString &targetLanguage)
{
    qDebug() << "[Curiosity] Set target language" << targetLanguage;
    settings.setValue(SETTINGS_TARGET_LANGUAGE, targetLanguage);
}

bool Curiosity::getUseCloud()
{
    return false;
}

void Curiosity::setUseCloud(const bool &useCloud)
{
    qDebug() << "[Curiosity] Set use cloud" << false << " / " << useCloud;
    settings.setValue(SETTINGS_USE_CLOUD, false);
}

QString Curiosity::getTranslatedText()
{
    return this->translatedText;
}
