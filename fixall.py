import random
import time
from rich.console import Console
from rich.progress import Progress, BarColumn, TextColumn
from rich.table import Table
from rich.panel import Panel

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

def simulate_task(console, task_name, max_duration=15):
    """Simulates a task with a progress bar and random logs."""
    duration = random.uniform(2, max_duration)
    steps = int(duration * 10)
    with Progress(
        "[progress.description]{task.description}",
        BarColumn(bar_width=None),
        "[progress.percentage]{task.percentage:>3.0f}%",
        TextColumn("[bold green]{task.fields[status]}"),
        console=console
    ) as progress:
        task = progress.add_task(task_name, total=100, status="Running")
        for step in range(steps):
            progress.update(task, advance=10, status="Running")
            time.sleep(duration / steps)
            if random.random() < 0.3:  # 30% chance to log a message
                if random.random() < 0.5:
                    console.log(f"[yellow]Warning in {task_name}: Unexpected event detected.")
                    time.sleep(1)
                    console.log(f"[yellow]Resolution: Adjusted parameters, continuing process.")
                else:
                    console.log(f"[red]Error in {task_name}: Faulty operation at step {step}.")
                    time.sleep(1)
                    console.log(f"[green]Resolution: Error resolved, operation back on track.")
        progress.update(task, status="Completed")

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

