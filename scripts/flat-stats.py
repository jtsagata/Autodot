#!/usr/bin/python3 

"""
This python script will find flatpak deduplication size stats.
Made with :heart: by powpingdone#3611, or just powpingdone on github.
Explaination for output:

'no dedupe': The size that the ostree repository would take up if files were not deduplicated.
'dedupe': The actual size of the ostree repository.
'singlet': The size of all files that are referenced once.
'orphan': The size of all files not referenced (ie, only one hard link).

'deduplicated size ratio': The higher this is, the more space is taken up by unique files.
'singlelet space usage': The higher this is, the more actual space is taken up by files used once.
'singlelet ratio': The ratio of files that are only shared between applications/runtimes once.
'orphan space usage': The higher this is, the more actual space is taken up by unrefererenced files.
'orphan file ratio': The ratio of files that are somehow not even referenced by flatpak.
"""

from glob import glob
from os import path, scandir
from sys import exit
import argparse
from copy import deepcopy as copy

# argparsing
parser = argparse.ArgumentParser(description="Find flatpak deduplication size stats")
parser.add_argument('-a', '--app', type=str, help="application/runtime to check individual stats", default="")
parser.add_argument('-p', '--path', type=str, help="path to flatpak installation", default="/var/lib/flatpak")
parser.add_argument('-q', '--quiet', action=argparse.BooleanOptionalAction, help="don't output \"collecting app/runtime\" messages")
args = parser.parse_args()
PATH_ROOT = args.path
APP_CHECK = args.app
QUIET = args.quiet

# path checking
if not path.exists(PATH_ROOT):
    print(f"{PATH_ROOT} does not exist or is not able to be seen, exiting...")
    exit(1)

if not (path.exists(PATH_ROOT + "/app") and path.exists(PATH_ROOT + "/runtime")):
    print(f"{PATH_ROOT} does not point to a \"valid\" flatpak repo, exiting...")
    exit(2)

if APP_CHECK != "" and not (path.exists(PATH_ROOT + "/app/" + APP_CHECK) or path.exists(PATH_ROOT + "/runtime/" + APP_CHECK)):
    print(f"{APP_CHECK} doesn't exist within the app or runtime at {PATH_ROOT}")
    exit(3)

# stats collection
def collect(x, s):
    collect_print_str(x)
    return collect_data(x, s)

def collect_data(globbed, stats):
    for file in scandir(globbed):
        if file.is_symlink():
            continue

        if file.is_dir():
            stats = collect_data(file.path, stats)
            continue
            
        statout = file.stat(follow_symlinks=False)
        stats["not_deduped_size"] += statout.st_size

        if statout.st_nlink == 2:
            stats["singlelet_files"] += 1
            stats["singlelet_size"] += statout.st_size
        
        if statout.st_nlink == 1:
            stats["orphan_files"] += 1
            stats["orphan_size"] += statout.st_size
       
        # deduped related stats
        if statout.st_ino in stats["inodes"]:
            continue
        stats["inodes"][statout.st_ino] = None
        stats["all_files"] += 1
        stats["deduped_size"] += statout.st_size
    return stats

def collect_print_str(x):
    global QUIET
    if not QUIET:
        print(f"collecting {'app' if x.split('/')[-2] == 'app' else 'runtime'} {x.split('/')[-1]}")

def construct_stats():
    return {
        "not_deduped_size": 0,
        "deduped_size": 0,
        "singlelet_size": 0,
        "singlelet_files": 0,
        "orphan_size": 0,
        "orphan_files": 0,
        "all_files": 0,
        "inodes": {}
    }

stats = construct_stats()
pop_path = ""

for downloaded in glob(PATH_ROOT + "/app/*") + glob(PATH_ROOT + "/runtime/*"):
    if downloaded.split('/')[-1] == APP_CHECK:
        pop_path = downloaded
        continue
    stats = collect(downloaded, stats)    

# individual application stats
indv_stats = construct_stats()
indv_stats["inodes"] = copy(stats['inodes'])

if pop_path != "":
    stats = collect(pop_path, stats)
    indv_stats = collect_data(pop_path, indv_stats)

# print stats
def to_human_readable_size(num):
    for suffix in ["B", "KB", "MB", "GB"]:
        if abs(num) < 1024:
            return f"{num:.1f} {suffix}"
        num /= 1024
    return f"{num:.1f} TB"

br = "\n==========================================="

if not QUIET:
    print(br)
print(f"no dedupe: {to_human_readable_size(stats['not_deduped_size'])} ({stats['not_deduped_size']} B)")
print(f"dedupe:    {to_human_readable_size(stats['deduped_size'])} ({stats['deduped_size']} B)")
print(f"singlelet: {to_human_readable_size(stats['singlelet_size'])} ({stats['singlelet_size']} B)")
print(f"orphan:    {to_human_readable_size(stats['orphan_size'])} ({stats['orphan_size']} B)")
print(br)
print(f"deduplicated size ratio: {100*(stats['deduped_size']   /stats['not_deduped_size']):0.2f}")
print(f"singlelet space usage:   {100*(stats['singlelet_size'] /stats['deduped_size']):0.2f}")
print(f"singlelet file ratio:    {100*(stats['singlelet_files']/stats['all_files']):0.2f}")
print(f"orphan space usage:      {100*(stats['orphan_size']    /stats['deduped_size']):0.2f}")
print(f"orphan file ratio:       {100*(stats['orphan_files']   /stats['all_files']):0.2f}")
if pop_path != "":
    print(br)
    print(f"{APP_CHECK} no dedupe:               {to_human_readable_size(indv_stats['not_deduped_size'])} ({indv_stats['not_deduped_size']} B)")
    print(f"{APP_CHECK} dedupe:                  {to_human_readable_size(indv_stats['deduped_size'])} ({indv_stats['deduped_size']} B)")
    print(f"{APP_CHECK} singlelet:               {to_human_readable_size(indv_stats['singlelet_size'])} ({indv_stats['singlelet_size']} B)")
    print(f"{APP_CHECK} orphan:                  {to_human_readable_size(indv_stats['orphan_size'])} ({indv_stats['orphan_size']} B)")
    print(f"{APP_CHECK} deduplicated size ratio: {100*(indv_stats['deduped_size']   /indv_stats['not_deduped_size']):0.2f}")
    print(f"{APP_CHECK} orphan space usage:      {100*(indv_stats['orphan_size']    /indv_stats['deduped_size']):0.2f}")
    print(f"{APP_CHECK} orphan file ratio:       {100*(indv_stats['orphan_files']   /indv_stats['all_files']):0.2f}")
