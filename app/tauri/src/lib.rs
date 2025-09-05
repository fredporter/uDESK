mod container;
mod setup;

use container::{
    ContainerManager, 
    check_docker_status,
    check_container_status,
    start_udesk_container,
    stop_udesk_container,
    execute_ucode_command,
    get_container_status,
    list_available_extensions,
    get_workspace_files,
    build_udesk_iso,
    get_udesk_info,
    udos_backup,
    udos_restore,
    udos_destroy,
    udos_reboot,
    udos_repair,
    udos_undo,
    udos_redo,
};

use setup::{
    get_system_info,
    needs_first_time_setup,
    install_component,
    open_documentation,
};

// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! Welcome to uDESK v1.0.7 - Universal Development Environment!", name)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    let container_manager = ContainerManager::new();
    
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .plugin(tauri_plugin_fs::init())
        .plugin(tauri_plugin_process::init())
        .plugin(tauri_plugin_shell::init())
        .manage(container_manager)
        .invoke_handler(tauri::generate_handler![
            greet,
            get_udesk_info,
            check_docker_status,
            check_container_status,
            start_udesk_container,
            stop_udesk_container,
            execute_ucode_command,
            get_container_status,
            list_available_extensions,
            get_workspace_files,
            build_udesk_iso,
            udos_backup,
            udos_restore,
            udos_destroy,
            udos_reboot,
            udos_repair,
            udos_undo,
            udos_redo,
            get_system_info,
            needs_first_time_setup,
            install_component,
            open_documentation
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
