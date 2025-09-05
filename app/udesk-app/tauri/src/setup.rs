use std::process::Command;
use std::fs;
use std::path::Path;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct SystemInfo {
    pub os: String,
    pub arch: String,
    pub node_version: Option<String>,
    pub rust_version: Option<String>,
    pub has_gcc: bool,
    pub has_git: bool,
    pub udesk_installed: bool,
}

#[tauri::command]
pub async fn get_system_info() -> Result<SystemInfo, String> {
    let os = if cfg!(target_os = "macos") {
        "macOS".to_string()
    } else if cfg!(target_os = "linux") {
        "Linux".to_string()
    } else if cfg!(target_os = "windows") {
        "Windows".to_string()
    } else {
        "Unknown".to_string()
    };

    let arch = std::env::consts::ARCH.to_string();

    // Check Node.js version
    let node_version = check_command_version("node", "--version");
    
    // Check Rust version
    let rust_version = check_command_version("rustc", "--version");
    
    // Check GCC/build tools
    let has_gcc = check_command_exists("gcc") || check_command_exists("clang");
    
    // Check Git
    let has_git = check_command_exists("git");
    
    // Check if uDESK is properly installed
    let udesk_installed = check_udesk_installation();

    Ok(SystemInfo {
        os,
        arch,
        node_version,
        rust_version,
        has_gcc,
        has_git,
        udesk_installed,
    })
}

#[tauri::command]
pub async fn needs_first_time_setup() -> Result<bool, String> {
    // Check if this is a first-time setup
    let config_exists = Path::new(".udesk/config").exists();
    let workspace_exists = Path::new("uMEMORY").exists();
    
    Ok(!config_exists || !workspace_exists)
}

#[tauri::command]
pub async fn install_component(component: String) -> Result<String, String> {
    match component.as_str() {
        "nodejs" => install_nodejs().await,
        "rust" => install_rust().await,
        "build-tools" => install_build_tools().await,
        "workspace" => setup_workspace().await,
        _ => Err(format!("Unknown component: {}", component)),
    }
}

#[tauri::command]
pub async fn open_documentation() -> Result<(), String> {
    let doc_path = "core/docs/UCODE-MANUAL.md";
    
    #[cfg(target_os = "macos")]
    {
        Command::new("open")
            .arg(doc_path)
            .output()
            .map_err(|e| format!("Failed to open documentation: {}", e))?;
    }
    
    #[cfg(target_os = "linux")]
    {
        Command::new("xdg-open")
            .arg(doc_path)
            .output()
            .map_err(|e| format!("Failed to open documentation: {}", e))?;
    }
    
    #[cfg(target_os = "windows")]
    {
        Command::new("cmd")
            .args(&["/C", "start", doc_path])
            .output()
            .map_err(|e| format!("Failed to open documentation: {}", e))?;
    }
    
    Ok(())
}

fn check_command_version(command: &str, version_arg: &str) -> Option<String> {
    Command::new(command)
        .arg(version_arg)
        .output()
        .ok()
        .and_then(|output| {
            if output.status.success() {
                String::from_utf8(output.stdout)
                    .ok()
                    .map(|s| s.trim().to_string())
            } else {
                None
            }
        })
}

fn check_command_exists(command: &str) -> bool {
    #[cfg(target_os = "windows")]
    {
        Command::new("where")
            .arg(command)
            .output()
            .map(|output| output.status.success())
            .unwrap_or(false)
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        Command::new("which")
            .arg(command)
            .output()
            .map(|output| output.status.success())
            .unwrap_or(false)
    }
}

fn check_udesk_installation() -> bool {
    Path::new("build.sh").exists() && 
    Path::new("app/udesk-app").exists() &&
    Path::new("core").exists()
}

async fn install_nodejs() -> Result<String, String> {
    #[cfg(target_os = "macos")]
    {
        // Check if Homebrew exists
        if check_command_exists("brew") {
            let output = Command::new("brew")
                .args(&["install", "node"])
                .output()
                .map_err(|e| format!("Failed to install Node.js: {}", e))?;
            
            if output.status.success() {
                Ok("Node.js installed successfully via Homebrew".to_string())
            } else {
                let error = String::from_utf8_lossy(&output.stderr);
                Err(format!("Homebrew install failed: {}", error))
            }
        } else {
            Err("Homebrew not found. Please install Homebrew first: https://brew.sh/".to_string())
        }
    }
    
    #[cfg(target_os = "linux")]
    {
        // Install Node.js via NodeSource repository for Ubuntu/Debian
        let setup_output = Command::new("curl")
            .args(&["-fsSL", "https://deb.nodesource.com/setup_lts.x"])
            .output()
            .map_err(|e| format!("Failed to download NodeSource setup: {}", e))?;
        
        if !setup_output.status.success() {
            return Err("Failed to download NodeSource setup script".to_string());
        }
        
        let setup_script = String::from_utf8_lossy(&setup_output.stdout);
        
        // Run the setup script
        let output = Command::new("bash")
            .arg("-c")
            .arg(format!("echo '{}' | sudo bash -", setup_script))
            .output()
            .map_err(|e| format!("Failed to run NodeSource setup: {}", e))?;
        
        if !output.status.success() {
            return Err("NodeSource setup failed".to_string());
        }
        
        // Install Node.js
        let install_output = Command::new("sudo")
            .args(&["apt-get", "install", "-y", "nodejs"])
            .output()
            .map_err(|e| format!("Failed to install Node.js: {}", e))?;
        
        if install_output.status.success() {
            Ok("Node.js installed successfully via NodeSource".to_string())
        } else {
            let error = String::from_utf8_lossy(&install_output.stderr);
            Err(format!("Node.js installation failed: {}", error))
        }
    }
    
    #[cfg(target_os = "windows")]
    {
        Err("Automated Node.js installation not supported on Windows. Please download from: https://nodejs.org/".to_string())
    }
}

