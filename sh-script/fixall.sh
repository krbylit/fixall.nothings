#!/bin/bash

# Function to clean up the virtual environment
cleanup() {
	echo "Cleaning up..."
	deactivate
	rm -rf "$TEMP_DIR"
	echo "Cleanup completed. Exiting."
}

# Function to handle interruption (Ctrl+C)
handle_interrupt() {
	echo "Interrupt received. Initiating cleanup."
	cleanup
	exit 1
}

# Check for Python 3
if ! command -v python3 &>/dev/null; then
	echo "Python 3 could not be found. Please install Python 3."
	exit 1
fi

# Create a temporary directory for the virtual environment
TEMP_DIR=$(mktemp -d)
echo "Creating a virtual environment for fixall.nothings in $TEMP_DIR"

# Set trap for interrupt signal
trap handle_interrupt SIGINT

# Create and activate the virtual environment
python3 -m venv "$TEMP_DIR/venv"
source "$TEMP_DIR/venv/bin/activate"

# Install required packages
echo "Installing dependencies for fixall.nothings..."
pip install rich

# Run the embedded Python script (fixall.nothings)
echo "Running fixall.nothings..."
python3 <<EOF
import random
import time
from rich.console import Console
from rich.progress import Progress, BarColumn, TextColumn
from rich.table import Table
from rich.panel import Panel

# Define specific errors and warnings for each task
task_specific_messages = {
    "Initializing fixall.nothings": {
        "errors": [
            "Failed to initialize module", 
            "Configuration mismatch detected", 
            "Module not found",
            "Initialization script error", 
            "Missing essential files"
        ],
        "warnings": [
            "Initialization delay", 
            "Skipping optional configurations",
            "Deprecated module detected",
            "Update available for components",
            "Running in compatibility mode"
        ]
    },
    "Fixing printers": {
        "errors": [
            "Printer driver conflict", 
            "Network printer not found",
            "Incompatible printer firmware", 
            "Print spooler error", 
            "Unauthorized access attempt"
        ],
        "warnings": [
            "Low ink warning", 
            "Paper jam detected",
            "Printer offline",
            "Maintenance required",
            "High print queue"
        ]
    },
    "Resolving network issues": {
        "errors": [
            "Network timeout", 
            "Router configuration error",
            "DNS resolution failure", 
            "IP conflict detected", 
            "VPN connection failed"
        ],
        "warnings": [
            "Intermittent connectivity", 
            "Low signal strength",
            "Network congestion",
            "Limited bandwidth",
            "Unsecured Wi-Fi detected"
        ]
    },
    "Updating user permissions": {
        "errors": [
            "Permission write failure", 
            "User group not found",
            "Invalid user credentials", 
            "Database access denied", 
            "LDAP server unresponsive"
        ],
        "warnings": [
            "Incomplete user data", 
            "Redundant permission settings",
            "Password expiration approaching",
            "Account inactivity warning",
            "Excessive login attempts"
        ]
    },
    "Optimizing system performance": {
        "errors": [
            "Performance tuning failed", 
            "Resource allocation error",
            "Critical process terminated", 
            "Overclocking failed", 
            "Hardware compatibility issue"
        ],
        "warnings": [
            "Memory usage high", 
            "System optimization delayed",
            "Background services consuming resources",
            "Possible malware detected",
            "System restore point not set"
        ]
    },
    "Finalizing fixes": {
        "errors": [
            "Finalization script missing", 
            "Insufficient privileges for finalization",
            "System lockdown in progress", 
            "Critical error on shutdown", 
            "License verification failed"
        ],
        "warnings": [
            "Extended finalization time", 
            "Skipping non-critical steps",
            "Temporary files not cleaned up",
            "Registry modifications pending",
            "Pending system reboot"
        ]
    }
    # Add other tasks as necessary...
}

