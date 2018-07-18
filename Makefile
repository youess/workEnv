
test:
	python3 synchronizer.py --disable_git=True --remote_override --debug=1

remote:
	python3 synchronizer.py --remote_override

local:
	python3 synchronizer.py --local_override
