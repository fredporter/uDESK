use std::collections::HashMap;
use std::process::{Command, Stdio};
use serde::{Deserialize, Serialize};
use tauri::State;
use tokio::sync::Mutex;
use anyhow::Result;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ContainerConfig {
    pub name: String,
    pub image: String,
    pub workspace_path: String,
    pub extensions: Vec<String>,
    pub theme: String,
    pub role: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ContainerStatus {
    pub id: String,
    pub name: String,
    pub status: String,
    pub created: String,
    pub ports: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ExtensionInfo {
    pub name: String,
    pub version: String,
    pub description: String,
    pub loaded: bool,
}

pub struct ContainerManager {
    pub containers: Mutex<HashMap<String, ContainerStatus>>,
    pub workspace_path: Mutex<String>,
}

impl ContainerManager {
    pub fn new() -> Self {
        Self {
            containers: Mutex::new(HashMap::new()),
            workspace_path: Mutex::new(String::new()),
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct SystemInfo {
    pub name: String,
    pub version: String,
    pub architecture: String,
    pub themes: Vec<String>,
    pub roles: Vec<RoleInfo>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct RoleInfo {
    pub name: String,
    pub level: u8,
    pub symbol: String,
}

#[tauri::command]
pub async fn get_udesk_info() -> Result<SystemInfo, String> {
    Ok(SystemInfo {
        name: "uDESK".to_string(),
        version: "1.0.7".to_string(),
        architecture: std::env::consts::ARCH.to_string(),
        themes: vec![
            "Polaroid".to_string(),
            "C64".to_string(),
            "Macintosh".to_string(),
            "Mode 7".to_string(),
        ],
        roles: vec![
            RoleInfo { name: "GHOST".to_string(), level: 10, symbol: "👻".to_string() },
            RoleInfo { name: "GUEST".to_string(), level: 20, symbol: "👤".to_string() },
            RoleInfo { name: "USER".to_string(), level: 30, symbol: "👨‍💻".to_string() },
            RoleInfo { name: "ADMIN".to_string(), level: 40, symbol: "🔧".to_string() },
            RoleInfo { name: "DEV".to_string(), level: 50, symbol: "🛠️".to_string() },
            RoleInfo { name: "SYSTEM".to_string(), level: 60, symbol: "⚙️".to_string() },
            RoleInfo { name: "ROOT".to_string(), level: 70, symbol: "👑".to_string() },
            RoleInfo { name: "WIZARD".to_string(), level: 100, symbol: "🧙‍♂️".to_string() },
        ],
    })
}

#[tauri::command]
pub async fn check_container_status() -> Result<bool, String> {
    let output = Command::new("docker")
        .args(["ps", "--filter", "name=udesk", "--format", "{{.Names}}"])
        .output()
        .map_err(|e| format!("Failed to execute docker command: {}", e))?;

    if !output.status.success() {
        return Ok(false);
    }

    let containers = String::from_utf8(output.stdout)
        .map_err(|e| format!("Failed to parse docker output: {}", e))?;
    
    Ok(!containers.trim().is_empty())
}

#[tauri::command]
pub async fn check_docker_status() -> Result<bool, String> {
    let output = Command::new("docker")
        .args(["version", "--format", "json"])
        .output()
        .map_err(|e| format!("Failed to check Docker: {}", e))?;
    
    Ok(output.status.success())
}

#[tauri::command]
pub async fn start_udesk_container(
    config: ContainerConfig,
    state: State<'_, ContainerManager>,
) -> Result<String, String> {
    let uuid_str = uuid::Uuid::new_v4().to_string();
    let container_name = format!("udesk-{}", &uuid_str[..8]);
    
    // Build Docker command
    let mut cmd = Command::new("docker");
    cmd.args([
        "run", "-d",
        "--name", &container_name,
        "-v", &format!("{}:/workspace", config.workspace_path),
        "-v", "/tmp/.X11-unix:/tmp/.X11-unix",
        "-p", "2222:22",
        "-p", "8080:8080",
        "-e", &format!("UDESK_THEME={}", config.theme),
        "-e", &format!("UDESK_ROLE={}", config.role),
        "-e", "DISPLAY=:0",
        "--workdir", "/workspace",
    ]);
    
    // Add extension mounts
    for extension in &config.extensions {
        cmd.args(["-v", &format!("./extensions/{}:/opt/udesk/extensions/{}", extension, extension)]);
    }
    
    cmd.arg(&config.image);
    cmd.arg("/usr/local/bin/udos");
    
    let output = cmd
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .output()
        .map_err(|e| format!("Failed to start container: {}", e))?;
    
    if !output.status.success() {
        let error = String::from_utf8_lossy(&output.stderr);
        return Err(format!("Container start failed: {}", error));
    }
    
    let container_id = String::from_utf8_lossy(&output.stdout).trim().to_string();
    
    // Store container info
    let status = ContainerStatus {
        id: container_id.clone(),
        name: container_name,
        status: "running".to_string(),
        created: chrono::Utc::now().to_rfc3339(),
        ports: vec!["2222:22".to_string(), "8080:8080".to_string()],
    };
    
    state.containers.lock().await.insert(container_id.clone(), status);
    *state.workspace_path.lock().await = config.workspace_path;
    
    Ok(container_id)
}

#[tauri::command]
pub async fn stop_udesk_container(
    container_id: String,
    state: State<'_, ContainerManager>,
) -> Result<(), String> {
    let output = Command::new("docker")
        .args(["stop", &container_id])
        .output()
        .map_err(|e| format!("Failed to stop container: {}", e))?;
    
    if !output.status.success() {
        let error = String::from_utf8_lossy(&output.stderr);
        return Err(format!("Container stop failed: {}", error));
    }
    
    // Remove from state
    state.containers.lock().await.remove(&container_id);
    
    Ok(())
}

#[tauri::command]
pub async fn execute_ucode_command(
    _container_id: String,
    command: String,
) -> Result<String, String> {
    // Parse uCODE command: [COMMAND|OPTION*PARAMETER]
    let cmd_regex = regex::Regex::new(r"^\[([A-Z]+)(?:\|([A-Z]+)(?:\*(.+))?)?\]$")
        .map_err(|e| format!("Regex error: {}", e))?;
    
    let captures = cmd_regex.captures(&command)
        .ok_or_else(|| format!("Invalid uCODE syntax: {}", command))?;
    
    let main_cmd = captures.get(1).map(|m| m.as_str()).unwrap_or("");
    let option = captures.get(2).map(|m| m.as_str());
    let parameter = captures.get(3).map(|m| m.as_str());
    
    // Route to appropriate handler
    match main_cmd {
        // System commands (TinyCore integration)
        "BACKUP" => udos_backup().await,
        "RESTORE" => udos_restore().await,
        "DESTROY" => udos_destroy().await,
        "REBOOT" => udos_reboot().await,
        "REPAIR" => udos_repair().await,
        "UNDO" => udos_undo().await,
        "REDO" => udos_redo().await,
        
        // Information commands
        "STATUS" => get_system_status().await,
        "INFO" => get_system_info().await,
        "HELP" => get_help_text(option).await,
        
        // Container commands
        "CONTAINER" => handle_container_command(option, parameter).await,
        
        // Extension commands
        "EXTENSION" => handle_extension_command(option, parameter).await,
        
        // Theme commands
        "THEME" => handle_theme_command(option, parameter).await,
        
        _ => Err(format!("Unknown uCODE command: {}", main_cmd))
    }
}

async fn get_system_status() -> Result<String, String> {
    let mut status = Vec::new();
    
    // Check Docker
    let docker_status = check_docker_status().await.unwrap_or(false);
    status.push(format!("Docker: {}", if docker_status { "Available" } else { "Not Available" }));
    
    // Check TinyCore
    let tinycore_status = std::path::Path::new("/opt/bootlocal.sh").exists();
    status.push(format!("TinyCore: {}", if tinycore_status { "Native" } else { "Containerized" }));
    
    // Check extensions
    let extensions = list_available_extensions().await.unwrap_or_default();
    status.push(format!("Extensions: {} loaded", extensions.len()));
    
    Ok(format!("uDESK v1.0.7 System Status:\n{}", status.join("\n")))
}

async fn get_system_info() -> Result<String, String> {
    let info = get_udesk_info().await.map_err(|e| e.to_string())?;
    Ok(format!(
        "{} v{}\nArchitecture: {}\nThemes: {}\nRoles: {}",
        info.name,
        info.version,
        info.architecture,
        info.themes.join(", "),
        info.roles.len()
    ))
}

async fn get_help_text(command: Option<&str>) -> Result<String, String> {
    match command {
        Some("BACKUP") => Ok("BACKUP - Create system backup\nUsage: [BACKUP] or [BACKUP|FULL]".to_string()),
        Some("RESTORE") => Ok("RESTORE - Restore from backup\nUsage: [RESTORE] or [RESTORE|SELECT*PATH]".to_string()),
        Some("THEME") => Ok("THEME - Manage themes\nUsage: [THEME|SET*NAME] where NAME is: POLAROID, C64, MACINTOSH, MODE7".to_string()),
        _ => Ok("uCODE v1.0.7 Commands:\n[BACKUP] [RESTORE] [REPAIR] [REBOOT]\n[STATUS] [INFO] [HELP]\n[THEME|SET*NAME] [CONTAINER|START]\nFor detailed help: [HELP|COMMAND*NAME]".to_string())
    }
}

async fn handle_container_command(option: Option<&str>, _parameter: Option<&str>) -> Result<String, String> {
    match option {
        Some("START") => {
            // For now, return a simple message indicating container would start
            Ok("Container start requested - would initialize TinyCore environment".to_string())
        }
        Some("STATUS") => check_container_status().await.map(|running| {
            format!("Container status: {}", if running { "Running" } else { "Stopped" })
        }),
        _ => Err("Invalid container command. Use: [CONTAINER|START] or [CONTAINER|STATUS]".to_string())
    }
}

async fn handle_extension_command(option: Option<&str>, parameter: Option<&str>) -> Result<String, String> {
    match option {
        Some("LIST") => {
            let extensions = list_available_extensions().await?;
            Ok(format!("Available extensions:\n{}", 
                extensions.iter().map(|e| format!("- {}", e.name)).collect::<Vec<_>>().join("\n")))
        }
        Some("INSTALL") => {
            if let Some(name) = parameter {
                Ok(format!("Installing extension: {}", name))
            } else {
                Err("Extension name required. Use: [EXTENSION|INSTALL*NAME]".to_string())
            }
        }
        _ => Err("Invalid extension command. Use: [EXTENSION|LIST] or [EXTENSION|INSTALL*NAME]".to_string())
    }
}

async fn handle_theme_command(option: Option<&str>, parameter: Option<&str>) -> Result<String, String> {
    match option {
        Some("SET") => {
            if let Some(theme) = parameter {
                match theme.to_uppercase().as_str() {
                    "POLAROID" | "C64" | "MACINTOSH" | "MODE7" => {
                        Ok(format!("Theme set to: {}", theme.to_uppercase()))
                    }
                    _ => Err("Invalid theme. Available: POLAROID, C64, MACINTOSH, MODE7".to_string())
                }
            } else {
                Err("Theme name required. Use: [THEME|SET*NAME]".to_string())
            }
        }
        Some("LIST") => Ok("Available themes: POLAROID (default), C64, MACINTOSH, MODE7".to_string()),
        _ => Err("Invalid theme command. Use: [THEME|SET*NAME] or [THEME|LIST]".to_string())
    }
}

#[tauri::command]
pub async fn get_container_status(
    container_id: String,
) -> Result<ContainerStatus, String> {
    let output = Command::new("docker")
        .args([
            "inspect", &container_id,
            "--format", "{{.State.Status}}"
        ])
        .output()
        .map_err(|e| format!("Failed to get container status: {}", e))?;
    
    let status = String::from_utf8_lossy(&output.stdout).trim().to_string();
    
    Ok(ContainerStatus {
        id: container_id,
        name: "udesk-container".to_string(),
        status,
        created: chrono::Utc::now().to_rfc3339(),
        ports: vec!["2222:22".to_string(), "8080:8080".to_string()],
    })
}

#[tauri::command]
pub async fn list_available_extensions() -> Result<Vec<ExtensionInfo>, String> {
    // This would scan the extensions directory for available .tcz files
    let extensions = vec![
        ExtensionInfo {
            name: "udesk-base".to_string(),
            version: "1.7.0".to_string(),
            description: "Core uDESK framework".to_string(),
            loaded: false,
        },
        ExtensionInfo {
            name: "ucode-engine".to_string(),
            version: "1.7.0".to_string(),
            description: "uCODE command processor".to_string(),
            loaded: false,
        },
        ExtensionInfo {
            name: "udos-shell".to_string(),
            version: "1.7.0".to_string(),
            description: "Enhanced terminal shell".to_string(),
            loaded: false,
        },
    ];
    
    Ok(extensions)
}

#[tauri::command]
pub async fn get_workspace_files(
    path: String,
    state: State<'_, ContainerManager>,
) -> Result<Vec<String>, String> {
    let workspace_path = state.workspace_path.lock().await;
    let full_path = if path.is_empty() {
        workspace_path.clone()
    } else {
        format!("{}/{}", *workspace_path, path)
    };
    
    let output = Command::new("ls")
        .args(["-la", &full_path])
        .output()
        .map_err(|e| format!("Failed to list files: {}", e))?;
    
    if output.status.success() {
        let files: Vec<String> = String::from_utf8_lossy(&output.stdout)
            .lines()
            .map(|line| line.to_string())
            .collect();
        Ok(files)
    } else {
        Err("Failed to list workspace files".to_string())
    }
}

#[tauri::command]
pub async fn build_udesk_iso(
    extensions: Vec<String>,
    output_path: String,
) -> Result<String, String> {
    // This would trigger the ISO build process
    let mut cmd = Command::new("docker");
    cmd.args([
        "run", "--rm",
        "-v", &format!("{}:/output", output_path),
        "-v", "./extensions:/extensions",
        "udesk/iso-builder:latest",
        "build-iso"
    ]);
    
    for ext in extensions {
        cmd.args(["--extension", &ext]);
    }
    
    let output = cmd
        .output()
        .map_err(|e| format!("Failed to build ISO: {}", e))?;
    
    if output.status.success() {
        Ok(format!("{}/udesk-v1.0.7.iso", output_path))
    } else {
        let error = String::from_utf8_lossy(&output.stderr);
        Err(format!("ISO build failed: {}", error))
    }
}

// ========================================
// uDOS System Commands (TinyCore Integration)
// ========================================

#[tauri::command]
pub async fn udos_backup() -> Result<String, String> {
    // Use TinyCore's filetool.sh for backup
    let output = Command::new("filetool.sh")
        .args(["-b"])
        .output()
        .map_err(|e| format!("Failed to execute backup: {}", e))?;

    if output.status.success() {
        Ok("System backup completed successfully".to_string())
    } else {
        let error = String::from_utf8_lossy(&output.stderr);
        Err(format!("Backup failed: {}", error))
    }
}

#[tauri::command]
pub async fn udos_restore() -> Result<String, String> {
    // Use TinyCore's filetool.sh for restore
    let output = Command::new("filetool.sh")
        .args(["-r"])
        .output()
        .map_err(|e| format!("Failed to execute restore: {}", e))?;

    if output.status.success() {
        Ok("System restore completed successfully".to_string())
    } else {
        let error = String::from_utf8_lossy(&output.stderr);
        Err(format!("Restore failed: {}", error))
    }
}

#[tauri::command]
pub async fn udos_destroy() -> Result<String, String> {
    // Safely remove user data and reset to clean state
    let commands = vec![
        "rm -rf /home/tc/.local",
        "rm -rf /tmp/tce",
        "rm -f /opt/.filetool.lst",
        "rm -f /opt/.xfiletool.lst",
    ];

    for cmd in commands {
        let output = Command::new("sh")
            .args(["-c", cmd])
            .output()
            .map_err(|e| format!("Failed to execute destroy command: {}", e))?;

        if !output.status.success() {
            let error = String::from_utf8_lossy(&output.stderr);
            return Err(format!("Destroy failed at step '{}': {}", cmd, error));
        }
    }

    Ok("System destroyed and reset to clean state".to_string())
}

#[tauri::command]
pub async fn udos_reboot() -> Result<String, String> {
    // Use TinyCore's reboot command
    let output = Command::new("sudo")
        .args(["reboot"])
        .output()
        .map_err(|e| format!("Failed to execute reboot: {}", e))?;

    if output.status.success() {
        Ok("System reboot initiated".to_string())
    } else {
        let error = String::from_utf8_lossy(&output.stderr);
        Err(format!("Reboot failed: {}", error))
    }
}

#[tauri::command]
pub async fn udos_repair() -> Result<String, String> {
    // TinyCore repair sequence - check filesystem and rebuild extensions
    let commands = vec![
        "fsck -y /dev/sda1",  // Check filesystem
        "tce-load -i base",   // Reload base extensions
        "depmod -a",          // Rebuild module dependencies
        "ldconfig",           // Rebuild library cache
    ];

    let mut results = Vec::new();
    for cmd in commands {
        let output = Command::new("sudo")
            .args(["sh", "-c", cmd])
            .output()
            .map_err(|e| format!("Failed to execute repair command: {}", e))?;

        let status = if output.status.success() { "OK" } else { "FAIL" };
        results.push(format!("{}: {}", cmd, status));
    }

    Ok(format!("Repair sequence completed:\n{}", results.join("\n")))
}

#[tauri::command]
pub async fn udos_undo() -> Result<String, String> {
    // Undo last operation using TinyCore's backup system
    let backup_path = "/tmp/.last_backup";
    
    if std::path::Path::new(backup_path).exists() {
        let output = Command::new("cp")
            .args(["-r", backup_path, "/"])
            .output()
            .map_err(|e| format!("Failed to execute undo: {}", e))?;

        if output.status.success() {
            Ok("Last operation undone successfully".to_string())
        } else {
            let error = String::from_utf8_lossy(&output.stderr);
            Err(format!("Undo failed: {}", error))
        }
    } else {
        Err("No backup available for undo operation".to_string())
    }
}

#[tauri::command]
pub async fn udos_redo() -> Result<String, String> {
    // Redo last undone operation
    let redo_path = "/tmp/.last_redo";
    
    if std::path::Path::new(redo_path).exists() {
        let output = Command::new("cp")
            .args(["-r", redo_path, "/"])
            .output()
            .map_err(|e| format!("Failed to execute redo: {}", e))?;

        if output.status.success() {
            Ok("Last undone operation redone successfully".to_string())
        } else {
            let error = String::from_utf8_lossy(&output.stderr);
            Err(format!("Redo failed: {}", error))
        }
    } else {
        Err("No operation available for redo".to_string())
    }
}
