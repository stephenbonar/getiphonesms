#!/bin/bash
#
# iPhone SMS Extraction Script v1.0
# Copyright © 2016 Stephen Bonar
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

# Store the export file on the desktop.
desktop_dir=$(echo ~/Desktop)

# iPhone backups are always stored in the same place, by default.
backup_dir=$(echo ~/Library/Application\ Support/MobileSync/Backup/)

# Obtain the most recent backup directory name.
latest_backup=$(ls -t "$backup_dir" | head -n1)

# Out of the hundreds of files, the SMS database is always named the same.
sms_db_file='3d0d7e5fb2ce288813306e4d4636395e047a3d28'

# This SQLITE3 script will dump the database contents to a CSV file.
sql_script="
.mode csv
.headers on 
.out $desktop_dir/text_messages.csv 
select datetime(message.date,'unixepoch','localtime','+31 years') as date,handle.id as 'from',message.subject,message.text from message,handle where message.handle_id == handle.rowid;"

# Perform the export.
echo "$sql_script" | sqlite3 "$backup_dir/$latest_backup/$sms_db_file"
