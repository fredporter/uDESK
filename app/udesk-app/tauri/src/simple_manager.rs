use std::process::Command;
use std::collections::HashMap;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SimpleTinyCoreConfig {
    pub name: String,
    pub workspace_path: String,
    pub theme: String,
    pub role: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SimpleProcessStatus {
    pub pid: u32,
    pub name: String,
    pub status: String,
    pub command: String,
}

// Lightweight TinyCore process manager
pub struct SimpleTinyCoreManager;

impl SimpleTinyCoreManager {
    pub fn new() -> Self {
        SimpleTinyCoreManager
    }
    
    // Start uDOS process directly (no containers)
    pub fn start_udos_process(config: SimpleTinyCoreConfig) -> Result<String, String> {
        let output = Command::new("/usr/local/bin/udos")
            .arg("--background")
            .arg("--workspace")
            .arg(&config.workspace_path)
            .arg("--theme")
            .arg(&config.theme)
            .arg("--role")
            .arg(&config.role)
            .output()
            .map_err(|e| format!("Failed to start uDOS: {}", e))?;
            
        if output.status.success() {
            let stdout = String::from_utf8_lossy(&output.stdout);
            Ok(format!("uDOS started successfully: {}", stdout.trim()))
        } else {
            let stderr = String::from_utf8_lossy(&output.stderr);
            Err(format!("Failed to start uDOS: {}", stderr))
        }
    }
    
    // Check if uDOS is running
    pub fn check_udos_status() -> Result<bool, String> {
        let output = Command::new("pgrep")
            .arg("udos")
            .output()
            .map_err(|e| format!("Failed to check process: {}", e))?;
            
        Ok(output.status.success() && !output.stdout.is_empty())
    }
    
    // Stop uDOS process
    pub fn stop_udos_process() -> Result<String, String> {
        let output = Command::new("pkill")
            .arg("udos")
            .output()
            .map_err(|e| format!("Failed to stop process: {}", e))?;
            
        if output.status.success() {
            Ok("uDOS stopped successfully".to_string())
        } else {
            Err("Failed to stop uDOS".to_string())
        }
    }
    
    // List running processes
    pub fn list_processes() -> Result<Vec<SimpleProcessStatus>, String> {
        let output = Command::new("ps")
            .arg("aux")
            .output()
            .map_err(|e| format!("Failed to list processes: {}", e))?;
            
        let stdout = String::from_utf8_lossy(&output.stdout);
        let mut processes = Vec::new();
        
        for line in stdout.lines().skip(1) { // Skip header
            let parts: Vec<&str> = line.split_whitespace().collect();
            if parts.len() > 10 && (parts[10].contains("udos") || parts[10].contains("ucode")) {
                processes.push(SimpleProcessStatus {
                    pid: parts[1].parse().unwrap_or(0),
                    name: parts[10].to_string(),
                    status: "running".to_string(),
                    command: parts[10..].join(" "),
                });
            }
        }
        
        Ok(processes)
    }
}

// Simplified Tauri commands for lightweight operation
#[tauri::command]
pub async fn start_simple_udos(
    workspace_path: String,
    theme: String,
    role: String,
) -> Result<String, String> {
    let config = SimpleTinyCoreConfig {
        name: "udesk-simple".to_string(),
        workspace_path,
        theme,
        role,
    };
    
    SimpleTinyCoreManager::start_udos_process(config)
}

#[tauri::command]
pub async fn check_simple_status() -> Result<bool, String> {
    SimpleTinyCoreManager::check_udos_status()
}

#[tauri::command]
pub async fn stop_simple_udos() -> Result<String, String> {
    SimpleTinyCoreManager::stop_udos_process()
}

#[tauri::command]
pub async fn list_simple_processes() -> Result<Vec<SimpleProcessStatus>, String> {
    SimpleTinyCoreManager::list_processes()
}

// Simple uCODE command processor (lightweight version)
#[tauri::command]
pub async fn execute_simple_ucode(command: String) -> Result<String, String> {
    // Parse basic uCODE commands without complex regex
    let trimmed = command.trim();
    
    if !trimmed.starts_with('[') || !trimmed.ends_with(']') {
        return Err("Invalid uCODE format. Use [COMMAND|OPTION*PARAMETER]".to_string());
    }
    
    let inner = &trimmed[1..trimmed.len()-1];
    let parts: Vec<&str> = inner.split('|').collect();
    
    let main_cmd = parts[0];
    let option = parts.get(1).copied();
    let parameter = option.and_then(|opt| {
        if opt.contains('*') {
            opt.split('*').nth(1)
        } else {
            None
        }
    });
    
    match main_cmd {
        "INFO" => handle_info_command(option).await,
        "STATUS" => handle_status_command().await,
        "BACKUP" => handle_backup_command().await,
        "RESTORE" => handle_restore_command().await,
        "HELP" => handle_help_command(option).await,
        "PROCESS" => handle_process_command(option).await,
        _ => Err(format!("Unknown command: {}", main_cmd))
    }
}

async fn handle_info_command(option: Option<&str>) -> Result<String, String> {
    match option {
        Some("SYSTEM") => {
            Ok("uDESK v1.0.7 - TinyCore Linux\nSimple Process Management\nNo Container Overhead".to_string())
        }
        Some("PROCESSES") => {
            let processes = SimpleTinyCoreManager::list_processes()?;
            Ok(format!("Running processes: {}", processes.len()))
        }
        _ => Ok("uDESK v1.0.7 Information System".to_string())
    }
}

async fn handle_status_command() -> Result<String, String> {
    let udos_running = SimpleTinyCoreManager::check_udos_status()?;
    let processes = SimpleTinyCoreManager::list_processes()?;
    
    Ok(format!(
        "uDOS Status: {}\nProcesses: {} running",
        if udos_running { "Running" } else { "Stopped" },
        processes.len()
    ))
}

async fn handle_backup_command() -> Result<String, String> {
    // Use TinyCore's filetool.sh directly
    let output = Command::new("filetool.sh")
        .arg("-b")
        .output()
        .map_err(|e| format!("Backup failed: {}", e))?;
        
    if output.status.success() {
        Ok("System backup completed using filetool.sh".to_string())
    } else {
        Err("Backup failed".to_string())
    }
}

async fn handle_restore_command() -> Result<String, String> {
    let output = Command::new("filetool.sh")
        .arg("-r")
        .output()
        .map_err(|e| format!("Restore failed: {}", e))?;
        
    if output.status.success() {
        Ok("System restore completed using filetool.sh".to_string())
    } else {
        Err("Restore failed".to_string())
    }
}

async fn handle_help_command(option: Option<&str>) -> Result<String, String> {
    match option {
        Some("COMMANDS") => {
            Ok("Available commands:\n[INFO|SYSTEM] - System info\n[STATUS] - Process status\n[BACKUP] - System backup\n[RESTORE] - System restore".to_string())
        }
        _ => {
            Ok("uCODE Help System\nUse [HELP|COMMANDS] for command list".to_string())
        }
    }
}

async fn handle_process_command(option: Option<&str>) -> Result<String, String> {
    match option {
        Some("START") => start_simple_udos("/tmp/workspace".to_string(), "default".to_string(), "user".to_string()).await,
        Some("STOP") => stop_simple_udos().await,
        Some("LIST") => {
            let processes = list_simple_processes().await?;
            Ok(format!("Running processes:\n{:#?}", processes))
        }
        _ => Err("Process command requires option: START, STOP, or LIST".to_string())
    }
}