async fn install_rust() -> Result<String, String> {
    #[cfg(not(target_os = "windows"))]
    {
        let output = Command::new("curl")
            .args(&[
                "--proto", "=https",
                "--tlsv1.2",
                "-sSf",
                "https://sh.rustup.rs",
                "-o", "/tmp/rustup.sh"
            ])
            .output()
            .map_err(|e| format!("Failed to download Rust installer: {}", e))?;
        
        if !output.status.success() {
            return Err("Failed to download Rust installer".to_string());
        }
        
        let output = Command::new("sh")
            .args(&["/tmp/rustup.sh", "-y"])
            .output()
            .map_err(|e| format!("Failed to install Rust: {}", e))?;
        
        if output.status.success() {
            Ok("Rust installed successfully".to_string())
        } else {
            let error = String::from_utf8_lossy(&output.stderr);
            Err(format!("Rust installation failed: {}", error))
        }
    }
    
    #[cfg(target_os = "windows")]
    {
        Err("Automated Rust installation not supported on Windows. Please download from: https://rustup.rs/".to_string())
    }
}

async fn install_build_tools() -> Result<String, String> {
    #[cfg(target_os = "macos")]
    {
        let output = Command::new("xcode-select")
            .arg("--install")
            .output()
            .map_err(|e| format!("Failed to install build tools: {}", e))?;
        
        if output.status.success() {
            Ok("Xcode Command Line Tools installation started. Please follow the dialog prompts.".to_string())
        } else {
            let error = String::from_utf8_lossy(&output.stderr);
            if error.contains("already installed") {
                Ok("Build tools are already installed".to_string())
            } else {
                Err(format!("Build tools installation failed: {}", error))
            }
        }
    }
    
    #[cfg(target_os = "linux")]
    {
        let output = Command::new("sudo")
            .args(&["apt", "update", "&&", "sudo", "apt", "install", "-y", "build-essential"])
            .output()
            .map_err(|e| format!("Failed to install build tools: {}", e))?;
        
        if output.status.success() {
            Ok("Build tools installed successfully".to_string())
        } else {
            let error = String::from_utf8_lossy(&output.stderr);
            Err(format!("Build tools installation failed: {}", error))
        }
    }
    
    #[cfg(target_os = "windows")]
    {
        Err("Automated build tools installation not supported on Windows. Please install Visual Studio Build Tools manually.".to_string())
    }
}

async fn setup_workspace() -> Result<String, String> {
    // Create .udesk directory
    fs::create_dir_all(".udesk")
        .map_err(|e| format!("Failed to create .udesk directory: {}", e))?;
    
    // Create basic config file
    let config = r#"# uDESK Configuration v1.0.7
role=GHOST
theme=polaroid
workspace=uMEMORY
mode=USER
first_run=false
"#;
    
    fs::write(".udesk/config", config)
        .map_err(|e| format!("Failed to write config file: {}", e))?;
    
    // Create uMEMORY workspace structure
    fs::create_dir_all("uMEMORY/backups")
        .map_err(|e| format!("Failed to create workspace: {}", e))?;
    fs::create_dir_all("uMEMORY/projects")
        .map_err(|e| format!("Failed to create workspace: {}", e))?;
    fs::create_dir_all("uMEMORY/logs")
        .map_err(|e| format!("Failed to create workspace: {}", e))?;
    
    // Create welcome file
    let welcome = r#"🚀 Welcome to uDESK v1.0.7!

This is your uMEMORY workspace where all your projects and data are stored.

Directories:
- backups/   - Automatic backups of your work
- projects/  - Your development projects
- logs/      - System and application logs

Quick Commands:
- [HELP] - Show all available commands
- [BACKUP] - Create a backup of your work
- [INFO] - Display system information

Role Progression:
👻 GHOST → ⚰️ TOMB → 🤖 DRONE → 🔐 CRYPT → 😈 IMP → ⚔️ KNIGHT → 🔮 SORCERER → 🧙‍♂️ WIZARD

Happy coding! 🎉
"#;
    
    fs::write("uMEMORY/README.md", welcome)
        .map_err(|e| format!("Failed to write welcome file: {}", e))?;
    
    Ok("Workspace initialized successfully".to_string())
}