def simulate_resolution_progress(progress, task_name, sub_task_name, message, duration=2):
    """Simulates a sub-task resolution with a progress bar."""
    progress.console.log(f"[yellow]{message}")
    sub_task = progress.add_task(sub_task_name, total=10, start=False, status="Resolving")
    for _ in range(10):
        progress.update(sub_task, advance=1, status="Resolving")
        time.sleep(duration / 10)
    progress.console.log(f"[bold green]Resolution for {task_name}: {sub_task_name} completed.")
    return 10  # Return the progress made in this sub-task

def simulate_task(console, task_name, max_duration=15):
    """Simulates a task with a progress bar and random logs."""
    duration = random.uniform(2, max_duration)
    steps = int(duration * 10)
    main_task_increment = steps // 2  # Reserve half progress for sub-tasks

    with Progress(
        "[progress.description]{task.description}",
        BarColumn(bar_width=None),
        "[progress.percentage]{task.percentage:>3.0f}%",
        TextColumn("[bold green]{task.fields[status]}"),
        console=console
    ) as progress:
        main_task = progress.add_task(task_name, total=100, status="Running")

        for step in range(main_task_increment):
            progress.update(main_task, advance=1, status="Running")
            time.sleep(duration / steps)

            if random.random() < 0.3:
                error_warning_choice = random.choice(["error", "warning"])
                messages = task_specific_messages[task_name][error_warning_choice + "s"]
                message = random.choice(messages)
                resolution_message = "Adjusting parameters" if error_warning_choice == "warning" else "Error resolution"
                
                subtask_progress = simulate_resolution_progress(progress, task_name, resolution_message, message)
                progress.update(main_task, completed=min(100, progress.tasks[main_task].completed + subtask_progress // 2), status="Running")

        # Ensure the task reaches 100% completion
        progress.update(main_task, completed=100, status="Completed")

def simulate_process_monitoring(console, num_processes=5):
    """Simulates a process monitoring display similar to htop."""
    table = Table(title="Process Monitoring", style="bold blue")
    table.add_column("PID", style="dim", width=6)
    table.add_column("User")
    table.add_column("CPU%", justify="right")
    table.add_column("MEM%", justify="right")
    table.add_column("Command")

    for _ in range(num_processes):
        pid = str(random.randint(1000, 50000))
        user = random.choice(["root", "user1", "user2", "daemon"])
        cpu_usage = f"{random.uniform(0.1, 30.0):.1f}"
        mem_usage = f"{random.uniform(0.1, 50.0):.1f}"
        command = random.choice(["python", "bash", "htop", "curl", "ssh"])
        table.add_row(pid, user, cpu_usage, mem_usage, command)

    console.print(table)

def display_system_info(console):
    """Displays a mock system information table."""
    table = Table(title="System Information")

    table.add_column("Component", style="dim")
    table.add_column("Status")
    table.add_column("Details")

    components = ["CPU", "Memory", "Disk", "Network"]
    statuses = ["Operational", "Optimized", "Stable", "Active"]
    details = ["No issues", "Performance enhanced", "No fragmentation", "No packet loss"]

    for component, status, detail in zip(components, statuses, details):
        table.add_row(component, status, detail)

    console.print(table)

def main():
    console = Console()
    display_system_info(console)

    tasks = [
        "Initializing fixall.nothings",
        "Fixing printers",
        "Resolving network issues",
        "Updating user permissions",
        "Optimizing system performance",
        "Finalizing fixes"
    ]

    for task in tasks:
        console.print(Panel(f"[bold yellow]Starting: {task}[/bold yellow]", expand=False))
        simulate_task(console, task)
        simulate_process_monitoring(console)
        console.print(Panel(f"[bold green]Completed: {task}[/bold green]\n", expand=False))

    console.print("[bold magenta]All tasks completed! System is now optimized![/bold magenta]", justify="center")

if __name__ == "__main__":
    main()

EOF

# Call cleanup function after script execution
cleanup
