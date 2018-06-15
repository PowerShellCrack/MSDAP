# MSDAP
Monitor System, Downloads and Processes

# What it does
Script to automate feeding and downloading Movies and TV shows using various applications and tools via command line

# Versions:
  Version 1 - Batch
  Version 2 - Powershell

# GOAL:
Looking to convert btach script to a more robust powershell script. 


# FEATURES (configureable)
      - Schedule Run time
      - Kills UTorrent to
            Update IP filters
            Move Downloads
      - Kills Azureus to
            Update IP filters
            Move Downloads
      - Check Password protected RAR files on seedbox (winscp)
      - Unzips Password protected RAR files (7zip)
      - Executes TVRename silently
      - Downloads Torrent files using RSS feeds (https://github.com/PowerShellCrack/TorrentRSSDownloader.git)
      - Uploads Torrent Files to Seedbox (winscp)
      - Cleanup Files extensions, removes old logs and torrents, and remvoes empty Folders
      - Cleanups btsync folders as well
      - Checks Plex Service (https://github.com/cjmurph/PmsService.git)
      - Checks Plex Watch 
      - Run PlexScanner cli to output library list (to use elsehere, eg: website, database)
      - Check Plex is running
      - Check Emby and its Service
      - Check PeerBlock Service
      - Check Azureus Vuze running (if not using seedbox)
      - Check UTorrent running
      - Check Sonarr Service
      - Check Radarr Service
      - Check Jackett Service
      - Check BtSync (Resilio) Service
      - Check NETGEAR Genie running (for OpenDNS exemptions)
      - Dropbox Backup (robocopy)
      - File Backup (robocopy)
      - Logs everything

# TIP: 
This script works well as a schedule task hourly. Its built in scheduler will determine if it should process or not. Task Schedule export is provided.  

# NOTES: 
Software installed (most of them are optional) and other prerequsites:

      - Plex Media Server
      - Emby Media Server
      - Sonarr
      - Radarr
      - Resilio (btsync)
      - Winscp Binares (place in bin folder)
      - 7Zip Binares (place in bin folder)
      - Download-RSSTorrent.ps1 (place in scripts folder)
      - wget Binares (place in bin folder)
      - Utorrent
      - Dropbox
      - Azurues
      - NetGear Genie
      - Peerblock
      - Jackett
