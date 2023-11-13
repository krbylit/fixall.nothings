import random
import time
from rich.console import Console
from rich.progress import Progress, BarColumn, TextColumn
from rich.table import Table
from rich.panel import Panel

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
                else:
                    console.log(f"[red]Error in {task_name}: Faulty operation at step {step}.")
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
        console.print(Panel(f"[bold green]Completed: {task}[/bold green]\n", expand=False))

    console.print("[bold magenta]All tasks completed! System is now optimized![/bold magenta]", justify="center")

if __name__ == "__main__":
    main()

