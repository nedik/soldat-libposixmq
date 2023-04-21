# soldat-libposixmq
This is a simple library that exposes POSIX Message Queue functions for soldatserver. [Check overview of POSIX Message Queues here](https://man7.org/linux/man-pages/man7/mq_overview.7.html).
The usage in soldat scriptoce is similar to the POSIX Message Queue. For details see the `include/libposixmq.pas`.

Since POSIX IPC is not implemented on Windows, the library will only work on Unix-like operating systems like Linux.

## Requirements
- g++
- cmake
- make
TODO

## Compiling
```
mkdir build
cd build
cmake ..
make
```

## Preparation
1. Copy [compiled](#compiling) `libposixmq.so` into soldatserver root directory
2. Change the value of `AllowDlls` under `[ScriptCore3]` section in `server.ini` in your soldatserver to `AllowDlls=1` to allow external DLLs loading in your soldatserver (refer to [wiki.soldat.pl](https://wiki.soldat.pl/index.php/SC3_Config_File))
3. Copy the `include/libposixmq.pas` into a new directory `scripts/libposixmq/` in soldatserver
4. In future scripts make sure to add this configuration to the scripts' `config.ini`:
	```
	[Config]
	...
	AllowDlls=1

	[SearchPaths]
	../libposixmq
	```

## Example
### Requirements
To run python script, following system packages are needed:
	- python3.8 (or later)
	- python3.8-venv (or later)
	- pip3

### Running
After doing [Preparation](#preparation), copy `example/scripts/` to soldatserver's `scripts/`.
Open __Terminal 1__ and go to soldatserver root directory. Run soldatserver:
```
./soldatserver
```
Open __Terminal 2__ and go to `example/`. Prepare python environment:
```
python3 -m venv example-venv
source example-venv/bin/activate
python3 -m pip install posix_ipc
```
Run the `example.py`:
```
python3 example.py
```
