# GameMaker Reverse Engineering Tools

A collection of GDB and Ghidra automation scripts for analyzing GameMaker Engine executables.

These tools were developed while reverse engineering GameMaker-based games and are designed to accelerate analysis by recovering engine information, inspecting runtime structures, and improving static analysis workflows.

## Overview

GameMaker executables often contain a large amount of engine functionality but provide limited symbol information after compilation. Important functions may appear only as anonymous addresses:


FUN_140123450
FUN_140123890
FUN_140124000


This repository contains tools to recover useful information from the running process and import it into reverse-engineering environments.

Workflow:

    GameMaker Executable
            |
            v
      GDB Runtime Analysis
            |
            v
   Extract Runtime Information
            |
            v
         Ghidra Import
            |
            v
   Improved Static Analysis

---

# Tools

## Builtin Function Dumper (`dump_builtins`)

Extracts GameMaker's builtin function table from memory.

GameMaker exposes many internal functions through a runtime builtin registry. This script takes the table address as input, extracts function names, addresses, and argument counts, then generates data that can be imported into Ghidra.

Example output:


[ 15] func=0x140123450 argc=3 name=draw_sprite
[ 16] func=0x140124890 argc=2 name=instance_create
[ 17] func=0x140129000 argc=1 name=ds_grid_create


Before importing:


FUN_140123450
FUN_140124890
FUN_140129000


After importing:


gm_draw_sprite
gm_instance_create
gm_ds_grid_create


---

## Ghidra Builtin Importer (`import_builtins.java`)

Automatically renames recovered GameMaker functions inside Ghidra.

The script:

1. Reads the output generated from GDB
2. Parses recovered function addresses and names
3. Locates matching functions in Ghidra
4. Applies recovered symbols

Example:


0x140123450 -> gm_draw_sprite


This greatly improves readability when analyzing compiled GameMaker binaries.

---

# Runtime Inspection Scripts

## `log_grid`

Inspects GameMaker `ds_grid` operations at runtime.

This script is used when breaking on grid modification functions to inspect:

- Grid pointer
- Grid coordinates
- Stored value type
- Runtime payload

Example output:

=== ds_grid_set ===
grid ptr: 0x12345678
col (x): 5
row (y): 12
type: 0x0
value (double): 42.0

Useful for analyzing:

- Puzzle systems
- Tilemaps
- Procedural data
- Runtime game state storage

---

## `log_ini_write`

Logs GameMaker INI file writes.

Intercepts runtime calls and displays:

- INI section
- Key name
- Written value

Example:

--- INI WRITE ---
Section: settings
Key: fullscreen
Value: true

Useful for identifying:

- Configuration systems
- Save data behavior
- Runtime settings

---

# Requirements

## GDB

Required:

- GDB with support for debugging native executables
- Ability to attach to or launch the target GameMaker executable

## Ghidra

Required for:

- Static analysis
- Importing recovered symbols
- Function renaming

Tested workflow:


GDB -> Symbol Extraction -> Ghidra Import


---

# Usage

## Dump GameMaker Builtins

Load the GDB script:


source dump_builtins.gdb


Run:


dump_builtins


Save the output:


(gdb) dump_builtins > builtins.txt


---

## Import Symbols into Ghidra

Open the target executable in Ghidra.

Run:


import_builtins.java


Recovered GameMaker functions will automatically be renamed.

---

# Technical Details

## Builtin Table Layout

The builtin table is assumed to contain entries structured similar to:

```c
struct BuiltinEntry
{
    char* name;
    void* function;
    uint32_t argumentCount;
};

Each entry contains:

+0x00 name pointer
+0x08 function pointer
+0x10 argument count
+0x18 next entry

The scripts use runtime memory inspection to recover these values.
