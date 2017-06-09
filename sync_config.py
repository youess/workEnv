# -*- coding: utf-8 -*-


# replace current config files
import os
import sys
import os.path as op
import subprocess
import argparse

sync_list = ['.vimrc', '.cheat', '.gitconfig', '.config']

FNULL = open(os.devnull, 'w')
status = subprocess.call(
    "rsync -h", shell=True,
    stdout=FNULL, stderr=FNULL)

if status != 0:
    print("Please install rsync to sync the configuration files")
    sys.exit(1)

# store directory
CONFIG_DIR = op.join(op.abspath(op.dirname(__file__)), 'dumbThings')

if not op.exists(CONFIG_DIR):
    os.makedirs(CONFIG_DIR)


# 同步配置文件
def sync_helper(src, dest):
    # 保证两边的文件是一致的，如果dest没有src的文件就删除
    cmd = """
    rsync -rp {src} {dest} --delete --delete-after
    """.format(src=src, dest=dest)
    status = subprocess.call(cmd, shell=True)
    if status == 0:
        print("从{}同步成功!".format(src))
    else:
        print("从{}同步失败!".format(src))


parser = argparse.ArgumentParser()
parser.add_argument(
    "--from",
    dest="from_local",
    action="store_true",
    help="Sync local machine home config files to this repository."
)
parser.add_argument(
    "--to",
    action="store_true",
    help="Sync this repository files to local machine home direcotry." +
    " Do not use it with --from option"
)

args = parser.parse_args()


if args.from_local:
    sync_file_list = [
        op.join(os.environ.get('HOME'), p)
        for p in sync_list
    ]

    for sf in sync_file_list:
        sync_helper(
            sf,
            CONFIG_DIR
        )
elif args.to:
    sync_file_list = [op.join(CONFIG_DIR, p) for p in os.listdir(CONFIG_DIR)]
    for sf in sync_file_list:
        sync_helper(
            sf,
            os.environ.get("HOME")
        )
else:
    parser.print_help()
    print("Nothing did!")
