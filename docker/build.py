# -*- coding: utf-8 -*-


import configparser
import os
import os.path as op
import shutil as sh
import subprocess


# init extend ini file parser
config = configparser.ConfigParser()
config._interpolation = configparser.ExtendedInterpolation()

# read the config file
work_dir = op.abspath(op.dirname(__file__))
ini_file = op.join(work_dir, 'config.ini')
config.read(ini_file)

# set config dir path as abspath
tmp_path = op.join(work_dir, config["docker"]["home_config_dir"])
if not op.exists(tmp_path + ".tar.gz"):
    sh.make_archive(
        tmp_path,
        "gztar",
        op.join(work_dir, '../dumbThings')
    )

# tmp docker file
dockerfile_path = op.join(work_dir, 'Dockerfile')
with open(dockerfile_path, 'w') as f:
    f.write(config["docker"]["dockerfile"])

cmd = "docker build -t {} -f {} {}".format(
    config["tag"]["name"],
    op.basename(dockerfile_path),
    work_dir
)

status = subprocess.call(cmd, shell=True)

if status == 0:
    os.remove(dockerfile_path)
    os.remove(tmp_path + ".tar.gz")
