# uDESK OS Project

> **Version**: 1.0.6
> 

> **Status**: Development
> 

> **Philosophy**: Markdown Everything
> 

## Project Overview

uDESK is a markdown-focused operating system built on TinyCore Linux, designed around the principle that everything should be configurable and readable in markdown format.

## Key Links

- **GitHub Repository**: [Local Code Folder]
- **Documentation**: Stored in `/docs/` folder
- **Build System**: Automated via `./[build.sh](http://build.sh)`

## Current Milestone

**M1 - Core Integration** (Current Focus)

- Package `udos-core.tcz`
- Implement boot hooks
- Set persistence defaults
- **Goal**: Boot to CLI with `udos-core` active

## Architecture

### Role-Based System

- **Basic**: Minimal shell + markdown tools
- **Standard**: Desktop + apps + limited sudo
- **Admin**: Development + full sudo

### Core Components

- **udos-core.tcz**: Core system with markdown configs
- **udos-role-*.tcz**: Role-specific packages
- **Build system**: Automated packaging and ISO creation

## Development Workflow

1. **Claude Code**: Generate markdown configs/scripts
2. **glow**: Review generated output
3. **micro**: Quick manual edits
4. [**build.sh**](http://build.sh): Package everything
5. **QEMU**: Test immediately

## Next Actions

- [ ]  Download TinyCore base ISO
- [ ]  Run first build: `./[dev.sh](http://dev.sh) build`
- [ ]  Test in QEMU: `./[dev.sh](http://dev.sh) test`
- [ ]  Implement M1 milestone components

*A truly markdown-everything operating system in development.*

[Roadmap](Roadmap%20260954f7ff4e81b68a40d3ccf2a136b5.md)

[Tasks](Tasks%2013a79a10f3a14e929627ead00485e57e.csv)