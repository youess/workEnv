# -*- coding: utf-8 -*-


# replace current config files
import os
import sys
import os.path as op
import subprocess
import argparse
import git
from datetime import datetime

sync_list = ['.vimrc', '.cheat', '.gitconfig', '.config']
repo = git.Repo(op.dirname(__file__))
today_int = datetime.today().strftime("%Y%m%d")

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
    # add the change and commit it
    if repo.untracked_files or repo.is_dirty():
        print(repo.git.status())
        repo.index.add(repo.untracked_files)
        changed_files = [item.a_path for item in repo.index.diff(None)]
        repo.index.add(changed_files)
        repo.index.commit("Auto-sync Task at Day: {}".format(today_int))
        print("正在上传到远程git项目.")
        repo.remotes.origin.push()
        print("上传成功!")
        print(repo.git.status())
elif args.to:
    sync_file_list = [op.join(CONFIG_DIR, p) for p in os.listdir(CONFIG_DIR)]
    for sf in sync_file_list:
        sync_helper(
            sf,
            os.environ.get("HOME")
        )
    print("正在从远端同步文件")
    repo.remotes.origin.pull()
    print("从远端同步文件成功!")
else:
    parser.print_help()
    print("Nothing did!")
