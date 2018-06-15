# MSDAP
Monitor System, Downloads and Processes

# What it does
Script to automate feeding and downloading Movies and TV shows using various applications and tools via command line

# Versions:
  Version 1 - Batch
  Version 2 - Powershell

# GOAL:
Looking to convert btach script to a more robust powershell script. 


# Features (configureable)
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
      - Check BtSync (Resilio) Service
      - Check NETGEAR Genie running (for OpenDNS exemptions)
      - Dropbox Backup (robocopy)
      - File Backup (robocopy)
