# MVS 3.8j System Generation on Hercules emulator
## Overview
This repository documents the complete System Generation (SysGen) of IBM's classic mainframe operating system, MVS 3.8j, running on the Hercules System/370, ESA/390, and z/Architecture Emulator.

Unlike automated "turnkey" distributions (like TK4-), this project covers a manual, ground-up installation process. It serves as an in-depth technical exploration of mainframe architecture, DASD initialization, JCL execution, and system administration workflows.

## Key Objectives
- System Architecture: Understand the interaction between the Hercules hardware emulator (virtual DASD, tape drives, punch cards) and the MVS OS.

- System Generation: Perform a complete MVS SysGen using IBM utility programs (ICKDSF, IEBCOPY, IEHPROGM, SMP).

- Practical Operation: Document the daily operation of a mainframe environment, from the master console to TSO and ISPF interfaces.

- Development Ready: Prepare a stable environment for compiling and running COBOL, C, and Assembly (HLASM) programs.

## Tech Stack & Environment
- Host OS: Arch Linux (EndeavourOS)

- Emulator: Hercules 4.x (Hyperion)

- Guest OS: IBM MVS 3.8j (Public Domain)

- Interfaces: x3270 (3270 Terminal Emulation)

## Project Layout
```bash
MVS_3.8J/
├── conf/           # config files for Hercules
│   ├── dlibs.script
│   ├── ibcdmprs.cnf
│   ├── mvs.cnf
│   ├── mvs.script
│   ├── smp1.cnf
│   ├── smp2.cnf
│   ├── sysgen.cnf
│   └── sysgen.script
├── dasd/           # DASD volumes, IBM designation for storage volumes
│   └── *.3350
├── jcl/            # Jobstreams submitted to MVS Starter system to build distribution libraries
│   └── *.jcl
├── sajobs/         # Stand Alone Job, used by Hercules for SYSGEN and disk initialization
│   ├── inspool0.sajob
│   ├── instart1.sajob
│   ├── rsspool0.sajob
│   └── rsstart1.sajob
├── tape/           # Various tapes containing data needed for MVS
│   └── *.het
├── assets/
│   └── imgs/
│        └── *.png
├── docs/           # Ressources and additionals README.md
│   ├── *.pdf
│   └── *.md
├── .gitattributes
├── condcode.rexx   # REXX script to extract/display condition codes for jobs
├── create.dasd.sh  # bash script that utilizes the dasdinit utility to create empty DASD volumes
├── mvslog.txt
├── pch00d.txt
├── pch013.txt
├── pch01d.txt
├── prt00e.txt      # MVS Console logs for completion codes
├── prt00f.txt
├── README.md
├── stage1.output
├── stage2.awk
├── stage2.rexx
└── submit.sh       # bash shell script that passes jobstream file to socket reader using netcat
```

## Documentation Index

### 1. Installation & SysGen
#### Part 1: Hercules Setup & Prerequisites

- Compiling Hercules with zlib and bzip2 support on Arch Linux.

- Preparing the Starter System and Tape images.

#### Part 2: DASD Initialization & SysGen (Stage 1 & 2)

- Formatting virtual drives with ICKDSF.

- Applying PTFs and building the distribution libraries.

### 2. Operations & Usage
#### Part 3: MVS Master Console Guide

- Starting (IPL) and shutting down the system.

- Managing JES2, responding to system prompts (Reply), and managing devices (Vary).

#### Part 4: TSO & ISPF Fundamentals

- Connecting via 3270 emulators (c3270/x3270).

- Navigating the ISPF interface and submitting batch jobs (JCL).

## Quick Start (Running the System)
Assuming the SysGen is complete and the DASD volumes are present in the dasd/ directory.

Start the Hercules Engine:
```bash
cd Projects/MVS_3.8j
hercules -f conf/mvs.cnf
```
IPL the System (from the Hercules console):
```text
ipl 150
```
Connect the Terminal:
Open a new terminal window and connect using a 3270 emulator:
```bash
x3270 -model 3279-2 console@localhost:3270 &
```
or with a specific font, for me it's the terminus font:
```bash
x3270 -model 3279-2 -efont "-xos4-terminus-medium-r-normal--24-240-72-72-c-120-iso10646-1" console@localhost:3270 &
```
(See the [Console Guide](docs/MVS_startup_shutdown.md) for startup replies and JES2 initialization).

## Author
Lilian Monsat

[LinkedIn](https://www.linkedin.com/in/lilian-monsat)

## Ressources

- https://www.jaymoseley.com/hercules/installMVS/iMVSintroV8.htm
- [MVS_OS.pdf](docs/MVS_OS.pdf)
- [MVS_system_commands.pdf](docs/MVS-System-Commands.pdf)
- [MVS_command_summary.pdf](docs/Volker_Bandke_Command_Summaries.pdf)