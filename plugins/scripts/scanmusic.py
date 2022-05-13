# -*- coding: utf-8 -*-

"""
/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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

# scanmusic.py
# scans the ~/media/music folder and generates all covers
# and a ~/media.db database with alll tracks.

import os
import sqlite3 as db
import argparse
from mutagen.id3 import ID3, ID3NoHeaderError


parser = argparse.ArgumentParser(description='scan music folder')

parser.add_argument('--source', default='~/media/music', help='music dir to scan')

args = parser.parse_args()

source = os.path.expanduser(args.source)

albums = set()

connection = db.connect(os.path.expanduser('~/media.db'))

cursor = connection.cursor()


sql_drop = 'drop table if exists music'

sql_create = """
create table music (
    pk integer primary key,
    album text,
    title text,
    track text,
    artist text,
    source text,
    cover text
    )
"""

sql_insert = """
insert into music (album,title,track,artist,source,cover) VALUES (?,?,?,?,?,?)
"""

def createTable():
    print('create table')
    cursor.execute(sql_drop)
    cursor.execute(sql_create)


def extractTag(media, tag):
    obj = media.get(tag)
    if obj:
        return ''.join(obj.text)#.encode('utf-8')
    return ''

def scanFolder(source):
    print('scan folder: ' + source)
    start = os.path.abspath(source)
    for root, dirnames, filenames in os.walk(start):
        for filename in filenames:
            if not filename[-4:] == '.mp3':
                continue
            filepath = os.path.join(root, filename)
            name = filename[0:-4]
            folderpath = os.path.relpath(root, start)
            print('analyze: ' + filepath)
            try:
                audio = ID3(filepath)
            except ID3NoHeaderError:
                print 'error reading: ', filepath
                continue


            # import pdb; pdb.set_trace()
            title = extractTag(audio, 'TIT2')
            album = extractTag(audio, 'TALB')
            artist = extractTag(audio, 'TPE1')
            track = extractTag(audio, 'TRCK')
            source = os.path.join(folderpath, filename).decode('utf-8')

            apics = audio.getall('APIC')[:1]
            apic = None
            if len(apics):
                apic = apics[0]
            coverName = ''
            if apic:
                if apic.mime == 'image/jpeg':
                    coverName = 'cover.jpg'
                elif apic.mime == 'image/png':
                    coverName = 'cover.png'
                else:
                    print('unknown cover mime type: ' + mime)
            else:
                import pdb; pdb.set_trace()
                print('!!! NO COVER')

            cover = os.path.join(folderpath, coverName).decode('utf-8')
            album_id = '%s/%s'%(album, artist)
            if not album_id in albums:
                albums.add(album_id)
                if apic: # save new cover
                    art = file(os.path.join(root, coverName), 'w')
                    art.write(apic.data)
                    art.close()
            cursor.execute(sql_insert, (album, title, track, artist, source, cover))


createTable()
scanFolder(source)

connection.commit()



