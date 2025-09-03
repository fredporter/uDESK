#!/usr/bin/env node
// uDOS Workflow Engine - Clean, fast module
const fs = require('fs');
const path = require('path');
const os = require('os');

const UDOS_HOME = process.env.UDOS_HOME || path.join(os.homedir(), '.udos');
const WORKFLOW_DIR = path.join(UDOS_HOME, 'workflows');

// Ensure workflow directory exists
if (!fs.existsSync(WORKFLOW_DIR)) {
    fs.mkdirSync(WORKFLOW_DIR, { recursive: true });
}

const workflows = {
    list() {
        try {
            const files = fs.readdirSync(WORKFLOW_DIR).filter(f => f.endsWith('.json'));
            if (files.length === 0) {
                console.log('📝 No workflows found');
                console.log('Create one with: udos workflow create \'{"name":"My Workflow"}\'');
                return;
            }
            
            console.log('🔄 Available Workflows:');
            files.forEach(f => {
                try {
                    const wf = JSON.parse(fs.readFileSync(path.join(WORKFLOW_DIR, f)));
                    const id = f.replace('.json', '');
                    console.log(`  ${id}: ${wf.name || 'Unnamed'} ${wf.description ? '- ' + wf.description : ''}`);
                } catch (e) {
                    console.log(`  ${f}: (corrupted)`);
                }
            });
        } catch (e) {
            console.log('❌ Error listing workflows:', e.message);
        }
    },
    
    create(workflowStr) {
        if (!workflowStr) {
            console.log('Usage: udos workflow create \'{"name":"My Workflow","actions":[]}\'');
            console.log('');
            console.log('Example:');
            console.log('udos workflow create \'{"name":"Daily Backup","description":"Backup user data","actions":[{"type":"command","command":"udos data backup"}]}\'');
            return;
        }
        
        try {
            const wf = JSON.parse(workflowStr);
            if (!wf.name) {
                console.log('❌ Workflow must have a name');
                return;
            }
            
            const id = Date.now().toString();
            const file = path.join(WORKFLOW_DIR, `${id}.json`);
            
            // Add metadata
            wf.id = id;
            wf.created = new Date().toISOString();
            wf.actions = wf.actions || [];
            
            fs.writeFileSync(file, JSON.stringify(wf, null, 2));
            console.log(`✅ Workflow created: ${id}`);
            console.log(`📝 Name: ${wf.name}`);
            console.log(`🗂  File: workflows/${id}.json`);
        } catch (e) {
            console.log('❌ Error creating workflow:', e.message);
            console.log('💡 Ensure JSON is valid');
        }
    },
    
    run(id) {
        if (!id) {
            console.log('❌ Workflow ID required');
            console.log('💡 List workflows with: udos workflow list');
            return;
        }
        
        const file = path.join(WORKFLOW_DIR, `${id}.json`);
        if (!fs.existsSync(file)) {
            console.log(`❌ Workflow '${id}' not found`);
            return;
        }
        
        try {
            const wf = JSON.parse(fs.readFileSync(file));
            console.log(`🚀 Executing: ${wf.name}`);
            
            if (!wf.actions || wf.actions.length === 0) {
                console.log('⚠️  No actions defined');
                return;
            }
            
            wf.actions.forEach((action, i) => {
                console.log(`📋 Step ${i + 1}: ${action.type || 'unknown'}`);
                
                switch (action.type) {
                    case 'command':
                        if (action.command) {
                            console.log(`   Running: ${action.command}`);
                            require('child_process').execSync(action.command, { stdio: 'inherit' });
                        }
                        break;
                    case 'notification':
                        console.log(`   📢 ${action.title || 'Notification'}: ${action.message || 'No message'}`);
                        break;
                    case 'delay':
                        const ms = action.duration || 1000;
                        console.log(`   ⏱  Waiting ${ms}ms...`);
                        require('child_process').execSync(`sleep ${ms / 1000}`, { stdio: 'inherit' });
                        break;
                    default:
                        console.log(`   ⚠️  Unknown action type: ${action.type}`);
                }
            });
            
            console.log('✅ Workflow completed');
        } catch (e) {
            console.log('❌ Error executing workflow:', e.message);
        }
    },
    
    delete(id) {
        if (!id) {
            console.log('❌ Workflow ID required');
            return;
        }
        
        const file = path.join(WORKFLOW_DIR, `${id}.json`);
        if (!fs.existsSync(file)) {
            console.log(`❌ Workflow '${id}' not found`);
            return;
        }
        
        try {
            const wf = JSON.parse(fs.readFileSync(file));
            fs.unlinkSync(file);
            console.log(`✅ Deleted workflow: ${wf.name} (${id})`);
        } catch (e) {
            console.log('❌ Error deleting workflow:', e.message);
        }
    },
    
    show(id) {
        if (!id) {
            console.log('❌ Workflow ID required');
            return;
        }
        
        const file = path.join(WORKFLOW_DIR, `${id}.json`);
        if (!fs.existsSync(file)) {
            console.log(`❌ Workflow '${id}' not found`);
            return;
        }
        
        try {
            const wf = JSON.parse(fs.readFileSync(file));
            console.log(`📋 Workflow: ${wf.name}`);
            console.log(`🆔 ID: ${wf.id}`);
            console.log(`📝 Description: ${wf.description || 'None'}`);
            console.log(`📅 Created: ${wf.created || 'Unknown'}`);
            console.log(`🔧 Actions: ${wf.actions ? wf.actions.length : 0}`);
            
            if (wf.actions && wf.actions.length > 0) {
                console.log('\n🔄 Actions:');
                wf.actions.forEach((action, i) => {
                    console.log(`  ${i + 1}. ${action.type || 'unknown'}${action.command ? ': ' + action.command : ''}${action.message ? ': ' + action.message : ''}`);
                });
            }
        } catch (e) {
            console.log('❌ Error reading workflow:', e.message);
        }
    }
};

// Command line interface
const [,, command, ...args] = process.argv;

if (command === '--help' || command === 'help') {
    console.log('🔄 uDOS Workflow Engine');
    console.log('');
    console.log('Commands:');
    console.log('  list                     List all workflows');
    console.log('  create <json>           Create new workflow');
    console.log('  run <id>                Execute workflow');
    console.log('  show <id>               Show workflow details');
    console.log('  delete <id>             Delete workflow');
    console.log('');
    console.log('Examples:');
    console.log('  udos workflow list');
    console.log('  udos workflow create \'{"name":"Test","actions":[{"type":"command","command":"echo hello"}]}\'');
    console.log('  udos workflow run 1693789234567');
} else if (workflows[command]) {
    workflows[command](...args);
} else {
    console.log('❌ Unknown command:', command);
    console.log('💡 Use: udos workflow help');
}
