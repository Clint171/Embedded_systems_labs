"""
Lab 6: Temperature Data Acquisition and Logging System
Python-based simulation using matplotlib for visualization
Simulates LabVIEW VI functionality
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from datetime import datetime
import csv
import time
import os

class TemperatureDAQSimulator:
    """
    Simulates a temperature sensor DAQ system with:
    - Real-time data acquisition
    - Threshold-based control
    - Data logging with integrity features
    - Live visualization
    """
    
    def __init__(self, base_temp=27, threshold=30, sampling_rate=1.0):
        """
        Initialize the DAQ simulator
        
        Parameters:
        - base_temp: Base temperature in Celsius (float)
        - threshold: Alert threshold in Celsius (float)
        - sampling_rate: Samples per second (float)
        """
        self.base_temp = base_temp
        self.threshold = threshold
        self.sampling_rate = sampling_rate
        self.sampling_interval = 1.0 / sampling_rate
        
        # Data storage
        self.timestamps = []
        self.temperatures = []
        self.time_elapsed = []
        self.sample_numbers = []
        self.valid_flags = []
        self.checksums = []
        self.alerts = []
        
        # Session info
        self.session_start = None
        self.sample_count = 0
        self.control_output = False
        self.is_running = False
        
    def simulate_temperature(self, time_val):
        """
        Simulate realistic temperature sensor readings
        Includes noise, drift, and occasional spikes
        """
        noise = np.random.normal(0, 0.25)
        drift = np.sin(time_val / 10) * 2
        spike = np.random.choice([0, np.random.uniform(-1.5, 1.5)], 
                                  p=[0.95, 0.05])
        return self.base_temp + noise + drift + spike
    
    def validate_reading(self, temp):
        """
        Validate temperature reading
        Returns True if valid, False otherwise
        """
        if np.isnan(temp):
            return False
        if temp < -50 or temp > 150:
            return False
        return True
    
    def generate_checksum(self, temp, timestamp):
        """
        Generate simple checksum for data integrity
        """
        data_str = f"{temp}{timestamp}"
        checksum = hash(data_str) & 0xFFFFFFFF
        return format(checksum, '08x')
    
    def check_threshold(self, temp):
        """
        Check if temperature exceeds threshold
        Trigger control output and generate alert
        """
        if temp > self.threshold:
            if not self.control_output:
                self.control_output = True
                alert_msg = f"ALERT: Temperature {temp:.2f}°C exceeded threshold {self.threshold}°C"
                self.alerts.append({
                    'timestamp': datetime.now().isoformat(),
                    'sample': self.sample_count,
                    'temperature': temp,
                    'message': alert_msg
                })
                print(alert_msg)
            return True
        else:
            self.control_output = False
            return False
    
    def acquire_sample(self):
        """
        Acquire a single data sample
        """
        timestamp = datetime.now()
        
        if self.session_start is None:
            self.session_start = timestamp
        
        elapsed = (timestamp - self.session_start).total_seconds()
        temp = self.simulate_temperature(elapsed)
        is_valid = self.validate_reading(temp)
        checksum = self.generate_checksum(temp, timestamp.isoformat())
        
        # Store data
        self.timestamps.append(timestamp.isoformat())
        self.temperatures.append(temp)
        self.time_elapsed.append(elapsed)
        self.sample_numbers.append(self.sample_count)
        self.valid_flags.append(is_valid)
        self.checksums.append(checksum)
        
        # Check threshold
        if is_valid:
            self.check_threshold(temp)
        
        self.sample_count += 1
        
        return temp, elapsed
    
    def export_to_csv(self, filename=None):
        """
        Export collected data to CSV file with metadata
        """
        if filename is None:
            timestamp_str = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"temperature_log_{timestamp_str}.csv"
        
        with open(filename, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            
            # Write header
            writer.writerow([
                'Sample_Number', 'Timestamp', 'Time_Elapsed_s', 
                'Temperature_C', 'Threshold_C', 'Valid', 'Checksum'
            ])
            
            # Write data
            for i in range(len(self.sample_numbers)):
                writer.writerow([
                    self.sample_numbers[i],
                    self.timestamps[i],
                    f"{self.time_elapsed[i]:.3f}",
                    f"{self.temperatures[i]:.2f}",
                    f"{self.threshold:.2f}",
                    self.valid_flags[i],
                    self.checksums[i]
                ])
            
            # Write metadata
            writer.writerow([])
            writer.writerow(['--- Metadata ---'])
            writer.writerow(['Session_Start', self.session_start.isoformat()])
            writer.writerow(['Total_Samples', self.sample_count])
            writer.writerow(['Sampling_Rate_Hz', self.sampling_rate])
            writer.writerow(['Base_Temperature_C', self.base_temp])
            writer.writerow(['Threshold_C', self.threshold])
            writer.writerow(['Export_Time', datetime.now().isoformat()])
            writer.writerow(['Total_Alerts', len(self.alerts)])
        
        print(f"\n✓ Data exported to: {filename}")
        print(f"  Total samples: {self.sample_count}")
        print(f"  Valid samples: {sum(self.valid_flags)}")
        print(f"  Data quality: {sum(self.valid_flags)/self.sample_count*100:.1f}%")
        
        return filename
    
    def run_acquisition(self, duration=60, show_plot=True):
        """
        Run data acquisition for specified duration
        
        Parameters:
        - duration: Acquisition duration in seconds
        - show_plot: Whether to show live plot
        """
        print("="*60)
        print("TEMPERATURE DATA ACQUISITION SYSTEM")
        print("="*60)
        print(f"Base Temperature: {self.base_temp}°C")
        print(f"Threshold: {self.threshold}°C")
        print(f"Sampling Rate: {self.sampling_rate} Hz")
        print(f"Duration: {duration} seconds")
        print("="*60)
        print("\nStarting acquisition...")
        
        self.is_running = True
        
        if show_plot:
            self._run_with_visualization(duration)
        else:
            self._run_without_visualization(duration)
        
        print("\n✓ Acquisition complete!")
        print(f"  Samples collected: {self.sample_count}")
        print(f"  Alerts triggered: {len(self.alerts)}")
    
    def _run_without_visualization(self, duration):
        """Run acquisition without live plotting"""
        start_time = time.time()
        
        while (time.time() - start_time) < duration and self.is_running:
            self.acquire_sample()
            time.sleep(self.sampling_interval)
            
            # Print progress every 10 samples
            if self.sample_count % 10 == 0:
                print(f"  Samples: {self.sample_count}, "
                      f"Last temp: {self.temperatures[-1]:.2f}°C, "
                      f"Control: {'ACTIVE' if self.control_output else 'INACTIVE'}")
    
    def _run_with_visualization(self, duration):
        """Run acquisition with live plotting"""
        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8))
        fig.suptitle('Temperature Data Acquisition System', fontsize=16, fontweight='bold')
        
        line_temp, = ax1.plot([], [], 'b-', linewidth=2, label='Temperature')
        line_threshold, = ax1.plot([], [], 'r--', linewidth=2, label='Threshold')
        ax1.set_xlabel('Time (seconds)')
        ax1.set_ylabel('Temperature (°C)')
        ax1.set_title('Real-Time Temperature Monitor')
        ax1.legend(loc='upper right')
        ax1.grid(True, alpha=0.3)
        
        # Status text
        status_text = ax2.text(0.5, 0.7, '', transform=ax2.transAxes,
                               fontsize=12, verticalalignment='center',
                               horizontalalignment='center',
                               bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
        ax2.axis('off')
        
        start_time = time.time()
        
        def animate(frame):
            if (time.time() - start_time) >= duration:
                self.is_running = False
                return line_temp, line_threshold, status_text
            
            if not self.is_running:
                return line_temp, line_threshold, status_text
            
            # Acquire new sample
            self.acquire_sample()
            
            # Update plot data
            if len(self.time_elapsed) > 0:
                line_temp.set_data(self.time_elapsed, self.temperatures)
                line_threshold.set_data(
                    [self.time_elapsed[0], self.time_elapsed[-1]],
                    [self.threshold, self.threshold]
                )
                
                # Auto-scale axes
                ax1.relim()
                ax1.autoscale_view()
            
            # Update status text
            status_str = f"Samples: {self.sample_count}\n"
            status_str += f"Current Temp: {self.temperatures[-1]:.2f}°C\n"
            status_str += f"Control Output: {'ACTIVE' if self.control_output else 'INACTIVE'}\n"
            status_str += f"Alerts: {len(self.alerts)}"
            status_text.set_text(status_str)
            
            return line_temp, line_threshold, status_text
        
        # Create animation
        anim = animation.FuncAnimation(
            fig, animate, interval=self.sampling_interval*1000,
            blit=True, repeat=False
        )
        
        plt.tight_layout()
        plt.show()
        
        self.is_running = False


def main():
    """
    Main function to run the DAQ simulation
    """
    print("\n" + "="*60)
    print("LAB 6: DATA ACQUISITION AND LOGGING SYSTEM")
    print("Python-based LabVIEW-like Virtual Instrument")
    print("="*60 + "\n")
    
    # Configuration
    BASE_TEMPERATURE = 26  # Celsius
    THRESHOLD = 35  # Celsius
    SAMPLING_RATE = 0.5  # Hz 
    DURATION = 40  # seconds
    
    # Create simulator instance
    daq = TemperatureDAQSimulator(
        base_temp=BASE_TEMPERATURE,
        threshold=THRESHOLD,
        sampling_rate=SAMPLING_RATE
    )
    
    # Run acquisition with live visualization
    daq.run_acquisition(duration=DURATION, show_plot=True)
    
    # Export data
    filename = daq.export_to_csv()
    
    # Print summary statistics
    print("\n" + "="*60)
    print("DATA SUMMARY")
    print("="*60)
    temps = np.array(daq.temperatures)
    print(f"Mean Temperature: {np.mean(temps):.2f}°C")
    print(f"Std Deviation: {np.std(temps):.2f}°C")
    print(f"Min Temperature: {np.min(temps):.2f}°C")
    print(f"Max Temperature: {np.max(temps):.2f}°C")
    
    valid_count = sum(daq.valid_flags)
    print(f"\nData Quality: {valid_count}/{daq.sample_count} valid samples "
          f"({valid_count/daq.sample_count*100:.1f}%)")
    
    if daq.alerts:
        print(f"\nAlerts Triggered: {len(daq.alerts)}")
        print("Alert Log:")
        for alert in daq.alerts[:5]:  # Show first 5 alerts
            print(f"  Sample {alert['sample']}: {alert['message']}")
    
    print("\n" + "="*60)
    print(f"✓ CSV file saved: {filename}")
    print("✓ Open this file in Excel or any spreadsheet software")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()