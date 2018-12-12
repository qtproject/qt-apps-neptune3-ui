#!/usr/bin/python
# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2018 Luxoft GmbH
## Contact: https://www.qt.io/licensing/
##
## This file is part of the Neptune 3 IVI UI.
##
## $QT_BEGIN_LICENSE:GPL-QTAS$
## Commercial License Usage
## Licensees holding valid commercial Qt Automotive Suite licenses may use
## this file in accordance with the commercial license agreement provided
## with the Software or, alternatively, in accordance with the terms
## contained in a written agreement between you and The Qt Company.  For
## licensing terms and conditions see https://www.qt.io/terms-conditions.
## For further information use the contact form at https://www.qt.io/contact-us.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3 or (at your option) any later version
## approved by the KDE Free Qt Foundation. The licenses are as published by
## the Free Software Foundation and appearing in the file LICENSE.GPL3
## included in the packaging of this file. Please review the following
## information to ensure the GNU General Public License requirements will
## be met: https://www.gnu.org/licenses/gpl-3.0.html.
##
## $QT_END_LICENSE$
##
## SPDX-License-Identifier: GPL-3.0
##
#############################################################################

# please call this program directly and not via "python ./generate_sqlite.py"

# This program reads media files from a directory (via taglib library)
# and stores few items in a sqlite3 database.

# table name: SONG with TITLE, ARTIST, ALBUM yet

# coding guidelines I will try to follow https://www.python.org/dev/peps/pep-0008/

# packages needed:
# pip install --user pytaglib       https://github.com/supermihi/pytaglib
# pip install --user python-magic   https://github.com/ahupp/python-magic
# pip install --user result         https://pypi.org/project/result/ MIT

import taglib # for idtags
import os # directory/file/path access
import sys # args
import sqlite3 # db connect
import hashlib # duplicates recognition via hash
import magic # for mime/type identification
import result # a rust like result

from result import Ok, Err

# try to insert song into the db
def insert_into_db(connection, songtag, result_image):
    # tags are mostly a list!!
    titles  = songtag.tags["TITLE"]
    artists = songtag.tags["ARTIST"]
    albums = songtag.tags["ALBUM"]

    # take first item and take "unknown" if empty
    title = titles[0] if titles else "unknown"
    artist = artists[0] if artists else "unknown"
    album = albums[0] if albums else "unknown"
    # image string if not there is empty
    image = result_image.value if Ok(result_image) else ""

    # to ensure uniqueness we add the hash of the strings together (not image)
    hash_prep = title + "_" + artist + "_" + album
    hash_for_unique_key = hashlib.md5(hash_prep.encode('utf-8')).hexdigest()

    try:
        # this form should be stable with utf8 and escaping
        connection.execute('INSERT OR IGNORE INTO SONGS VALUES (?,?,?,?,?)'
            ,(title,artist,album,image, hash_for_unique_key))
    except sqlite3.DatabaseError as e:
        # duplicates maybe
        pass
    except Exception as e:
        print("title: %s" %title)
        print("artist: %s" %artist)
        print("album: %s" %album)
        print(e)
        pass
    else:
        return Ok(())
    return Err('File could not added')

# find image file partnering the given file
def find_image(file):
    # prepare mime
    mime = magic.Magic(mime=True)
    # decompose dir,name and extension
    dir = os.path.dirname(file)
    base = os.path.basename(file)
    name,extension = os.path.splitext(base)

    for f_name in os.listdir(dir):
        if f_name.startswith(name):
            candidate = os.path.join(dir,f_name)
            # mime split not path!!!
            candidate_mime_main = mime.from_file(candidate).split("/")[0]
            if candidate_mime_main == 'image':
                # first image file found is already enough
                return Ok(candidate)
    return Err('no image could be found!')


# ################################################################


# Set the directory you want to start from
arg_len = len(sys.argv)
if len(sys.argv) != 3:
    print("exactly 2 parameter (start directory) (path and name to db) allowed")
    quit()
else:
    source_dir = sys.argv[1]
    target_name = sys.argv[2]


conn = sqlite3.connect(target_name)
try:
    conn.execute(
     '''CREATE TABLE SONGS (TITLE text, ARTIST text, ALBUM text, image text, hash text, PRIMARY key(hash))'''
     )
except sqlite3.DatabaseError as e:
    print("Probably already existing database")
    #print(e)
except Exception as e:
    print(e)
    quit()

good_songs = 0
bad_songs = 0
no_song = 0
images_song = 0

for dir_name, subdirList, fileList in os.walk(source_dir):
    #print('Found directory: %s' % dirName)
    for fname in fileList:
        full_name = os.path.join(dir_name,fname)
        stats = (good_songs,bad_songs)
        try:
            song = taglib.File(full_name)
        except Exception:
            no_song+=1
            # these files could not be read by taglib
            pass
        else:
            result_image = find_image(full_name)
            if result_image.is_ok():
                images_song+=1
            if insert_into_db(conn,song,result_image).is_ok():
                good_songs+=1
            else:
                bad_songs+=1

# commit changes to database
conn.commit()
# don't forget to close
conn.close()
print("Found %s valid songs (%s accompanying images, %s not processible), and %s other files."
    %(good_songs,images_song, bad_songs,no_song))
