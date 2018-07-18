# -*- coding: utf-8 -*-

import os
import os.path as op
import sys
import subprocess
import configparser
import logging
import fire
import git
from datetime import datetime


def create_logger(level):
    logger = logging.getLogger(__name__)
    logger.setLevel(level)
    # create handler
    ch = logging.StreamHandler()
    # create formatter
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    # add formatter to ch
    ch.setFormatter(formatter)

    # add ch to logger
    logger.addHandler(ch)
    return logger


log = create_logger(logging.INFO)


def check_tools_meet():
    """check synchronize tool rsync if exist"""
    check = subprocess.Popen("rsync -h", shell=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL)
    status = check.poll()
    return True if status == 0 else False


def read_sync_files(cfg_file, specific):

    cfg = configparser.ConfigParser()
    cfg.read(cfg_file)
    read_sections = []

    home_name = cfg["home"].get("path")
    home_dir = os.environ.get(home_name)

    if specific:
        read_sections.extend(specific)

    files = []
    for sec_name in read_sections:
        try:
            sec_part = cfg[sec_name]
        except KeyError:
            log.error("Specified section name [{}] doesn't exist.".format(sec_name))
            continue

        for _, sval in sec_part.items():
            sval = sval.strip().split(" ")
            files.extend(sval)

    return {"home": home_dir, "files": files}


def sync_helper(src, dest, verbose=False):
    """
    保证两边文件是相同的, 如果目标文件夹dest中没有来源文件夹src中的文件
    就删除
    """
    cmd = '''rsync -rp --cvs-exclude {src} {dest} '''.format(src=src, dest=dest)
    cmd += ' --delete --delete-after'
    if verbose:
        cmd_info = subprocess.Popen(cmd, shell=True,
                stdout=subprocess.STDOUT,
                stderr=subprocess.PIPE)
    else:
        cmd_info = subprocess.Popen(cmd, shell=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.PIPE)
    _, err = cmd_info.communicate()
    status = cmd_info.poll()
    dest_file = op.join(dest, op.basename(src))
    if status == 0:
        log.info("{src} ==> {dest} 同步成功".format(src=src, dest=dest_file))
    else:
        log.error("{src} ==> {dest} 同步失败. 原因如下:\n {msg}".format(
            src=src, dest=dest_file, msg=err.decode('utf-8')))


def sync_selected_files(files, src_dir, dest_dir, verbose=False):
    for f in files:
        f_src = op.join(src_dir, f)
        f_dest = op.join(dest_dir, f)
        f_dest_dir = op.dirname(f_dest)
        os.makedirs(f_dest_dir, exist_ok=True)
        sync_helper(f_src, f_dest_dir, verbose)


def git_push_if(repo):
    """Check if untracked files, add, commit and push them to remote"""
    if repo.untracked_files or repo.is_dirty():
        log.debug(repo.git.status())
        repo.index.add(repo.untracked_files)
        changed_files = [item.a_path for item in repo.index.diff(None)]
        repo.index.add(changed_files)
        today = datetime.today().strftime('%Y%m%d')
        repo.index.commit("Auto synchronize task at day: {}".format(today))
        log.info("pushing to remote origin git project ...")
        repo.remotes.origin.push()
        log.info("pushed successfully!")
        log.debug(repo.git.status())


def git_pull_if(repo):
    """Check remote update and pull changes to local"""
    repo.remotes.origin.fetch()


def run(**opt):

    debug = opt.get('debug', False)
    if debug:
        log.setLevel(logging.DEBUG)

    repo_path = op.dirname(__file__)
    repo = git.Repo(repo_path)
    # log.debug(dir(repo))

    disable_git = opt.get('disable_git', False)

    cfg_file = opt.get('config_file', 'config.ini')
    selected_sections = opt.get('sections', ["common"])
    cfg = read_sync_files(cfg_file, selected_sections)

    repo_dir = op.join(repo_path, 'dynamic')
    home_dir = cfg.get('home')
    if not op.exists(home_dir):
        raise Exception("Home directory must exists")

    sync_files = cfg.get('files')
    if not sync_files:
        log.warn("synchronize file list is empty.")
        sys.exit(1)

    # remote files override local files
    do_local_override = opt.get('local_override', False)
    if do_local_override:
        if not disable_git:
            git_pull_if(repo)
        sync_selected_files(sync_files, repo_dir, home_dir)

    do_remote_override = opt.get('remote_override', False)
    if do_remote_override:
        sync_selected_files(sync_files, home_dir, repo_dir)
        if not disable_git:
            git_push_if(repo)


if __name__ == "__main__":
    fire.Fire(run)
