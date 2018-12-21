# -*- coding: utf-8 -*-

"""
/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/
"""

# scanmovies.py
# scans the ~/media/movies folder and generates all covers
# and a ~/media.db database with alll tracks.

import os
import sqlite3 as db
import argparse
from mutagen.mp4 import MP4


parser = argparse.ArgumentParser(description='scan movie folder')

parser.add_argument('--source', default='~/media/movies', help='movie dir to scan')

args = parser.parse_args()

source = os.path.expanduser(args.source)

albums = set()

connection = db.connect(os.path.expanduser('~/media.db'))

cursor = connection.cursor()


sql_drop = 'drop table if exists movies'

sql_create = """
create table movies (
    pk integer primary key,
    title text,
    year integer,
    genre text,
    desc text,
    source text,
    cover text
    )
"""

sql_insert = """
insert into movies (title,year,genre,desc,source,cover) VALUES (?,?,?,?,?,?)
"""

def createTable():
    print('create table')
    cursor.execute(sql_drop)
    cursor.execute(sql_create)


def extractTag(media, tag):
    obj = media.get(tag)
    if obj:
        return ''.join(obj)#.encode('utf-8')
    return ''

def scanFolder(source):
    print('scan folder: ' + source)
    start = os.path.abspath(source)
    for root, dirnames, filenames in os.walk(start):
        for filename in filenames:
            if not filename[-3:] == 'm4v':
                continue
            filepath = os.path.join(root, filename)
            folderpath = os.path.relpath(root, start)
            name = filename[0:-4]
            print('analyze: ' + filepath)
            try:
                movie = MP4(filepath)
            except:
                print 'error reading: ', filepath
                continue
            title = extractTag(movie, '\xa9nam')
            year = extractTag(movie, '\xa9day')
            genre = extractTag(movie, '\xa9gen')
            coverData = movie['covr'][0]
            cover = os.path.join(folderpath, 'cover.jpg')
            desc = extractTag(movie, 'desc')
            source = os.path.join(folderpath, filename)
            coverArt = file(os.path.join(start, cover), 'w')
            coverArt.write(coverData)
            coverArt.close()
            cursor.execute(sql_insert, (title, year, genre, desc, source, cover))


createTable()
scanFolder(source)

connection.commit()
